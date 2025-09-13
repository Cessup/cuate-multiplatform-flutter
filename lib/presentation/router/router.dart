import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/session/forgot_password_screen.dart';
import '../screens/session/sign_in_screen.dart';
import '../screens/session/sign_up_screen.dart';

var routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign_in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/sign_up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
