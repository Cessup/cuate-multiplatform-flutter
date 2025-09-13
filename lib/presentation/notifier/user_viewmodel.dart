import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/entities/user.dart';
import '../../core/usecases/no_params.dart';
import '../providers/user_provider.dart';

final userViewModelProvider = FutureProvider<User>((ref) async {
  final getUserLocal = ref.watch(getLocalUserProvider);
  return await getUserLocal(NoParams());
});
