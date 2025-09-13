import 'package:omega/core/usecases/usercase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';

class SignIn implements UseCase<Authenticated, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Authenticated> call(SignInParams params) async {
    try {
      final result = await repository.signIn(params.email, params.password);
      return Authenticated(result, null);
    } catch (e) {
      rethrow;
    }
  }
}

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}
