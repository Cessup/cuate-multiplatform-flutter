import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global loading state provider (Riverpod)
final loadingProvider = StateProvider<bool>((ref) => false);
