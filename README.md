# chat_app

This is a Flutter application for a one-to-one chat with a fully functional authentication module using Firebase.

## Features

- User Authentication (Sign Up, Sign In, Sign Out)
- Real-time Messaging
- User Presence Indicator (WIP)
- Profile Management (WIP)
- Firebase Firestore for storing chat messages
- Firebase Authentication for user management

## Screenshots

![Login Screen](screenshots/login.png)
![Chat Screen](screenshots/chat.png)

## Requirements

- Flutter 2.0 or higher
- Dart 2.12 or higher
- Firebase Project

## Getting Started

### Prerequisites

1. **Flutter**: Make sure you have Flutter installed on your machine. You can follow the instructions [here](https://flutter.dev/docs/get-started/install).
2. **Firebase**: Create a Firebase project by following the instructions [here](https://firebase.google.com/docs/flutter/setup).

### Installation

1. **Clone the Repository**:

    ```sh
    git clone https://github.com/bharat59/flutter_chat_app.git
    cd chat_app
    ```

2. **Set up Firebase**:

    - Go to the Firebase Console.
    - Create a new project.
    - Add an Android/iOS app to your project.
    - Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file and place them in the appropriate directories:
        - `android/app/`
        - `ios/Runner/`

3. **Configure Firebase in Flutter**:

   Add the necessary Firebase dependencies in your `pubspec.yaml`:

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      firebase_core: latest_version
      firebase_auth: latest_version
      cloud_firestore: latest_version
      provider: latest_version
    ```

4. **Install Dependencies**:

    ```sh
    flutter pub get
    ```

5. **Run the App**:

    ```sh
    flutter run
    ```
