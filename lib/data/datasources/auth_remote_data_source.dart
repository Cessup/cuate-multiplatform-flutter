import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import '../../core/entities/user_aws.dart';
import '../../presentation/notifier/session/auth_state.dart';

abstract class AuthRemoteDataSource {
  Future<bool> signIn(String username, String password);
  Future<bool> signUp(String password, User user);
  Future<bool> signUpConfirm(String email, String code);
  Future<bool> signOut();
  Future<Map<String, String>?> getCurrentUser();
  Future<void> resetPassword(String email);
  Future<bool> resetPasswordConfirm(
    String email,
    String code,
    String newPassword,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<bool> signIn(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      debugPrint('AuthRemoteDataSourceImpl: $result');
      return result.isSignedIn;
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await Amplify.Auth.signOut();
      return true;
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<Map<String, String>?> getCurrentUser() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      return {
        for (var element in result) element.userAttributeKey.key: element.value,
      };
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await Amplify.Auth.resetPassword(username: email);
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<bool> resetPasswordConfirm(
    String email,
    String code,
    String newPassword,
  ) async {
    try {
      final result = await Amplify.Auth.confirmResetPassword(
        username: email,
        confirmationCode: code,
        newPassword: newPassword,
      );

      if (result.isPasswordReset) {
        return result.isPasswordReset;
      } else {
        throw AuthError('Password has been reset bad. Try again.');
      }
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<bool> signUp(String password, User user) async {
    try {
      var imageUrl = '';
      if (user.imagePath != null) {
        print('Uploaded profile picture: IMG IS UPLOAD');

        //final fileBytes = AWSFile.fromData(data);
        final fileBytes = AWSFile.fromPath(user.imagePath!);
        final fileName = StoragePath.fromString(
          'profile_pics/${user.email}_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        print('$fileName');
        final resultImg = await Amplify.Storage.uploadFile(
          localFile: fileBytes,
          path: fileName,
          options: StorageUploadFileOptions(
            metadata: {
              'uploaded_by': 'guest-user',
              'purpose': 'signup-profile-pic',
            },
            // Optional bucket override:
            //bucket: StorageBucket.global(),
          ),
        ).result;
        print('Uploaded profile picture: ${resultImg.uploadedItem.path}');
        imageUrl = resultImg.uploadedItem.path;
        debugPrint('Uploaded profile picture: ${resultImg.uploadedItem.path}');
      }

      final result = await Amplify.Auth.signUp(
        username: user.email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: user.email,
            CognitoUserAttributeKey.phoneNumber: user.phone,
            CognitoUserAttributeKey.nickname: user.nickname,
            CognitoUserAttributeKey.gender: user.gender,
            CognitoUserAttributeKey.familyName: user.familyName,
            CognitoUserAttributeKey.givenName: user.givenName,
            CognitoUserAttributeKey.address: user.address,
            CognitoUserAttributeKey.birthdate: user.birthdate,
            CognitoUserAttributeKey.picture: imageUrl,
          },
        ),
      );

      return result.isSignUpComplete;
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  @override
  Future<bool> signUpConfirm(String email, String code) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );
      return result.isSignUpComplete;
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }

  Future<StorageGetUrlResult> getProfilePictureUrl(String path) async {
    try {
      return await Amplify.Storage.getUrl(
        path: StoragePath.fromString(path),
      ).result;
    } on AuthException catch (e) {
      throw AuthError(e.message);
    }
  }
}
