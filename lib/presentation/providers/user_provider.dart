import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/usecases/profile/GetCurrentUser.dart';
import '../../core/usecases/get_user_local.dart';
import '../../core/usecases/session/reset_password.dart';
import '../../core/usecases/session/reset_password_confirm.dart';
import '../../core/usecases/session/sign_in.dart';
import '../../core/usecases/session/sign_out.dart';
import '../../core/usecases/session/sign_up.dart';
import '../../core/usecases/session/sign_up_confirm.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../notifier/profile/profile_notifier.dart';
import '../notifier/session/auth_state.dart';
import '../notifier/session/forgot_password_notifier.dart';
import '../notifier/session/sign_in_notifier.dart';
import '../notifier/session/sign_up_notifier.dart';

//DataSources
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl();
});

//Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = AuthRemoteDataSourceImpl();
  return AuthRepositoryImpl(dataSource: dataSource);
});

//Use case Provider
final getLocalUserProvider = Provider<GetUserLocal>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserLocal(repository);
});

final getUserProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

final signInProvider = Provider<SignIn>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignIn(repo);
});

final signOutProvider = Provider<SignOut>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignOut(repo);
});

final resetPasswordProvider = Provider<ResetPassword>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPassword(repository);
});

final resetPasswordConfirmProvider = Provider<ResetPasswordConfirm>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordConfirm(repository);
});

final signUpUseCaseProvider = Provider<SignUp>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUp(repository);
});

final signUpConfirmProvider = Provider<SignUpConfirm>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpConfirm(repository);
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

//Notifier
final signInNotifier =
    StateNotifierProvider<SignInNotifier, AsyncValue<Authenticated>>((ref) {
  final signIn = ref.watch(signInProvider);
  return SignInNotifier(signIn: signIn);
});

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<Authenticated>>((ref) {
  final getCurrentUser = ref.watch(getUserProvider);
  final signOut = ref.watch(signOutProvider);
  return ProfileNotifier(getCurrentUser: getCurrentUser, signOut: signOut);
});

final resetPasswordNotifier =
    StateNotifierProvider<ForgotPasswordNotifier, AsyncValue<AuthReset>>((ref) {
  final resetPassword = ref.watch(resetPasswordProvider);
  final resetPasswordConfirm = ref.watch(resetPasswordConfirmProvider);
  return ForgotPasswordNotifier(
      resetPassword: resetPassword, resetPasswordConfirm: resetPasswordConfirm);
});

final signUpNotifier =
    StateNotifierProvider<SignUpNotifier, AsyncValue<Authenticated>>((ref) {
  final signUp = ref.watch(signUpUseCaseProvider);
  final signUpConfirm = ref.watch(signUpConfirmProvider);
  return SignUpNotifier(signUp: signUp, signUpConfirm: signUpConfirm);
});
