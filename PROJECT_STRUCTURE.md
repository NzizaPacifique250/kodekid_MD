# KodeKid Project Structure

This document outlines the simplified folder structure for the KodeKid Flutter application.

## 📁 Root Directory Structure

```
kodekid/
├── android/                 # Android platform files
├── ios/                     # iOS platform files
├── lib/                     # Main Dart source code
├── test/                    # Test files
├── assets/                  # Static assets
├── web/                     # Web platform files
├── windows/                 # Windows platform files
├── linux/                   # Linux platform files
├── macos/                   # macOS platform files
├── pubspec.yaml             # Project dependencies
└── README.md               # Project documentation
```

## 📁 lib/ Directory Structure

```
lib/
├── main.dart               # Application entry point
├── core/                   # Core functionality
│   ├── constants/          # App-wide constants
│   ├── utils/              # Utility functions
│   └── widgets/            # Core reusable widgets
├── features/               # Feature-based modules
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer
│   │   ├── domain/         # Domain layer
│   │   └── presentation/   # Presentation layer
│   └── home/               # Home screen feature
│       ├── data/           # Data layer
│       ├── domain/         # Domain layer
│       └── presentation/   # Presentation layer
└── routes/                 # Navigation routes
```

## 📁 assets/ Directory Structure

```
assets/
├── images/                 # Image assets
│   ├── lessons/            # Lesson-related images
│   ├── games/              # Game-related images
│   ├── characters/         # Character images
│   └── ui/                 # UI element images
├── animations/             # Animation files (Lottie, etc.)
├── sounds/                 # Audio files
└── icons/                  # App icons and small graphics
```

## 🏗️ Architecture Pattern

This project follows a **simplified Clean Architecture** pattern with:

- **Presentation Layer**: UI components, pages, and widgets
- **Domain Layer**: Business logic and entities
- **Data Layer**: Data sources and models

## 🎯 Feature Organization

Each feature is organized as a self-contained module with:
- Clear separation of concerns
- Independent data flow
- Reusable components
- Testable architecture

## 📱 KodeKid Features

- **Auth**: User authentication and registration
- **Home**: Main dashboard and navigation hub

This simplified structure ensures maintainability and follows Flutter best practices for medium-scale applications.
