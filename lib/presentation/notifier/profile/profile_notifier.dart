import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/profile/GetCurrentUser.dart';
import '../../../core/usecases/session/sign_out.dart';
import '../session/auth_state.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<Authenticated>> {
  late final GetCurrentUser getCurrentUser;
  late final SignOut signOut;

  ProfileNotifier({required this.getCurrentUser, required this.signOut})
      : super(const AsyncValue.loading()) {
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    try {
      final result = await getCurrentUser(NoParams());
      debugPrint('ProfileNotifier: ${result.user!.email}');
      state = AsyncValue.data(result);
    } catch (e, st) {
      debugPrint('ProfileNotifier: $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logOut() async {
    try {
      final result = await signOut(NoParams());
      debugPrint('ProfileNotifier: $result');
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
