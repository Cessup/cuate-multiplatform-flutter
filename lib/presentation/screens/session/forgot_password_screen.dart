import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifier/session/auth_state.dart';
import '../../providers/general_provider.dart';
import '../../providers/user_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();

  String message = '';
  bool isCodeSent = false;

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _resetPassword() async {
    ref.read(loadingProvider.notifier).state = true;
    await ref
        .watch(resetPasswordNotifier.notifier)
        .requestReset(emailController.text.trim());

    final resetPasswordAsync = ref.read(resetPasswordNotifier);

    resetPasswordAsync.when(
        data: (authState) {
          debugPrint('Forgot: $authState');
          ref.read(loadingProvider.notifier).state = false;
          setState(() {
            isCodeSent = true;
          });
        },
        loading: () => ref.read(loadingProvider.notifier).state = true,
        error: (error, _) {
          ref.read(loadingProvider.notifier).state = false;
          _showDialog('Error Sign Out', (error as AuthError).message);
        });
  }

  void _confirmCode() async {
    ref.read(loadingProvider.notifier).state = true;
    await ref.watch(resetPasswordNotifier.notifier).codeConfirm(
        emailController.text.trim(),
        codeController.text.trim(),
        newPasswordController.text.trim());

    final resetPasswordConfirmAsync = ref.read(resetPasswordNotifier);

    resetPasswordConfirmAsync.when(
        data: (authState) {
          ref.read(loadingProvider.notifier).state = false;
          // ignore: use_build_context_synchronously
          context.push('/profile');
        },
        loading: () => ref.read(loadingProvider.notifier).state = true,
        error: (error, _) {
          ref.read(loadingProvider.notifier).state = false;
          _showDialog('Error Sign Out', (error as AuthError).message);
        });
  }

  // Build text fields for email, code, and new password
  Widget buildTextField(String label, TextEditingController controller,
      {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CupertinoTextField(
        controller: controller,
        placeholder: label,
        obscureText: obscure,
        keyboardType: keyboardType,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar:
          const CupertinoNavigationBar(middle: Text('Forgot Password')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal:
                screenWidth > 600 ? 30 : 16, // Padding for bigger screens
            vertical: 16,
          ),
          child: Column(
            children: [
              if (!isCodeSent) ...[
                buildTextField('Enter your email', emailController,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 40),
                CupertinoButton.filled(
                  onPressed: _resetPassword,
                  child: const Text('Send Reset Code'),
                ),
              ] else ...[
                buildTextField('Enter reset code', codeController),
                buildTextField('Enter new password', newPasswordController,
                    obscure: true),
                const SizedBox(height: 40),
                CupertinoButton.filled(
                  onPressed: _confirmCode,
                  child: const Text('Reset Password'),
                ),
              ],
              const SizedBox(height: 12),
              Text(message),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
