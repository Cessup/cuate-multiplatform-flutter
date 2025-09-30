import 'package:cuateapp/core/usecases/usercase.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';

class ResetPassword implements UseCase<AuthReset, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<AuthReset> call(ResetPasswordParams params) async {
    try {
      await repository.resetPassword(params.email);
      return AuthReset(true);
    } catch (e) {
      rethrow;
    }
  }
}

class ResetPasswordParams extends Equatable {
  final String email;

  const ResetPasswordParams(this.email);

  @override
  List<Object> get props => [email];
}
