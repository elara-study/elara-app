import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/notifications/presentation/views/notifications_screen.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_cubit.dart';
import 'package:elara/features/parent/presentation/children/cubits/parent_children_state.dart';
import 'package:elara/features/parent/presentation/children/views/parent_children_screen.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_cubit.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_tab_cubit.dart';
import 'package:elara/features/parent/presentation/home/views/parent_home_screen.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_cubit.dart';
import 'package:elara/features/parent/presentation/reports/views/parent_reports_screen.dart';
import 'package:elara/features/parent/presentation/profile/views/parent_profile_screen.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Root shell for the parent role — bottom nav per Figma (Home, Children, Reports, Alerts, Profile).
class ParentShell extends StatelessWidget {
  const ParentShell({super.key});

  static const List<Widget> _pages = [
    ParentHomeScreen(),
    ParentChildrenScreen(),
    ParentReportsScreen(),
    NotificationsScreen(),
    ParentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParentTabCubit>(create: (_) => getIt<ParentTabCubit>()),
        BlocProvider<ParentHomeCubit>(
          create: (_) => getIt<ParentHomeCubit>()..loadHome(),
        ),
        BlocProvider<ParentReportsCubit>(
          create: (_) => getIt<ParentReportsCubit>()..loadReports(),
        ),
        BlocProvider<ParentChildrenCubit>(
          create: (_) => getIt<ParentChildrenCubit>()..loadChildren(),
        ),
        BlocProvider<ParentProfileCubit>(
          create: (_) => getIt<ParentProfileCubit>()..loadProfile(),
        ),
      ],
      child: BlocListener<ParentChildrenCubit, ParentChildrenState>(
        listenWhen: (prev, curr) =>
            curr is ParentChildrenLoaded &&
            (curr.successMessage != null || curr.errorMessage != null),
        listener: (context, state) {
          if (state is ParentChildrenLoaded) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.success500,
                ),
              );
              context.read<ParentChildrenCubit>().clearMessages();
              context.read<ParentHomeCubit>().loadHome();
              context.read<ParentProfileCubit>().loadProfile();
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
              context.read<ParentChildrenCubit>().clearMessages();
            }
          }
        },
        child: BlocBuilder<ParentTabCubit, int>(
          builder: (context, currentTab) {
            return Scaffold(
              extendBody: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Stack(
                children: [
                  IndexedStack(index: currentTab, children: _pages),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AppBottomNavBar(
                      currentIndex: currentTab,
                      onTap: (i) => context.read<ParentTabCubit>().goToTab(i),
                      tabs: [
                        AppNavTab(label: context.l10n.navHome, assetPath: 'assets/icons/home_icon.svg'),
                        AppNavTab(label: context.l10n.navChildren, assetPath: 'assets/icons/people_outline.svg'),
                        AppNavTab(label: context.l10n.navReports, assetPath: 'assets/icons/report_icon.svg'),
                        AppNavTab(label: context.l10n.navAlerts, assetPath: 'assets/icons/alerts_icon.svg'),
                        AppNavTab(label: context.l10n.navProfile, assetPath: 'assets/icons/profile_icon.svg'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
