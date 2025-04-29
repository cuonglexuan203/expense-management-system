import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:expense_management_system/feature/onboarding/provider/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

class PasscodeStep extends ConsumerStatefulWidget {
  const PasscodeStep({Key? key}) : super(key: key);

  @override
  ConsumerState<PasscodeStep> createState() => _PasscodeStepState();
}

class _PasscodeStepState extends ConsumerState<PasscodeStep>
    with SingleTickerProviderStateMixin {
  final int _passcodeLength = 4;
  String _passcode = '';
  String _confirmPasscode = '';
  bool _isConfirming = false;
  String? _errorMessage;
  bool _showBiometricOption = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  late AnimationController _animationController;
  late Animation<double> _animation;

  final biometricsEnabledProvider = FutureProvider<bool>((ref) async {
    final repo = ref.watch(passcodeRepositoryProvider);
    return await repo.isBiometricsEnabled();
  });

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();

    // Initialize animation for error shake effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics &&
          isDeviceSupported &&
          availableBiometrics.isNotEmpty) {
        await ref.read(passcodeRepositoryProvider).setBiometricsEnabled(true);
        setState(() {
          _showBiometricOption = true;
        });
      } else {
        setState(() {
          _showBiometricOption = false;
        });
      }
    } catch (e) {
      setState(() {
        _showBiometricOption = false;
      });
    }
  }

  void _onNumberPressed(int number) {
    setState(() {
      if (_isConfirming) {
        if (_confirmPasscode.length < _passcodeLength) {
          _confirmPasscode += number.toString();

          if (_confirmPasscode.length == _passcodeLength) {
            _validatePasscodes();
          }
        }
      } else {
        if (_passcode.length < _passcodeLength) {
          _passcode += number.toString();

          if (_passcode.length == _passcodeLength) {
            setState(() {
              _isConfirming = true;
            });
          }
        }
      }
    });
  }

  void _onDelete() {
    setState(() {
      if (_isConfirming && _confirmPasscode.isNotEmpty) {
        _confirmPasscode =
            _confirmPasscode.substring(0, _confirmPasscode.length - 1);
      } else if (!_isConfirming && _passcode.isNotEmpty) {
        _passcode = _passcode.substring(0, _passcode.length - 1);
      }
      _errorMessage = null;
    });
  }

  void _validatePasscodes() {
    if (_passcode == _confirmPasscode) {
      ref.read(onboardingNotifierProvider.notifier).updatePasscode(_passcode);
      ref.read(passcodeRepositoryProvider).setPasscode(_passcode);
      setState(() {
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = 'Passcodes do not match. Please try again.';
        _isConfirming = false;
        _passcode = '';
        _confirmPasscode = '';
      });

      // Play shake animation for error feedback
      _animationController.forward().then((_) => _animationController.reset());
    }
  }

  void _resetPasscode() {
    setState(() {
      _passcode = '';
      _confirmPasscode = '';
      _isConfirming = false;
      _errorMessage = null;
    });
  }

  Future<void> _enableBiometrics(bool value) async {
    await ref.read(passcodeRepositoryProvider).setBiometricsEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with icon
            const SizedBox(height: 10),
            Icon(
              _isConfirming ? Icons.verified_user : Icons.security,
              size: 48,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
            const SizedBox(height: 20),

            // Title text
            Text(
              _isConfirming ? 'Confirm Your Passcode' : 'Create Your Passcode',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description text
            Text(
              _isConfirming
                  ? 'Please re-enter your passcode to verify'
                  : 'Set a 4-digit passcode to secure your account',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'Nunito',
                    color: Colors.black54,
                    height: 1.3,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Passcode dots with animation
            Transform.translate(
              offset: Offset(_errorMessage != null ? _animation.value : 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_passcodeLength, (index) {
                  final currentString =
                      _isConfirming ? _confirmPasscode : _passcode;
                  final isFilled = index < currentString.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: isFilled ? 20 : 16,
                    height: isFilled ? 20 : 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isFilled
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade400,
                        width: 1.5,
                      ),
                      boxShadow: isFilled
                          ? [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ),

            // Error message with animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _errorMessage != null ? 50 : 0,
              child: Center(
                child: _errorMessage != null
                    ? Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            // Number pad with modern design
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    // Reset button
                    return _buildSpecialButton(
                      icon: Icons.refresh_rounded,
                      onTap: _resetPasscode,
                      color: Colors.amber,
                    );
                  } else if (index == 10) {
                    // 0 button
                    return _buildNumberButton(0);
                  } else if (index == 11) {
                    // Delete button
                    return _buildSpecialButton(
                      icon: Icons.backspace_outlined,
                      onTap: _onDelete,
                      color: Colors.redAccent.withOpacity(0.9),
                    );
                  } else {
                    // 1-9 buttons
                    return _buildNumberButton(index + 1);
                  }
                },
              ),
            ),

            const SizedBox(height: 30),

            // Biometric option with modern switch
            if (_showBiometricOption && !_isConfirming && _passcode.isEmpty)
              ref.watch(biometricsEnabledProvider).when(
                    data: (isEnabled) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.fingerprint,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.8),
                            size: 28,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Biometric Unlock',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                Text(
                                  'Use fingerprint or face ID to quickly access the app',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            onChanged: _enableBiometrics,
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox(),
                  ),

            const SizedBox(height: 20),

            // Footer note text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'You\'ll need this passcode to access your financial data securely.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(int number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNumberPressed(number),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
