import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cuateapp/core/usecases/session/sign_in.dart';
import 'auth_state.dart';

class SignInNotifier extends StateNotifier<AsyncValue<Authenticated>> {
  late final SignIn signIn;

  SignInNotifier({required this.signIn}) : super(const AsyncValue.loading());

  Future<void> login(SignInParams signInParams) async {
    try {
      final result = await signIn(signInParams);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
