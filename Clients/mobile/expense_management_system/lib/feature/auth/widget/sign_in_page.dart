import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/auth/provider/password_visibility_provider.dart';
import 'package:expense_management_system/feature/auth/state/auth_state.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);

class SignInPage extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorName.chatGradientStart,
              ColorName.chatGradientEnd,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              ColorName.chatGradientStart,
                              ColorName.chatGradientEnd,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Text(
                            "EMS",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          "Welcome back",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRequiredLabel("Email"),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
                                hintStyle: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: ColorName.blue,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildRequiredLabel("Password"),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText:
                                  !ref.watch(passwordVisibilityProvider),
                              decoration: InputDecoration(
                                hintText: "Enter password",
                                hintStyle: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: ColorName.blue,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ref
                                            .read(passwordVisibilityProvider
                                                .notifier)
                                            .state =
                                        !ref.read(passwordVisibilityProvider);
                                  },
                                  child: Icon(
                                    ref.watch(passwordVisibilityProvider)
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        ref
                                            .read(isLoadingProvider.notifier)
                                            .state = true;

                                        try {
                                          await ref
                                              .read(
                                                  authNotifierProvider.notifier)
                                              .login(_emailController.text,
                                                  _passwordController.text);

                                          // Read auth state after login has been processed
                                          final authState =
                                              ref.read(authNotifierProvider);

                                          if (authState is AuthStateLoggedIn) {
                                            // This is the critical addition - refresh app start state
                                            ref
                                                .read(
                                                    isLoadingProvider.notifier)
                                                .state = false;
                                            await ref
                                                .read(appStartNotifierProvider
                                                    .notifier)
                                                .refreshState();

                                            if (context.mounted) {
                                              AppSnackBar.showSuccess(
                                                  context: context,
                                                  message:
                                                      'Log in successfully');

                                              // Optional: the navigation may not be needed when using appStartNotifierProvider
                                              // as it will automatically show HomePage when state is authenticated
                                              context.go('/');
                                            }
                                          }
                                        } catch (e, stackTrace) {
                                          print("Login error: $e");
                                          print("Stack trace: $stackTrace");

                                          // Show error to user
                                          if (context.mounted) {
                                            AppSnackBar.showError(
                                                context: context,
                                                message:
                                                    'Login failed. Please check your credentials.');
                                          }
                                        } finally {
                                          // ALWAYS ensure loading state is turned off
                                          if (context.mounted) {
                                            ref
                                                .read(
                                                    isLoadingProvider.notifier)
                                                .state = false;
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF386BF6),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                  disabledBackgroundColor:
                                      const Color(0xFF386BF6).withOpacity(0.7),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "LOG IN",
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.go('/signUp'),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: ColorName.blue,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String label) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const TextSpan(
            text: "*",
            style: TextStyle(
              fontFamily: 'Nunito',
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
