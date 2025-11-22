# Car Parking Management System (Frontend Web-Android-Ios is available)

## Overview
A modern, responsive Flutter application designed for managing smart car parking systems. This application provides a user-friendly interface for administrators to monitor parking status in real-time, manage residents and vehicles, and view detailed access logs.

## Features

### 🖥️ Dashboard
- **Real-time Statistics**: View total residents, vehicles, active sessions, and daily entry/exit counts.
- **Interactive Charts**: Visual breakdown of daily traffic (Entries vs Exits).
- **Live Feed**: Real-time updates of vehicles entering and exiting the premises.

### 👥 Management
- **Residents**: Add, edit, and remove resident information.
- **Vehicles**: Register vehicles and link them to residents. Support for multiple vehicle types (Car, Motorbike).

### 📊 Monitoring
- **Parking History**: Detailed history of completed parking sessions with duration and images.
- **Access Logs**: comprehensive log of all access attempts, including authorized and unauthorized entries, with timestamps and captured images.

### 🎨 UI/UX
- **Responsive Design**: Seamless experience across Desktop Web (>900px) and Mobile devices.
  - **Web**: Permanent Sidebar navigation and expanded tables.
  - **Mobile**: Drawer navigation and optimized card/list views.
- **Modern Theme**: Vibrant color palette, gradients, and rounded aesthetics.

## Tech Stack
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Networking**: 
  - [dio](https://pub.dev/packages/dio) (HTTP Requests)
  - [socket_io_client](https://pub.dev/packages/socket_io_client) (Real-time WebSockets)
- **UI Components**:
  - [fl_chart](https://pub.dev/packages/fl_chart) (Charts)
  - [data_table_2](https://pub.dev/packages/data_table_2) (Advanced Tables)
  - [google_fonts](https://pub.dev/packages/google_fonts) (Typography)

## Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fe_car_parking
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

### Running the Application

#### 🌐 Web (Recommended for Development)
To avoid CORS (Cross-Origin Resource Sharing) issues when connecting to a local backend, run Chrome with web security disabled:

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

#### 📱 Android Emulator
If you prefer running on an Android Emulator:

1. **Configure Base URL**: 
   Open `lib/core/constants.dart` and ensure the `baseUrl` is set to the Android emulator's loopback address:
   ```dart
   static const String baseUrl = 'http://10.0.2.2:3000';
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── blocs/           # Business Logic Components (State Management)
├── core/            # Core configuration (API, Theme, Constants)
├── models/          # Data Models
├── screens/         # UI Screens (Dashboard, Residents, etc.)
├── widgets/         # Reusable UI Widgets
└── main.dart        # Application Entry Point
```
