import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';
import '../no_params.dart';
import '../usercase.dart';

class GetCurrentUser implements UseCase<Authenticated, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Authenticated> call(NoParams params) async {
    try {
      final result = await repository.getCurrentUser();
      return Authenticated(true, result);
    } catch (e) {
      rethrow;
    }
  }
}
