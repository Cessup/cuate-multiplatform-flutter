import 'package:flutter_riverpod/legacy.dart';

/// Global loading state provider (Riverpod)
final loadingProvider = StateProvider<bool>((ref) => false);
