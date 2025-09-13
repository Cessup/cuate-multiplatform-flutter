import '../../core/entities/user_aws.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/notifier/session/auth_state.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<bool> signIn(String email, String password) async {
    try {
      final result = await dataSource.signIn(email, password);
      return result;
    } on AuthError {
      rethrow;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      return await dataSource.signOut();
    } on AuthError {
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final result = await dataSource.getCurrentUser();
      if (result != null) {
        return User(
          getValue(result, 'email', defaultValue: '-'),
          getValue(result, 'phone_number', defaultValue: '-'),
          getValue(result, 'nickname', defaultValue: '-'),
          getValue(result, 'family_name', defaultValue: '-'),
          getValue(result, 'given_name', defaultValue: '-'),
          getValue(result, 'address', defaultValue: '-'),
          getValue(result, 'gender', defaultValue: '-'),
          getValue(result, 'birthdate', defaultValue: '-'),
          getValue(result, 'imagePath', defaultValue: '-'),
        );
      } else {
        throw AuthError('There is a problem with your user');
      }
    } on AuthError {
      rethrow;
    }
  }

  String getValue(
    Map<String, String> map,
    String key, {
    String defaultValue = '',
  }) {
    return map[key] ?? defaultValue;
  }

  @override
  Future<bool> signUp(User user, String password) async {
    try {
      return await dataSource.signUp(password, user);
    } on AuthError {
      rethrow;
    }
  }

  @override
  Future<bool> signUpConfirm(String email, String code) async {
    try {
      return await dataSource.signUpConfirm(email, code);
    } on AuthError {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
    } on AuthError {
      rethrow;
    }
  }

  @override
  Future<bool> resetPasswordConfirm(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      return await dataSource.resetPasswordConfirm(email, code, newPassword);
    } on AuthError {
      rethrow;
    }
  }
}
