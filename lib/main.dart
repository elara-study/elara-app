import 'package:elara/config/app_router.dart';
import 'package:elara/config/app_theme.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/localization/locale_cubit.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/services/notification_service.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/notifications/domain/usecases/register_device_token_use_case.dart';
import 'package:elara/features/notifications/domain/usecases/remove_device_token_use_case.dart';
import 'package:elara/l10n/generated/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase once
  await Firebase.initializeApp();
  
  await dotenv.load(fileName: ".env");
  await setupDependencyInjection();
  await getIt<LocaleCubit>().loadSavedLocale();

  final notificationService = getIt<NotificationService>();
  final authCubit = getIt<AuthCubit>();

  // Register device token callback before initialization
  notificationService.onTokenRefresh = (token) async {
    if (authCubit.state is AuthAuthenticated) {
      await getIt<RegisterDeviceTokenUseCase>().call(token);
    }
  };

  notificationService.onNotificationTap = (payload) async {
    debugPrint('[Notification Tap] Payload: $payload');
  };

  // Initialize notifications service
  await notificationService.initialize();

  runApp(const Elara());
}

class Elara extends StatefulWidget {
  const Elara({super.key});

  @override
  State<Elara> createState() => _ElaraState();
}

class _ElaraState extends State<Elara> {
  late final AuthCubit _authCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authCubit = getIt<AuthCubit>();
    _router = createAppRouter(_authCubit);
    getIt.registerSingleton<GoRouter>(_router);
    getIt<DioClient>().bindRouter(_router);
    getIt<DioClient>().authInterceptor.onSessionExpired =
        _authCubit.sessionExpired;

    // Listen to authentication changes to manage backend token registration
    _authCubit.stream.listen((state) async {
      final notificationService = getIt<NotificationService>();
      if (state is AuthAuthenticated) {
        final token = await notificationService.getToken();
        if (token != null) {
          await getIt<RegisterDeviceTokenUseCase>().call(token);
        }
      } else if (state is AuthUnauthenticated) {
        final token = await notificationService.getToken();
        if (token != null) {
          await getIt<RemoveDeviceTokenUseCase>().call(token);
        }
      }
    });

    // Check auth status and register token if already authenticated
    if (_authCubit.state is AuthAuthenticated) {
      getIt<NotificationService>().getToken().then((token) {
        if (token != null) {
          getIt<RegisterDeviceTokenUseCase>().call(token);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: _authCubit),
            BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
            BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, themeMode) {
              return BlocBuilder<LocaleCubit, Locale>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, locale) {
                  return MaterialApp.router(
                    title: 'Elara',
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    locale: locale,
                    localizationsDelegates: AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    routerConfig: _router,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
