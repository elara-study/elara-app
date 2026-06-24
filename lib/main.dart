import 'package:elara/config/app_router.dart';
import 'package:elara/config/app_theme.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/network/dio_client.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await setupDependencyInjection();

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
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Elara',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: _router,
              );
            },
          ),
        );
      },
    );
  }
}
