import 'package:omega/core/usecases/usercase.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';

class ResetPasswordConfirm
    implements UseCase<AuthReset, ResetPasswordConfirmParams> {
  final AuthRepository repository;

  ResetPasswordConfirm(this.repository);

  @override
  Future<AuthReset> call(ResetPasswordConfirmParams params) async {
    try {
      final result = await repository.resetPasswordConfirm(
          params.email, params.code, params.newPassword);
      return AuthReset(result);
    } catch (e) {
      rethrow;
    }
  }
}

class ResetPasswordConfirmParams extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordConfirmParams(this.email, this.code, this.newPassword);

  @override
  List<Object> get props => [email];
}
