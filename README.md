# Cuate app

[![Commit](https://img.shields.io/github/last-commit/cessup/cuate-multiplatform-flutter
)](https://github.com/Cessup/cuate-multiplatform-flutter)


![Example Image App](images/cuate_app_banner.svg)

Cuate app is a example of a multiplatform application by flutter.


> [!NOTE]
> I'm still developing it so my idea is make a system by my knowledge because I wanted to show you how I can make any system. If any one  needs it for consult that will a pleasure be reference.

>If you want to more information about me you can visit my website.
>- [cessup.com](https://www.cessup.com)

![Example Image App](images/cuate_app_ss.png)

## Table of Contents

- [Features](#features)  
- [Prerequisites](#prerequisites)  
- [Installation](#installation)  
- [Usage / Running](#usage--running)  
- [Build / Release](#build--release)  
- [Project Structure](#project-structure)  
- [Dependencies](#dependencies)  
- [Contributing](#contributing)  
- [License](#license)  

## Features
Here's a list of features included in this project:

| Name                                                                                                                                      | Description                                                   |
|-------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| [Session](https://www.postman.com/cessupx/cacao-workspace/folder/goo6ezk/session-services) | There are all services about session like sign in or sing up. |

## Prerequisites

What is required before running / installing:

- Flutter SDK (version X or higher)  
- Dart  
- (Optional) Firebase setup / API keys / environment variables  
- Android Studio / Xcode / or simulator / device  

## Installation

1. Clone the repository:
- on Terminal.
  ```shell
  git clone https://github.com/your-username/your-flutter-project.git
  cd your-flutter-project
  ```
2. Get the dependencies:
- on Terminal.
  ```shell
  flutter pub get
  ```
  
3. (Optional) If your project uses code generation (e.g. build_runner, freezed, json_serializable), run:
- on Terminal.
  ```shell
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

## Usage / Running

To run the app (development mode):
- on Terminal.
  ```shell
  flutter run
  ```

You can also run from IDEs (VS Code, Android Studio) by selecting your target device and pressing **Run** / **Debug**.

## Build / Release

To build a release version, e.g. Android APK:
- on Terminal.
  ```shell
  flutter build apk --release
  ```

For iOS (on macOS):

- on Terminal.
  ```shell
  flutter build ios --release
  ```

(If using flavors, you may need additional flags, e.g. `--flavor prod`.)

The output files will be located in the `build/` directory (for example, `build/app/outputs/flutter-apk/` for Android).


## Dependencies

List your major dependencies, e.g.:

- flutter  
- http  
- freezed  
- cupertino_icons: `^1.0.8`
- english_words:  `^4.0.0`
- go_router: `^16.2.4 `
- flutter_riverpod: `^3.0.0`
- riverpod_annotation: `^3.0.0`
- equatable:`^2.0.3`
- dio:`^5.0.0`
- json_serializable:`^6.0.0`
- http: `^1.1.0`
- shared_preferences: `^2.2.2`
- amplify_flutter:  `^2.6.1`
- amplify_auth_cognito:`^2.6.5`
- amplify_storage_s3: `^2.6.1`
- image: `^4.5.4`
- image_picker: `^1.0.7`
- path_provider: `^2.1.2`
- file_picker: `^10.3.3`
- permission_handler: `^12.0.1`
- web: `^1.1.1` 

Refer to your `pubspec.yaml` for the full list and versions.

### About Flutter Multiplatform
Learn more about [Flutter Multiplatform](https://flutter.dev),
