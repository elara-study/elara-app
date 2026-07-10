/// Auth feature barrel file.

library;

// PRESENTATION — BLoC (Cubit)

export 'presentation/cubits/auth_cubit.dart';
export 'presentation/cubits/auth_state.dart';

// PRESENTATION — Views (Screens)

export 'presentation/views/splash_screen.dart';
export 'presentation/views/sign_in_screen.dart';
export 'presentation/views/sign_up_role_screen.dart';
export 'presentation/views/sign_up_credentials_screen.dart';
export 'presentation/views/forgot_password_screen.dart';
export 'presentation/views/reset_password_screen.dart';
export 'presentation/views/otp_screen.dart';

// PRESENTATION — Reusable Widgets

// Layout shell — used by any screen that follows the auth card structure.
export 'presentation/widgets/auth_screen_layout.dart';
export 'presentation/widgets/auth_screen_metrics.dart';

// Shared auth card building blocks.
export 'presentation/widgets/auth_card_header.dart';
export 'presentation/widgets/auth_card_footer.dart';
export 'presentation/widgets/auth_card_field.dart';
export 'presentation/widgets/auth_divider.dart';

// Social auth.
export 'presentation/widgets/auth_social_row.dart';
export 'presentation/widgets/auth_social_button.dart';

// Role selection.
export 'presentation/widgets/role_card.dart';

// Sign-up form (stateful, self-contained).
export 'presentation/widgets/sign_up_form.dart';

// DOMAIN — Entities

export 'domain/entities/user_entity.dart';

// DOMAIN — Repository contract (abstract interface)

export 'domain/repositories/auth_repository.dart';

// DOMAIN — Use Cases

export 'domain/usecases/login_use_case.dart';
export 'domain/usecases/register_use_case.dart';
export 'domain/usecases/logout_use_case.dart';
export 'domain/usecases/get_current_user_use_case.dart';
export 'domain/usecases/verify_email_use_case.dart';
export 'domain/usecases/forgot_password_use_case.dart';
export 'domain/usecases/reset_password_use_case.dart';
export 'domain/usecases/google_sign_in_use_case.dart';
export 'domain/usecases/complete_registration_use_case.dart';

// DATA — Models

// Models extend domain entities with serialisation logic.
// Exported so other features (e.g. analytics, profile) can reuse them.
export 'data/models/user_model.dart';
export 'data/models/auth_model.dart';

// DATA — Repository & DataSource contracts (abstract interfaces only)

// Implementation files are intentionally excluded:
//   ✗  data/repositories/auth_repository_impl.dart  (DI concern)
//   ✗  data/datasources/auth_remote_data_source_impl.dart  (DI concern)
//   ✗  data/datasources/auth_local_data_source_impl.dart   (DI concern)

export 'data/datasources/auth_remote_data_source.dart';
export 'data/datasources/auth_local_data_source.dart';
