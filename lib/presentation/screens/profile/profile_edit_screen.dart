import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nicknameController = TextEditingController();
  final familyNameController = TextEditingController();
  final givenNameController = TextEditingController();
  final addressController = TextEditingController();
  final birthdateController = TextEditingController();
  final genderOptions = ['male', 'female'];
  String gender = 'male';

  String message = '';

  void _logout() {
    // Handle logout logic
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

  @override
  Widget build(BuildContext context) {
    final baseStyle = CupertinoTheme.of(context).textTheme.textStyle;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Profile'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _logout,
          child: const Text('Logout'),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Column(children: [
                Text('UserName', style: baseStyle.copyWith(fontSize: 20)),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  color: CupertinoColors.systemGrey4, // Light gray line
                ),
                Text('Full Name', style: baseStyle.copyWith(fontSize: 16)),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: Text('Contact Information',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                      child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      // Your action here
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: CupertinoColors.activeBlue, // iOS blue text
                        fontSize: 16, // Optional
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('Email',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: emailController,
                      placeholder: 'example@email.com',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('Phone',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: phoneController,
                      placeholder: '+521234567890',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('Family Name',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: familyNameController,
                      placeholder: 'max 20',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('Given Name',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: givenNameController,
                      placeholder: 'max 20',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text('Birthdate',
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                  ),
                  Expanded(
                    child: CupertinoTextField(
                      controller: birthdateController,
                      placeholder: 'YYYY-MM-DD',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Gender:'),
                  const SizedBox(width: 120),
                  CupertinoSegmentedControl<String>(
                    children: {
                      for (var genderItem in genderOptions)
                        genderItem: Text(genderItem.capitalize()),
                    },
                    groupValue: gender,
                    onValueChanged: (val) => setState(() => gender = val),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(message),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CupertinoButton.filled(
                  onPressed: _logout,
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
