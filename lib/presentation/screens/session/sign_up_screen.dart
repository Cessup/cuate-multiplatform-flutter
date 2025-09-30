import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../notifier/session/auth_state.dart';
import '../../providers/general_provider.dart';
import '../../providers/user_provider.dart';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image/image.dart' as img;
import 'package:web/web.dart' as web;

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nicknameController = TextEditingController();
  final familyNameController = TextEditingController();
  final givenNameController = TextEditingController();
  final addressController = TextEditingController();
  final birthdateController = TextEditingController();
  final genderOptions = ['male', 'female'];

  String gender = 'male';
  String message = '';
  String? imagePath;
  bool isCodeSent = false;

  Uint8List? bytesImg;

  Future<void> _sendCode() async {
    await ref
        .watch(signUpNotifier.notifier)
        .register(
          emailController.text.trim(),
          confirmEmailController.text.trim(),
          passwordController.text.trim(),
          confirmPasswordController.text.trim(),
          phoneController.text.trim(),
          nicknameController.text.trim(),
          familyNameController.text.trim(),
          givenNameController.text.trim(),
          addressController.text.trim(),
          gender,
          birthdateController.text.trim(),
          imagePath,
        );

    final signUpAsync = ref.read(signUpNotifier);

    signUpAsync.when(
      data: (authState) {
        ref.read(loadingProvider.notifier).state = false;
        if (authState.isLoggin) {
          setState(() {
            isCodeSent = true;
          });
        } else {
          _showDialog('Sign Up Failed', 'There are some problems');
        }
      },
      loading: () => ref.read(loadingProvider.notifier).state = true,
      error: (error, _) {
        ref.read(loadingProvider.notifier).state = false;
        _showDialog('Error Sign Out', (error as AuthError).message);
      },
    );
  }

  void confirmCode() async {
    await ref
        .watch(signUpNotifier.notifier)
        .codeConfirm(emailController.text.trim(), codeController.text.trim());

    final signUpAsync = ref.read(signUpNotifier);

    signUpAsync.when(
      data: (authState) {
        ref.read(loadingProvider.notifier).state = false;
        // ignore: use_build_context_synchronously
        context.push('/profile');
      },
      loading: () => ref.read(loadingProvider.notifier).state = true,
      error: (error, _) {
        ref.read(loadingProvider.notifier).state = false;
        _showDialog('Error Sign Out', (error as AuthError).message);
      },
    );
  }

  Future<void> pickImageFromMobile(ImageSource type) async {
    //ImageSource.camera or ImageSource.gallery
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: type);
    if (pickedFile == null) return;

    Uint8List bytes = await pickedFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) throw Exception("Invalid image data");

    final resized = img.copyResize(originalImage, width: 100, height: 100);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/resized_profile.jpg');

    setState(() => bytesImg = Uint8List.fromList(img.encodeJpg(resized)));

    await file.writeAsBytes(bytesImg!);
    imagePath = file.path;
  }

  Future<void> pickImageFromWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result == null) return;
    if (result.files.isEmpty) return;

    final originalImage = img.decodeImage(result.files.first.bytes!);
    if (originalImage == null) throw Exception("Invalid image data");

    final resized = img.copyResize(originalImage, width: 100, height: 100);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/resized_profile.jpg');

    setState(() => bytesImg = Uint8List.fromList(img.encodeJpg(resized)));

    await file.writeAsBytes(bytesImg!);
    imagePath = file.path;
  }

  Future<String> getFakeTempPath() async {
    if (kIsWeb) {
      return "/temp_web/"; // Simulated
    } else {
      final dir = await getTemporaryDirectory();
      return dir.path;
    }
  }

  void saveToLocalStorage(String key, String value) {
    web.window.localStorage.setItem(key, value);
  }

  String? readFromLocalStorage(String key) {
    return web.window.localStorage.getItem(key);
  }

  Future<String> getTempDirPath() async {
    if (kIsWeb) {
      // Return dummy or simulate
      return "/temp_web/";
    } else {
      final dir = await getTemporaryDirectory();
      return dir.path;
    }

    web.window.sessionStorage.setItem("tempKey", "value");
    final value = web.window.sessionStorage.getItem("tempKey");
  }

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

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Profile Photo'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              try {
                pickImageFromMobile(ImageSource.camera);
              } on Exception catch (_, e) {
                print('$e');
              }
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              try {
                pickImageFromMobile(ImageSource.gallery);
              } on Exception catch (_, e) {
                print('$e');
              }
            },
            child: const Text('Gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
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

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: CupertinoTextField(
        controller: controller,
        placeholder: label,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _firstScreen() {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              (kIsWeb) ? pickImageFromWeb() : _showActionSheet(context);
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CupertinoColors.systemGrey5,
                image: bytesImg != null
                    ? DecorationImage(
                        image: (kIsWeb)
                            ? MemoryImage(bytesImg!)
                            : FileImage(File.fromRawPath(bytesImg!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: bytesImg == null
                  ? Icon(
                      CupertinoIcons.person_crop_circle,
                      size: 80,
                      color: CupertinoColors.systemGrey,
                    )
                  : null,
            ),
          ),
        ),
        buildTextField(
          'Email',
          emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        buildTextField(
          'Confirm Email',
          confirmEmailController,
          keyboardType: TextInputType.emailAddress,
        ),
        buildTextField('Password', passwordController, obscure: true),
        buildTextField(
          'Confirm Password',
          confirmPasswordController,
          obscure: true,
        ),
        buildTextField(
          'Phone (+521234567890)',
          phoneController,
          keyboardType: TextInputType.phone,
        ),
        buildTextField('Username', nicknameController),
        buildTextField('Family Name (max 20)', familyNameController),
        buildTextField('Given Name (max 20)', givenNameController),
        buildTextField('Address (max 100)', addressController),
        buildTextField('Birthdate (YYYY-MM-DD)', birthdateController),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Gender:'),
            const SizedBox(width: 10),
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
            onPressed: _sendCode,
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _secondScreen() {
    return Column(
      children: [
        buildField('Email', emailController),
        buildField('Confirmation Code', codeController),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: CupertinoButton.filled(
            onPressed: _sendCode,
            child: const Text('Confirm'),
          ),
        ),
        SizedBox(height: 40),
        Text(message),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width for responsive layout
    var screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Sign Up')),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth > 600 ? 30 : 16,
            vertical: 16,
          ),
          child: (!isCodeSent) ? _firstScreen() : _secondScreen(),
        ),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
