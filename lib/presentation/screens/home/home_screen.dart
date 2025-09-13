import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(signInNotifier as ProviderListenable);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('User'),
      ),
      child: SafeArea(
        child: userAsyncValue.when(
          data: (user) => Center(
            child: Text('Hello, ${user.name}!',
                style: CupertinoTheme.of(context).textTheme.textStyle),
          ),
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error',
                style: CupertinoTheme.of(context).textTheme.textStyle),
          ),
        ),
      ),
    );
  }
}
