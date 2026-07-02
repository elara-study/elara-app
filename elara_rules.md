# Elara LMS — Cursor AI Rules

---

## Project Identity

You are working on **Elara LMS**, a Flutter-based Learning Management System with three user roles: **Student**, **Teacher**, and **Parent**.

**Current phase: Backend Integration** — The UI is fully complete. Do NOT redesign or recreate any UI screens. Your job is to wire existing UI to the backend.

---

## SCAN BEFORE YOU CREATE — Most Important Rule

**Before writing any new file, always scan the relevant directory first.**

```
# Always do this first:
1. List the feature directory: lib/features/<feature>/
2. Read existing entities in: lib/features/<feature>/domain/entities/
3. Read existing repositories in: lib/features/<feature>/domain/repositories/
4. Then decide what to do:
```

| Situation                                 | Action                                                    |
| ----------------------------------------- | --------------------------------------------------------- |
| File exists and is complete               | Use it as-is. Do NOT recreate it.                         |
| File exists but is missing fields/methods | Add only what's missing. Show a diff, not a full rewrite. |
| File does not exist                       | Create it following the structure rules below.            |

**Never assume a file doesn't exist. Never duplicate existing code.**  
If unsure, ask: _"I found `user.dart` in domain/entities — should I use this or is there a different one?"_

---

## Git Branch Strategy

### Branch per feature

Each backend integration task gets its own branch:

```
main
├── feature/auth-integration
├── feature/student-dashboard-integration
├── feature/student-courses-integration
├── feature/student-assignments-integration
├── feature/student-grades-integration
├── feature/teacher-classes-integration
├── feature/teacher-grading-integration
├── feature/parent-dashboard-integration
└── feature/shared-notifications-integration
```

**Branch naming rule:** `feature/<role>-<screen>-integration`  
Example: `feature/teacher-grading-integration`

### Branch workflow

```bash
# Start a new feature
git checkout dev
git pull origin dev
git checkout -b feature/<role>-<screen>-integration

# When done, open a PR to dev — do not merge locally
```

---

## Commit Message Rules

All commits must follow **Conventional Commits** format:

```
<type>(<scope>): <short description>

[optional body: what changed and why]
```

**Types:**

- `feat` — new functionality (API call, Cubit, wiring)
- `fix` — bug fix
- `refactor` — restructure without behavior change
- `chore` — DI registration, build_runner, pubspec changes
- `test` — tests only
- `docs` — comments or documentation

**Scopes** match the feature module: `auth`, `student-dashboard`, `student-courses`, `teacher-classes`, etc.

**Examples:**

```
feat(auth): add login remote datasource with JWT handling
feat(auth): implement login cubit with loading/success/failure states
chore(auth): register AuthRepository and AuthRemoteDataSource in GetIt
feat(student-dashboard): wire dashboard cubit to existing dashboard view
fix(auth): handle 401 response and redirect to login screen
```

### After each task, always output this block:

```
═══════════════════════════════════════
  COMMIT SUGGESTION
───────────────────────────────────────
Branch: feature/auth-integration

git add \
  lib/features/auth/data/datasources/auth_remote_datasource.dart \
  lib/features/auth/data/models/user_model.dart \
  lib/features/auth/data/repositories/auth_repository_impl.dart \
  lib/config/dependency_injection.dart

git commit -m "feat(auth): add login datasource, model, and repository impl"
═══════════════════════════════════════
```

Only include files that were **actually created or modified** in this task.  
Split into multiple commits if the task touched multiple logical units.

---

## Architecture Rules

### Pattern: Clean Architecture + MVVM

- **Presentation Layer** → Views, Widgets, Cubits, States
- **Domain Layer** → Entities, Repositories (abstract), Use Cases
- **Data Layer** → Models, DataSources, Repository Implementations

### Student-style wiring is the default for backend integration

For any endpoint wiring task, follow the same complete flow used in student features:

`UI/View -> Cubit -> UseCase -> Repository (abstract) -> RepositoryImpl -> RemoteDataSource -> DioClient`

This is required unless the task explicitly says to keep an existing lean teacher pattern.

Never mix layers:

- ❌ View → Repository
- ❌ Cubit → Dio
- View → Cubit → Repository → DataSource → Dio

### State Management: BLoC / Cubit

- Always use **Cubit** for feature state.
- State classes must extend `Equatable`.
- Use a `status` enum: `initial`, `loading`, `success`, `failure`.
- Always emit `loading` before async calls, then `success` or `failure`.

```dart
//   Correct Cubit pattern
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(LoginState.initial());
  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _authRepository.login(email, password);
    result.fold(
      (failure) => emit(state.copyWith(status: LoginStatus.failure, error: failure.message)),
      (user)    => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }
}
```

### Dependency Injection: GetIt (Student-style full registration)

- Register all layers in `GetIt`: datasource -> repository impl -> usecase -> cubit.
- Cubits must depend on use cases, not datasources directly (for student-style wiring).
- Use `registerLazySingleton` for datasources/repositories/usecases.
- Use `registerFactory` for cubits.
- Access via `getIt<T>()` — never instantiate directly in UI.

