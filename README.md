# ERP Mobile App

A cross-platform Flutter application for managing educational institution processes with dedicated dashboards for Admission, HR, Faculty, HOD, and Students. This app demonstrates clean architecture, REST API integration, secure authentication, and modern Flutter UI practices.

## Features

- Role-based dashboards for Admission, HR, Faculty, HOD, and Students
- Secure login and role-based navigation
- Modern, responsive UI with Google Fonts and Material 3
- State management using Riverpod
- Persistent storage with Shared Preferences and Secure Storage
- REST API integration using Dio
- Cross-platform: Android, iOS, Web, Windows, Linux, macOS

## Project Structure

```
lib/
  main.dart                # App entry point
  config/                  # App configuration and routing
  core/                    # Constants, themes, utilities
    constants/             # App-wide color and font constants
    themes/                # App theme definitions
    utils/                 # Utility functions
  models/                  # Data models for each module
    admission/             # Admission models
    hr/                    # HR models
    faculty/               # Faculty models
    hod/                   # HOD models
    student/               # Student models
  modules/                 # Feature modules (dashboards, auth, etc.)
    admission/             # Admission dashboard and screens
    hr/                    # HR dashboard and screens
    faculty/               # Faculty dashboard and screens
    hod/                   # HOD dashboard and screens
    student/               # Student dashboard and screens
    auth/                  # Login and authentication screens
  services/                # API and storage services
    api/                   # REST API integration
    storage/               # Secure and shared storage
  shared/                  # Shared widgets, dialogs, layouts
assets/
  logo.png                 # App logo
```

## How It Works

- Users log in with their credentials and are navigated to their role-specific dashboard.
- Each dashboard provides tailored features and access based on the user's role.
- Data is securely stored locally and fetched from REST APIs as needed.
- State is managed efficiently using Riverpod for scalability and maintainability.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart](https://dart.dev/get-dart)

### Setup

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd erp_mobile_app
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Run the app:**
   ```sh
   flutter run
   ```
   - For web: `flutter run -d chrome`
   - For desktop: `flutter run -d windows` (or `linux`, `macos`)

4. **Demo Login Credentials:**
   - Admission: `admission@pvppcoe.ac.in` / `12345678`
   - HR: `hr@pvppcoe.ac.in` / `12345678`
   - HOD: `hodcomps@pvppcoe.ac.in` / `12345678`
   - Faculty: `facultydemo@pvppcoe.ac.in` / `12345678`
   - Student: `dummy11@gmail.com` / `12345678`

## Usage

- **Login:** Enter your credentials to access your dashboard.
- **Dashboards:** Each role sees a customized dashboard with relevant features.
- **Navigation:** Use the menu to access different modules and functionalities.

## Benefits

- **Centralized Management:** Streamlines all institutional processes in one platform.
- **Efficiency:** Reduces paperwork and manual errors.
- **Security:** Secure authentication and data storage.
- **User-Friendly:** Intuitive UI for all user roles.
- **Scalable:** Easily extendable for new modules and features.
- **Cross-platform:** Single codebase for all major platforms.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---
