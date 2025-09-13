import '../../core/entities/user_aws.dart';

abstract class AuthRepository {
  Future<bool> signIn(String email, String password);
  Future<bool> signUp(User user, String password);
  Future<bool> signUpConfirm(String email, String code);
  Future<User> getCurrentUser();
  Future<bool> signOut();
  Future<void> resetPassword(String email);
  Future<bool> resetPasswordConfirm(
    String email,
    String code,
    String newPassword,
  );
}
