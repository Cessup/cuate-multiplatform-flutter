import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/usecases/session/reset_password.dart';
import '../../../core/usecases/session/reset_password_confirm.dart';
import 'auth_state.dart';

class ForgotPasswordNotifier extends StateNotifier<AsyncValue<AuthReset>> {
  late final ResetPassword resetPassword;
  late final ResetPasswordConfirm resetPasswordConfirm;

  ForgotPasswordNotifier({
    required this.resetPassword,
    required this.resetPasswordConfirm,
  }) : super(const AsyncValue.loading());

  Future<void> requestReset(String email) async {
    try {
      if (email.isEmpty) {
        state = AsyncValue.error(
          Exception('Email can not be empty'),
          StackTrace as StackTrace,
        );
        return;
      }

      final resetPasswordParams = ResetPasswordParams(email);
      final result = await resetPassword(resetPasswordParams);

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> codeConfirm(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      if (code.isEmpty || newPassword.isEmpty) {
        state = AsyncValue.error(
          Exception('Please enter the reset code and new password'),
          StackTrace as StackTrace,
        );
        return;
      }

      final resetPasswordConfirmParams = ResetPasswordConfirmParams(
        email,
        code,
        newPassword,
      );
      final result = await resetPasswordConfirm(resetPasswordConfirmParams);

      debugPrint('ForgotPasswordNotifier: codeConfirm: $result');
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
