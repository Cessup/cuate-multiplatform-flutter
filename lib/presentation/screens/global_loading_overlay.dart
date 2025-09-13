import 'package:flutter/cupertino.dart'
    show
        BuildContext,
        Center,
        Container,
        CupertinoActivityIndicator,
        CupertinoColors,
        SizedBox,
        Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/general_provider.dart';

class GlobalLoadingOverlay extends ConsumerWidget {
  const GlobalLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: CupertinoColors.systemGrey.withOpacity(0.4),
      child: const Center(
        child: CupertinoActivityIndicator(radius: 18),
      ),
    );
  }
}
