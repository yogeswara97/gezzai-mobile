# gezz_ai

A Flutter project that integrates the Gemini API for AI-powered features and Firebase Firestore for saving user history.

## Features

- **AI Integration**: Leverages the Gemini API to enable AI-driven functionalities within the app.
- **History Management**: Stores user interaction history securely using Firebase Firestore.
- **Cross-Platform**: Developed with Flutter, ensuring seamless performance on both Android and iOS devices.

## Getting Started

This project serves as a foundation for building an AI-powered mobile application with Flutter. If you're new to Flutter, here are some helpful resources to get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For detailed guidance on Flutter development, explore the [online documentation](https://docs.flutter.dev/), which includes tutorials, samples, mobile development tips, and a complete API reference.

## Prerequisites

Before setting up the project, ensure you have the following:

- **Flutter SDK**: Installed on your system. Follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install) if needed.
- **Code Editor**: Use Visual Studio Code, Android Studio, or any preferred editor with Flutter support.
- **Firebase Account**: Required to configure Firestore for history storage.
- **Gemini API Key**: Obtain this from the Gemini API provider for AI functionality.

## Installation

Follow these steps to set up and run the "gezz_ai" project:

1. **Open the Project**:
   - If you have the project in a repository, clone it using `git clone <repository-url>`.
   - Alternatively, open the project folder directly in your code editor.

2. **Install Dependencies**:
   - Navigate to the project directory in your terminal and run:
     ```bash
     flutter pub get
     ```
   - This installs all required packages listed in `pubspec.yaml`.

3. **Set Up Firebase**:
   - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
   - Add your Flutter app to the Firebase project:
     - For Android: Register your app using the package name (e.g., `com.example.gezz_ai`).
     - For iOS: Register your app using the bundle ID.
   - Download the configuration files:
     - `google-services.json` (Android): Place it in `android/app/`.
     - `GoogleService-Info.plist` (iOS): Place it in `ios/Runner/`.
   - Enable Firestore in the Firebase Console under the "Firestore Database" section.

4. **Configure the Gemini API Key**:
   - Obtain your API key from the Gemini API provider.
   - Store it securely in your app (e.g., in a `.env` file or a Dart configuration file). Avoid hardcoding it in source files tracked by version control.

5. **Run the App**:
   - Connect a physical device or start an emulator/simulator.
   - Run the following command in the terminal:
     ```bash
     flutter run
     ```

## Usage

Once the app is launched, you can:

- **Interact with AI Features**: Use the Gemini API-powered functionalities, such as chat or other AI-driven tools.
- **View History**: Access and manage your interaction history, which is automatically saved to Firebase Firestore.

To customize the app, edit the source code in the `lib/` directory, starting with `main.dart`.
