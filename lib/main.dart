import 'package:elara/config/app_theme.dart';
import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/theme_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  runApp(const Elara());
}

class Elara extends StatelessWidget {
  const Elara({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
            BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, themeMode) {
              return MaterialApp(
                title: 'Elara',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.generateRoute,
              );
            },
          ),
        );
      },
    );
  }
}
