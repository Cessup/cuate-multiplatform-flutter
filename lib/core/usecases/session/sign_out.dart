import 'package:cuateapp/core/usecases/usercase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';
import '../no_params.dart';

class SignOut implements UseCase<Authenticated, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Authenticated> call(NoParams params) async {
    try {
      final result = await repository.signOut();
      return Authenticated(!result, null);
    } catch (e) {
      rethrow;
    }
  }
}