---

## Networking Rules

### HTTP Client: Dio

- All calls go through a **single `DioClient`** in `lib/core/network/`.
- Must include: auth interceptor (Bearer token), error interceptor, logging interceptor (debug only).
- `baseUrl` must come from `AppConstants.apiBaseUrl` — never hardcode URLs in features don't add baseUrl in git add it in .gitignore.

```dart
//   Correct datasource pattern
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }
}
```

### Error Handling

- Repository methods return `Either<Failure, T>`.
- Never bubble raw exceptions to Cubit or UI.
- Failure types: `ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`, `ParseFailure`.
- On `401`: clear token + redirect to login.

```dart
//   Correct repository impl pattern
Future<Either<Failure, User>> login(String email, String password) async {
  try {
    final model = await _remoteDataSource.login(email, password);
    return Right(model.toEntity());
  } on DioException catch (e) {
    return Left(ServerFailure.fromDioException(e));
  } catch (e) {
    return Left(ServerFailure(message: e.toString()));
  }
}
```

---

## File & Folder Structure

```
lib/features/<feature>/
├── data/
│   ├── datasources/
│   │   └── <feature>_remote_datasource.dart
│   ├── models/
│   │   └── <entity>_model.dart        ← fromJson / toJson / toEntity()
│   └── repositories/
│       └── <feature>_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── <entity>.dart              ← Pure Dart, no Flutter/third-party imports
│   ├── repositories/
│   │   └── <feature>_repository.dart  ← Abstract interface
│   └── usecases/                      ← Required for backend integration
└── presentation/
    ├── cubits/
    │   ├── <feature>_cubit.dart
    │   └── <feature>_state.dart
    ├── views/                         ← Already complete — only wire, don't redesign
    └── widgets/                       ← Already complete — only wire, don't redesign
```

### Backend Endpoint Wiring Checklist (Student-style)

For every new endpoint integration, complete **all** applicable layers:

1. Add endpoint constant in `lib/core/constants/api_constants.dart` (no magic strings).
2. Add/update DataSource method in `data/datasources/*_remote_datasource.dart`.
3. Add/update Model(s) in `data/models/` with `fromJson`/`toJson` and mapping support.
4. Add/update repository contract in `domain/repositories/`.
5. Add/update repository implementation in `data/repositories/`.
6. Add one dedicated use case per action in `domain/usecases/`.
7. Inject use case(s) into cubit; cubit should not call Dio/DataSource directly.
8. Register datasource, repository, usecase, and cubit in DI (`lib/config/di/*.dart`).
9. Wire cubit to existing UI screen/widgets without redesign.
10. Run `flutter analyze` before completing the task.

### Backend Endpoint Wiring Checklist (Student-style)

For every new endpoint integration, complete **all** applicable layers:

1. Add endpoint constant in `lib/core/constants/api_constants.dart` (no magic strings).
2. Add/update DataSource method in `data/datasources/*_remote_datasource.dart`.
3. Add/update Model(s) in `data/models/` with `fromJson`/`toJson` and mapping support.
4. Add/update repository contract in `domain/repositories/`.
5. Add/update repository implementation in `data/repositories/`.
6. Add one dedicated use case per action in `domain/usecases/`.
7. Inject use case(s) into cubit; cubit should not call Dio/DataSource directly.
8. Register datasource, repository, usecase, and cubit in DI (`lib/config/di/*.dart`).
9. Wire cubit to existing UI screen/widgets without redesign.
10. Run `flutter analyze` before completing the task.

---

## UI Rules (Read-Only Phase)

The UI is done. When connecting the backend:

- Do NOT redesign, rename, or restructure existing views or widgets except i tell you to make somthing.
- Only add `BlocProvider`, `BlocBuilder`, `BlocListener` wrappers where needed.
- Do NOT hardcode colors, spacing, or text styles — use design tokens.
- Font: **Nunito** (bundled in `assets/fonts/`) — never use `GoogleFonts` at runtime.

---

## Auth Rules

- Store JWT token and user role in `SharedPreferences` after login.
- Route after login based on `UserRole` enum (student / teacher / parent).
- `AuthInterceptor` reads token and adds `Authorization: Bearer <token>` header.
- On `401`: clear token + navigate to login.
- Never store passwords locally.

---

## Feature → Role Map

| Role    | Features                                                       |
| ------- | -------------------------------------------------------------- |
| Student | dashboard, courses, assignments, grades, notifications         |
| Teacher | dashboard, classes, grading, student_management, announcements |
| Parent  | dashboard, children_progress, messaging, attendance, reports   |
| Shared  | auth, profile, notifications, messaging                        |

---

## Code Quality

- API paths -> `lib/core/constants/api_constants.dart` (no magic strings)
- Use `logger` (`log.d`, `log.e`, `log.w`) — never `print()`
- All state is immutable — use `copyWith`, never mutate
- Run `flutter analyze` before marking a task done — zero warnings

---
