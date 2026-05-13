import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_home_cubit.dart';
import 'package:elara/features/parent/presentation/home/cubits/parent_tab_cubit.dart';
import 'package:elara/features/parent/presentation/home/views/parent_home_screen.dart';
import 'package:elara/features/parent/presentation/reports/cubits/parent_reports_cubit.dart';
import 'package:elara/features/parent/presentation/reports/views/parent_reports_screen.dart';
import 'package:elara/shared/widgets/app_bottom_nav_bar.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Root shell for the parent role — bottom nav per Figma (Home, Children,
/// Reports, Alerts, Profile).
class ParentShell extends StatelessWidget {
  const ParentShell({super.key});

  static const List<Widget> _pages = [
    ParentHomeScreen(),
    _ParentPlaceholderPage(title: 'Children'),
    ParentReportsScreen(),
    _ParentPlaceholderPage(title: 'Alerts'),
    _ParentPlaceholderPage(title: 'Profile'),
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
      ],
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
                    tabs: AppBottomNavBar.parentTabs,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ParentPlaceholderPage extends StatelessWidget {
  const _ParentPlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(title: title),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingMd.h),
            Text(title, style: AppTypography.h5(color: cs.onSurface)),
            SizedBox(height: 6.h),
            Text(
              'Coming soon',
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
