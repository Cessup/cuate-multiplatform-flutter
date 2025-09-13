import '../../../core/entities/user_aws.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final bool isLoggin;
  final User? user;
  Authenticated(this.isLoggin, this.user);
}

class AuthReset extends AuthState {
  final bool isReset;
  AuthReset(this.isReset);
}

class AuthError {
  late final String message;
  AuthError(this.message);
}

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  signingIn,
  error,
}
