import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/usecases/session/sign_up.dart';
import '../../../core/usecases/session/sign_up_confirm.dart';
import 'auth_state.dart';

class SignUpNotifier extends StateNotifier<AsyncValue<Authenticated>> {
  late final SignUp signUp;
  late final SignUpConfirm signUpConfirm;

  SignUpNotifier({required this.signUp, required this.signUpConfirm})
    : super(const AsyncValue.loading());

  Future<void> register(
    email,
    emailConfirm,
    password,
    passwordConfirm,
    phone,
    nickname,
    familyName,
    givenName,
    address,
    gender,
    birthdate,
    path,
  ) async {
    if (!validateInputs(
      email,
      emailConfirm,
      password,
      passwordConfirm,
      phone,
      nickname,
      familyName,
      givenName,
      address,
      birthdate,
    )) {
      return;
    }

    final signUpParams = SignUpParams(
      email: email,
      password: password,
      phone: phone,
      nickname: nickname,
      familyName: familyName,
      givenName: givenName,
      address: address,
      gender: gender,
      birthdate: birthdate,
      path: path,
    );

    state = AsyncValue.data(await signUp(signUpParams));
  }

  bool validateInputs(
    String email,
    String confirmEmail,
    String password,
    String confirmPassword,
    String phone,
    String nickname,
    String familyName,
    String givenName,
    String address,
    String birthdate,
  ) {
    final birthdateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    final nicknameRegex = RegExp(r'^[A-Za-z]+$'); // No spaces, only letters
    final phoneRegex = RegExp(r'^\+\d{12}$');

    if (email != confirmEmail) {
      state = AsyncValue.error(
        Exception('Emails do not match'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (password != confirmPassword) {
      state = AsyncValue.error(
        Exception('Passwords do not match'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (!phoneRegex.hasMatch(phone)) {
      state = AsyncValue.error(
        Exception('Format of phone number is +521234567890'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (!nicknameRegex.hasMatch(nickname)) {
      state = AsyncValue.error(
        Exception('Nickname cannot contain spaces'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (familyName.length > 20) {
      state = AsyncValue.error(
        Exception('Family name must be under 20 characters'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (givenName.length > 20) {
      state = AsyncValue.error(
        Exception('Given name must be under 20 characters'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (address.length > 100) {
      state = AsyncValue.error(
        Exception('Address must be under 100 characters'),
        StackTrace as StackTrace,
      );
      return false;
    }
    if (!birthdateRegex.hasMatch(birthdate)) {
      state = AsyncValue.error(
        Exception('Birthdate must be in YYYY-MM-DD format'),
        StackTrace as StackTrace,
      );
      return false;
    }

    return true;
  }

  Future<void> codeConfirm(email, code) async {
    if (email.isEmpty || code.isEmpty) {
      state = AsyncValue.error(Exception, StackTrace as StackTrace);
      return;
    }

    final signUpConfirmParams = SignUpConfirmParams(email: email, code: code);

    state = AsyncValue.data(await signUpConfirm(signUpConfirmParams));
  }
}
