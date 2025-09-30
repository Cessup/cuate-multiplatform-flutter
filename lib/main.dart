import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:cuateapp/presentation/screens/global_loading_overlay.dart';
import 'presentation/router/router.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(ProviderScope(child: cuateappApp()));
}

class cuateappApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _cuateappState createState() => _cuateappState();
}

class _cuateappState extends State<cuateappApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);

      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print('Amplify already configured.');
    } catch (e) {
      print('Amplify init failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      builder: (context, child) {
        // Use Overlay to show loading UI above all pages
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            const GlobalLoadingOverlay(),
          ],
        );
      },
    );
  }
}
