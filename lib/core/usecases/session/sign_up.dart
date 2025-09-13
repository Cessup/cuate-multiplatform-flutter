import 'package:omega/core/usecases/usercase.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../presentation/notifier/session/auth_state.dart';
import '../../entities/user_aws.dart';

class SignUp implements UseCase<Authenticated, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Authenticated> call(SignUpParams params) async {
    return Authenticated(
      await repository.signUp(
        User(
          params.email,
          params.phone,
          params.nickname,
          params.familyName,
          params.givenName,
          params.address,
          params.gender,
          params.birthdate,
          params.path,
        ),
        params.password,
      ),
      null,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String phone;
  final String nickname;
  final String familyName;
  final String givenName;
  final String address;
  final String gender;
  final String birthdate;
  final String? path;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.phone,
    required this.nickname,
    required this.familyName,
    required this.givenName,
    required this.address,
    required this.gender,
    required this.birthdate,
    required this.path,
  });

  @override
  List<Object> get props => [
    email,
    password,
    phone,
    nickname,
    familyName,
    givenName,
    address,
    gender,
    birthdate,
    ?path,
  ];
}
