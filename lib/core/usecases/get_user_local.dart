import 'package:omega/core/entities/user.dart';
import 'package:omega/core/usecases/usercase.dart';
import '../../domain/repositories/user_repository.dart';
import 'no_params.dart';

class GetUserLocal implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetUserLocal(this.repository);

  @override
  Future<User> call(NoParams params) async {
    return await repository.getUser();
  }
}
