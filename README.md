# ReBooked

ReBooked is a Flutter mobile application that enables users to discover, share, and borrow books within a community. Built with a clean, responsive UI and Firebase-powered backend, ReBooked offers features such as browsing available books, managing personal library, handling swap requests, and receiving notifications.

## Features

* **Home**: Search books by title, author, genre, or location with live filter chips.
* **My Books**: Manage your personal collection and upload new titles (with optional notes).
* **Requests**: View incoming and outgoing swap requests for exchanging books.
* **Notifications**: Receive alerts for app events like swaps, and comments.
* **Profile**: Edit user information, view activity, and adjust settings.
* **Book Details**: Inspect full book metadata, owner info, status, and add notes.
* **Add Book**: Upload new books with cover image, metadata, status, and optional notes.

## Screenshots

&#x20;

## Getting Started

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* DART SDK (bundled with Flutter)
* Xcode (iOS) or Android Studio (Android)
* Firebase CLI: `npm install -g firebase-tools`
* `flutterfire` CLI: `dart pub global activate flutterfire_cli`

### Installation

1. Clone the repo:

   ```bash
   git clone https://github.com/your-org/rebooked_app.git
   cd rebooked_app
   ```
2. Install dependencies:

   ```bash
   flutter pub get
   ```
3. Configure Firebase:

   ```bash
   flutterfire configure
   ```
4. Run the app on simulator or device:

   ```bash
   flutter run
   ```

## Firebase Setup

1. Create a new Firebase project in the [Console](https://console.firebase.google.com/).
2. Add Android and iOS apps to the project, downloading `google-services.json` and `GoogleService-Info.plist`.
3. Place these files in `android/app/` and `ios/Runner/` respectively.
4. Enable Firestore, Authentication, and Storage in the Console.
5. Run `flutterfire configure` to generate `firebase_options.dart`.

## Architecture & Folder Structure

```
lib/
├─ core/        # Theme, constants, router
├─ views/       # Screens grouped by feature
│  ├─ home/
│  ├─ books/     # Add, detail, my_books
│  ├─ requests/
│  ├─ notifications/
│  ├─ profile/
│  └─ start_page/
├─ widgets/     # Reusable UI components (BookCard, chips, etc.)
└─ main.dart    # App entry point
```

We use `GoRouter` for navigation and `Provider`/`Riverpod` (TBD) for state management.
