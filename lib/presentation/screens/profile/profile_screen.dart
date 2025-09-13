import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../notifier/session/auth_state.dart';
import '../../providers/general_provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String message = '';
  Map<String, String> dataMap = {};

/*
  void _onItemTap(String key, String value) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(key),
        content: Text('Value: $value'),
        actions: [
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }*/

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

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CupertinoTextField(
        controller: controller,
        placeholder: label,
        obscureText: obscure,
        keyboardType: keyboardType,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _logOut() async {
    await ref.read(profileProvider.notifier).logOut();
    final signOutAsync = ref.watch(profileProvider);

    signOutAsync.when(
      data: (authenticatedState) {
        ref.read(loadingProvider.notifier).state = false;
        if (authenticatedState.isLoggin) {
          _showDialog('Error SignOut', 'We can not logout');
        } else {
          // ignore: use_build_context_synchronously
          context.go('/sign_in');
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
    final baseStyle = CupertinoTheme.of(context).textTheme.textStyle;

    final userAsync = ref.watch(profileProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _logOut,
          child: Text('Logout'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: userAsync.when(
              data: (authenticated) {
                debugPrint('ProfileScreen: ${authenticated.user}');
                if (authenticated.user != null) {
                  Map<String, String> fetchedData = {
                    'Name':
                        '${authenticated.user!.givenName} ${authenticated.user!.familyName}',
                    'Email': '${authenticated.user!.email} ',
                    'Phone': '${authenticated.user!.phone} ',
                    'Address': '${authenticated.user!.address} ',
                    'Birthdate': '${authenticated.user!.birthdate} ',
                    'Gender': '${authenticated.user!.gender} ',
                  };

                  dataMap = fetchedData;
                }

                return Column(children: [
                  SafeArea(
                      child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Text('Contact Information',
                                  style: baseStyle.copyWith(fontSize: 16)),
                            ),
                            SizedBox(
                                child: CupertinoButton(
                              minSize: 0,
                              onPressed: () {
                                // Your action here
                              },
                              child: Text(
                                'Edit',
                                textAlign: TextAlign.right,
                                style: baseStyle.copyWith(
                                  fontSize: 16,
                                  color: CupertinoColors.activeBlue,
                                ),
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SafeArea(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: dataMap.keys.toList().length,
                            separatorBuilder: (_, __) => Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              height: 1,
                              color: CupertinoColors.transparent,
                            ),
                            itemBuilder: (context, index) {
                              final keys = dataMap.keys.toList();
                              final key = keys[index];
                              final value = dataMap[key]!;

                              return GestureDetector(
                                //onTap: () => _onItemTap(key, value),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text('$key:  ',
                                            style: baseStyle.copyWith(
                                                fontSize: 16,
                                                color:
                                                    CupertinoColors.systemGrey,
                                                fontWeight: FontWeight.bold)),
                                        Text(value,
                                            style: baseStyle.copyWith(
                                                fontSize: 16)),
                                      ]),
                                      SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(message),
                        const SizedBox(height: 40),
                      ],
                    ),
                  )),
                ]);
              },
              loading: () => const CupertinoActivityIndicator(),
              error: (error, _) {
                return Text((error as AuthError).message);
              }),
        ),
      ),
    );
  }
}
