import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/usecases/session/sign_in.dart';
import '../../notifier/session/auth_state.dart';
import '../../providers/general_provider.dart';
import '../../providers/user_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn() async {
    ref.read(loadingProvider.notifier).state = true;
    final params = SignInParams(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    await ref.read(signInNotifier.notifier).login(params);
    final signInAsync = ref.read(signInNotifier);

    signInAsync.when(
      data: (authState) {
        ref.read(loadingProvider.notifier).state = false;
        if (authState.isLoggin) {
          // ignore: use_build_context_synchronously
          context.go('/profile');
        } else {
          _showDialog('Error Sign In', 'Error in authentication');
        }
      },
      loading: () => ref.read(loadingProvider.notifier).state = true,
      error: (error, _) {
        ref.read(loadingProvider.notifier).state = false;
        _showDialog('Error Sign Out', (error as AuthError).message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('iCONDOMINIUM',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 80),
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CupertinoButton(
                  onPressed: () {
                    context.push('/forgot_password');
                  },
                  child: const Text('Forgot Password'),
                ),
              ]),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: CupertinoButton.filled(
                  onPressed: _signIn,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Do not have an account?',
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .textStyle
                      .copyWith(fontSize: 16),
                ),
                CupertinoButton(
                  onPressed: () {
                    context.push('/sign_up');
                  },
                  child: const Text('Sign Up'),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
