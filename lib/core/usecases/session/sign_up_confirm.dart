import 'package:omega/core/usecases/usercase.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';

class SignUpConfirm implements UseCase<Authenticated, SignUpConfirmParams> {
  final AuthRepository repository;

  SignUpConfirm(this.repository);

  @override
  Future<Authenticated> call(SignUpConfirmParams params) async {
    return Authenticated(
        await repository.signUpConfirm(params.email, params.code), null);
  }
}

class SignUpConfirmParams extends Equatable {
  final String email;
  final String code;

  const SignUpConfirmParams({required this.email, required this.code});

  @override
  List<Object> get props => [email, code];
}
