// lib/feature/auth/widget/passcode_verification_page.dart
import 'dart:developer' show log;
import 'dart:ui';

import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class PasscodeVerificationPage extends ConsumerStatefulWidget {
  const PasscodeVerificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PasscodeVerificationPage> createState() =>
      _PasscodeVerificationPageState();
}

class _PasscodeVerificationPageState
    extends ConsumerState<PasscodeVerificationPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final int _passcodeLength = 4;
  String _enteredPasscode = '';
  String? _errorMessage;
  bool _isVerifying = false;
  int _remainingAttempts = 5;
  bool _isLockedOut = false;
  int _lockoutEndTime = 0;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _biometricsAvailable = false;
  late AnimationController _animationController;
  late Animation<double> _errorAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAuth();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _errorAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _biometricsAvailable &&
        !_isLockedOut) {
      Future.delayed(const Duration(milliseconds: 500), _tryBiometricAuth);
    }
  }

  // Authentication methods (remain the same)
  Future<void> _initializeAuth() async {
    await _checkFailedAttempts();
    await _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final repository = ref.read(passcodeRepositoryProvider);
      final isBiometricsEnabled = await repository.isBiometricsEnabled();

      if (isBiometricsEnabled) {
        final canCheckBiometrics = await _localAuth.canCheckBiometrics;
        final isDeviceSupported = await _localAuth.isDeviceSupported();
        final availableBiometrics = await _localAuth.getAvailableBiometrics();

        setState(() {
          _biometricsAvailable = canCheckBiometrics &&
              isDeviceSupported &&
              availableBiometrics.isNotEmpty;
        });
      }
    } catch (e) {
      setState(() {
        _biometricsAvailable = false;
      });
    }
  }

  Future<void> _checkFailedAttempts() async {
    try {
      final repository = ref.read(passcodeRepositoryProvider);
      final attempts = await repository.getFailedAttempts();
      final isLocked = await repository.isLockedOut();

      setState(() {
        _remainingAttempts = 5 - attempts;
        _isLockedOut = isLocked;
        if (_isLockedOut) {
          _lockoutEndTime =
              DateTime.now().millisecondsSinceEpoch + (1 * 60 * 1000);
        }
      });

      if (_isLockedOut) {
        _startLockoutTimer();
      }
    } catch (e) {
      log("Error checking failed attempts: $e");
    }
  }

  void _startLockoutTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < _lockoutEndTime) {
        final remainingSeconds = (_lockoutEndTime - now) ~/ 1000;
        setState(() {
          _errorMessage = 'Try again in ${remainingSeconds}s';
        });
        _startLockoutTimer();
      } else {
        setState(() {
          _isLockedOut = false;
          _errorMessage = null;
        });

        _checkBiometricAvailability().then((_) {
          if (_biometricsAvailable) {
            _tryBiometricAuth();
          }
        });
      }
    });
  }

  Future<void> _tryBiometricAuth() async {
    if (!mounted || _isVerifying || _isLockedOut) return;

    setState(() {
      _isVerifying = true;
    });

    final repository = ref.read(passcodeRepositoryProvider);

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        authMessages: [
          const AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            biometricHint: 'Verify identity',
            cancelButton: 'Use Passcode',
          ),
          const IOSAuthMessages(
            cancelButton: 'Enter passcode instead',
            goToSettingsButton: 'Settings',
            goToSettingsDescription:
                'Please set up biometrics in your device settings',
            localizedFallbackTitle: 'Use passcode to continue',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );

      if (authenticated) {
        HapticFeedback.mediumImpact();
        await repository.updateVerificationTime();
        await repository.resetFailedAttempts();
        ref.read(appStartNotifierProvider.notifier).authenticateUser();
      } else {
        setState(() {
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'Please enter passcode';
      });
    }
  }

  void _onNumberPressed(int number) {
    if (_isLockedOut || _isVerifying) return;
    HapticFeedback.selectionClick();

    setState(() {
      if (_enteredPasscode.length < _passcodeLength) {
        _enteredPasscode += number.toString();
        _errorMessage = null;

        if (_enteredPasscode.length == _passcodeLength) {
          _verifyPasscode();
        }
      }
    });
  }

  void _onDelete() {
    if (_isLockedOut || _isVerifying) return;
    HapticFeedback.lightImpact();

    setState(() {
      if (_enteredPasscode.isNotEmpty) {
        _enteredPasscode =
            _enteredPasscode.substring(0, _enteredPasscode.length - 1);
      }
      _errorMessage = null;
    });
  }

  Future<void> _verifyPasscode() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      final repository = ref.read(passcodeRepositoryProvider);
      final isCorrect = await repository.verifyPasscode(_enteredPasscode);

      if (isCorrect) {
        HapticFeedback.mediumImpact();
        ref.read(appStartNotifierProvider.notifier).authenticateUser();
      } else {
        HapticFeedback.heavyImpact();
        final attempts = await repository.getFailedAttempts();
        final isLocked = await repository.isLockedOut();

        setState(() {
          _enteredPasscode = '';
          _isVerifying = false;
          _remainingAttempts = 5 - attempts;
          _isLockedOut = isLocked;

          if (_isLockedOut) {
            _lockoutEndTime =
                DateTime.now().millisecondsSinceEpoch + (1 * 60 * 1000);
            _errorMessage = 'Too many attempts';
            _startLockoutTimer();
          } else {
            _errorMessage = 'Incorrect ($_remainingAttempts attempts left)';
            _animationController.forward();
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Please try again';
        _enteredPasscode = '';
        _isVerifying = false;
        _animationController.forward();
      });
    }
  }

  // COMPLETELY REDESIGNED BUILD METHOD TO FIX OVERFLOW
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Dynamically calculate sizes based on screen height
    final isSmallScreen = screenHeight < 700;
    final logoSize = screenHeight * 0.12;
    final buttonSize = screenWidth * 0.2;
    final verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Section
                  Column(
                    children: [
                      SizedBox(height: verticalSpacing),

                      // Logo
                      Container(
                        width: logoSize,
                        height: logoSize,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.lock,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),

                      SizedBox(height: verticalSpacing),

                      // Title
                      Text(
                        'Enter Passcode',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                        ),
                      ),

                      SizedBox(height: verticalSpacing / 2),

                      // Subtitle
                      Text(
                        'Please enter your 4-digit passcode to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withOpacity(0.7),
                          fontSize: isSmallScreen ? 12 : 14,
                          fontFamily: 'Nunito',
                        ),
                      ),

                      SizedBox(height: verticalSpacing),

                      // Passcode Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_passcodeLength, (index) {
                          final isFilled = index < _enteredPasscode.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: isFilled ? 16 : 14,
                            height: isFilled ? 16 : 14,
                            decoration: BoxDecoration(
                              color: isFilled
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isFilled
                                    ? theme.colorScheme.primary
                                    : Colors.grey.withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      ),

                      // Error Message
                      if (_errorMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: verticalSpacing),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Keypad Section
                  Column(
                    children: [
                      _buildKeypadRow([1, 2, 3], buttonSize),
                      SizedBox(height: verticalSpacing),
                      _buildKeypadRow([4, 5, 6], buttonSize),
                      SizedBox(height: verticalSpacing),
                      _buildKeypadRow([7, 8, 9], buttonSize),
                      SizedBox(height: verticalSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _biometricsAvailable
                              ? _buildBiometricKey(buttonSize)
                              : SizedBox(width: buttonSize),
                          _buildNumberKey(0, buttonSize),
                          _buildDeleteKey(buttonSize),
                        ],
                      ),
                    ],
                  ),

                  // Forgot Passcode Section
                  Padding(
                    padding: EdgeInsets.only(bottom: verticalSpacing),
                    child: TextButton(
                      onPressed: _isLockedOut
                          ? null
                          : () => _showForgotPasscodeDialog(context),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: Text(
                        'Forgot Passcode?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for building keypad rows
  Widget _buildKeypadRow(List<int> numbers, double buttonSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          numbers.map((number) => _buildNumberKey(number, buttonSize)).toList(),
    );
  }

  Widget _buildNumberKey(int number, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: _isLockedOut ? null : () => _onNumberPressed(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          elevation: 1,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade400,
        ),
        child: Text(
          number.toString(),
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed:
            (_isLockedOut || _enteredPasscode.isEmpty) ? null : _onDelete,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          elevation: 1,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade400,
        ),
        child: Icon(
          Iconsax.tag_cross,
          size: size * 0.3,
        ),
      ),
    );
  }

  Widget _buildBiometricKey(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: _isLockedOut ? null : _tryBiometricAuth,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: Icon(
          Iconsax.finger_cricle,
          size: size * 0.4,
        ),
      ),
    );
  }

  void _showForgotPasscodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Forgot Passcode?'),
        content: const Text(
          'If you forgot your passcode, you\'ll need to sign out and sign in again to reset it.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSignOut(context);
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    late BuildContext dialogContext;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        dialogContext = ctx;
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Signing out...'),
            ],
          ),
        );
      },
    );

    try {
      await ref.read(authNotifierProvider.notifier).logout();

      if (dialogContext.mounted) {
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      await ref.read(appStartNotifierProvider.notifier).refreshState();
    } catch (e, stackTrace) {
      log('Logout error: $e', stackTrace: stackTrace);

      if (dialogContext.mounted) {
        Navigator.of(dialogContext, rootNavigator: true).pop();
      }

      if (context.mounted) {
        AppSnackBar.showError(
          context: context,
          message: 'Sign out failed. Please try again.',
        );
      }
    }
  }
}
