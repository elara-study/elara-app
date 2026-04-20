# 📚 Elara LMS

A modern, feature-rich learning management system built with Flutter, supporting three distinct user roles: Students, Teachers, and Parents.

[![Flutter Version](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
  
## 📖 Table of Contents

- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [User Roles](#-user-roles)
- [Development](#-development)
- [Design System](#-design-system)
 
---

## ✨ Features

### 👨‍🎓 For Students
- 📚 **Course Enrollment** - Browse and enroll in available courses
- 📝 **Assignment Submission** - Submit assignments and track deadlines
- 📊 **Grade Tracking** - View grades and performance analytics
- 🎥 **Video Lessons** - Access course materials and video content
- 🔔 **Notifications** - Stay updated with announcements and deadlines
- 📈 **Progress Dashboard** - Monitor learning progress

### 👨‍🏫 For Teachers
- 🏫 **Class Management** - Create and manage classes
- 📋 **Assignment Creation** - Create and distribute assignments
- ✅ **Grading System** - Grade student submissions
- 👥 **Student Management** - Manage student roster
- 📢 **Announcements** - Post updates and announcements
- 📊 **Analytics** - View class performance metrics

### 👨‍👩‍👧 For Parents
- 👶 **Child Monitoring** - Track multiple children's progress
- 📈 **Progress Reports** - View detailed progress reports
- 💬 **Teacher Communication** - Message teachers directly
- 📅 **Attendance Tracking** - Monitor attendance records
- 🎯 **Performance Analytics** - View performance trends
- 🔔 **Real-time Updates** - Receive notifications about child's activities

### 🔄 Shared Features
- 🔐 **Secure Authentication** - Role-based access control
- 👤 **Profile Management** - Customizable user profiles
- 🔔 **Push Notifications** - Real-time updates
- 💬 **In-app Messaging** - Communicate with other users
- 🌓 **Dark Mode** - Light and dark theme support
- 📱 **Responsive Design** - Optimized for mobile, tablet, and desktop

---

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with **Clean Architecture** principles:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Views, Widgets, Cubits, States)       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Domain Layer                 │
│     (Business Logic, Entities)          │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Layer                   │
│  (Models, Repositories, Data Sources)   │
└─────────────────────────────────────────┘
```

### Key Architectural Decisions:

- **Feature-based structure** - Each user type has its own module
- **Separation of concerns** - Clear boundaries between layers
- **Dependency injection** - Using GetIt for DI
- **State management** - BLoC/Cubit pattern
- **Reactive programming** - Stream-based data flow

📚 **[Read full architecture documentation →](ARCHITECTURE.md)**

---

## 🛠️ Tech Stack

### Core
- ![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter) **Framework**
- ![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart) **Language**
- **State Management:** flutter_bloc / Cubit
- **Dependency Injection:** get_it
- **Networking:** Dio
- **Code Generation:** json_serializable, build_runner

### UI/UX
- **Design System:** Custom design tokens
- **Theming:** Material Design 3
- **Responsive:** Custom responsive utilities
- **Fonts:** Nunito (Google Fonts)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/elara-study/elara-app
   cd  elara-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Download fonts** (Important!)
   
   Download [Nunito font](https://fonts.google.com/specimen/Nunito), extract and copy these files to `assets/fonts/`:
   - Nunito-Regular.ttf
   - Nunito-Medium.ttf
   - Nunito-SemiBold.ttf
   - Nunito-Bold.ttf
   
   📚 **[Detailed font installation guide →](HOW_TO_ADD_FONTS.md)**

5. **Run the app**
   ```bash
   flutter run
   ```

### Quick Commands

```bash
# Run on web
flutter run -d chrome

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web

# Analyze code
flutter analyze

# Check setup
flutter doctor
```

---

## 📁 Project Structure

```
lib/
├── core/                          # Core utilities & shared code
│   ├── constants/                # App constants, API endpoints
│   ├── errors/                   # Error handling
│   ├── network/                  # Dio client, interceptors
│   ├── responsive/               # Responsive utilities
│   ├── theme/                    # Design tokens, theme config
│   └── utils/                    # Helper functions
│
├── config/                        # App configuration
│   ├── dependency_injection.dart # DI setup
│   ├── routes.dart              # Navigation
│   └── theme.dart               # Theme configuration
│
├── features/                      # Feature modules
│   ├── auth/                     # 🔐 Authentication
│   ├── student/                  # 👨‍🎓 Student features
│   ├── teacher/                  # 👨‍🏫 Teacher features
│   ├── parent/                   # 👨‍👩‍👧 Parent features
│   └── shared/                   # 🔄 Shared features
│
└── main.dart                      # App entry point
```

Each feature module follows MVVM structure:
```
feature/
├── data/
│   ├── models/          # Data models
│   ├── datasources/     # API calls
│   └── repositories/    # Data operations
└── presentation/
    ├── cubits/          # Business logic
    ├── views/           # UI screens
    └── widgets/         # Reusable components
```

📚 **[Detailed structure documentation →](LEARNING_APP_STRUCTURE.md)**

---

## 👥 User Roles

### 1. 👨‍🎓 Student
Access course materials, complete assignments, track grades, and monitor progress.

**Key Screens:** Dashboard, My Courses, Assignments, Grades, Profile

### 2. 👨‍🏫 Teacher
Create courses, distribute assignments, grade submissions, and manage students.

**Key Screens:** Dashboard, My Classes, Grade Assignments, Student Management, Analytics

### 3. 👨‍👩‍👧 Parent
Monitor child's progress, communicate with teachers, and track performance.

**Key Screens:** Dashboard, Children's Progress, Teacher Messages, Attendance, Reports

---

## 💻 Development

### Code Generation

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Git Workflow

**1. Create feature branch**
```bash
git checkout -b feature/your-feature-name
```

**2. Make changes and commit**
```bash
git add .
git commit -m "feat: add your feature"
```

**3. Push and create Pull Request**
```bash
git push origin feature/your-feature-name
```

📚 **[Full Git workflow guide →](GIT_WORKFLOW_CHEATSHEET.md)**

### Branch Naming

- `feature/` - New features (feature/student-dashboard)
- `fix/` - Bug fixes (fix/login-validation)
- `refactor/` - Code refactoring
- `docs/` - Documentation updates

---

## 🎨 Design System

### Design Tokens

Comprehensive design token system:

- **Colors** - Brand, semantic, neutral palettes (70+ colors)
- **Typography** - 8 font weights, 6 heading styles
- **Spacing** - 13 values (2px - 64px)
- **Border Radius** - 6 predefined values
- **Components** - 6 button variants

### Usage Example

```dart
// Colors
Container(
  color: AppColors.brandPrimary500,
  child: Text(
    'Hello',
    style: AppTypography.h4(color: LightModeColors.textPrimary),
  ),
)

// Spacing
Padding(
  padding: EdgeInsets.all(AppSpacing.spacingLg),
  child: YourWidget(),
)

// Buttons
AppPrimaryButton(
  text: 'Submit',
  onPressed: () {},
  icon: Icons.check,
)
```

📚 **[Design system documentation →](DESIGN_SYSTEM.md)**

### Responsive Design

Built-in responsive utilities:

```dart
// Check device type
if (context.isMobile) { /* Mobile layout */ }
if (context.isTablet) { /* Tablet layout */ }
if (context.isDesktop) { /* Desktop layout */ }

// Responsive values
double padding = context.responsive.value(
  mobile: 16,
  tablet: 24,
  desktop: 32,
);

// Responsive layouts
ResponsiveBuilder(
  mobile: (context) => MobileLayout(),
  tablet: (context) => TabletLayout(),
  desktop: (context) => DesktopLayout(),
)
```

📚 **[Responsive design guide →](RESPONSIVE_DESIGN.md)**

---
  
## 🗺️ Roadmap

### ✅ Phase 1: Foundation (Completed)
- [x] Project setup
- [x] MVVM architecture
- [x] Design system
- [x] Responsive design

### 🚧 Phase 2: Authentication (In Progress)
- [ ] Login/Register
- [ ] User type selection
- [ ] Role-based routing

### 📅 Phase 3: Student Features
- [ ] Student dashboard
- [ ] Course enrollment
- [ ] Assignment submission
- [ ] Grade viewing

### 📅 Phase 4: Teacher Features
- [ ] Teacher dashboard
- [ ] Class management
- [ ] Grading system

### 📅 Phase 5: Parent Features
- [ ] Parent dashboard
- [ ] Progress monitoring
- [ ] Teacher communication

### 📅 Phase 6: Shared Features
- [ ] Notifications
- [ ] Messaging
- [ ] Profile management

---
 

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) - For the amazing framework
- [BLoC Library](https://bloclibrary.dev/) - For state management
- [Dio](https://pub.dev/packages/dio) - For networking

---

## ⭐ Show Your Support

Give a ⭐️ if this project helped you!

---

<p align="center">Made with ❤️ using Flutter</p>
<p align="center">
  <img src="https://storage.googleapis.com/cms-storage-bucket/ec64036b4eacc9f3fd73.svg" width="200">
</p>
