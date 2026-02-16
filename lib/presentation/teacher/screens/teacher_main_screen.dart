import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_bottom_nav_bar.dart';
import 'package:elara/presentation/teacher/screens/teacher_classes_screen.dart'
    show TeacherClassesScreenContent;
import 'package:elara/presentation/teacher/screens/teacher_profile_screen.dart';
import 'package:flutter/material.dart';

/// Teacher shell with bottom nav: Home, Groups, Alerts, Profile (per Figma).
class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _TeacherDashboardTab(),
          TeacherClassesScreenContent(),
          _TeacherAlertsTab(),
          TeacherProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          AppNavBarItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
          ),
          AppNavBarItem(
            icon: Icons.group_outlined,
            selectedIcon: Icons.group,
            label: 'Groups',
          ),
          AppNavBarItem(
            icon: Icons.notifications_outlined,
            selectedIcon: Icons.notifications,
            label: 'Alerts',
          ),
          AppNavBarItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Placeholder tab for Alerts.
class _TeacherAlertsTab extends StatelessWidget {
  const _TeacherAlertsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'Alerts',
        actions: AppAppBar.mainTabActions(context),
      ),
      body: Center(
        child: Text(
          'Alerts',
          style: AppTypography.h5(color: AppColors.neutral600),
        ),
      ),
    );
  }
}

/// Dashboard tab: greeting, My Groups, statistics, Recent Activity (per Figma).
class _TeacherDashboardTab extends StatelessWidget {
  const _TeacherDashboardTab();

  static const _sampleGroups = [
    _GroupCard(name: 'Physics 101', studentCount: 24, isPrimaryGradient: true),
    _GroupCard(
      name: 'Advanced Math',
      studentCount: 18,
      isPrimaryGradient: false,
    ),
  ];

  static const _sampleActivity = [
    _ActivityItem(
      text: 'Alex M. completed Quantum Physics Basics',
      timeAgo: '2m ago',
    ),
    _ActivityItem(
      text: 'Mike R. submitted Calculus Homework',
      timeAgo: '1h ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'elara',
        actions: AppAppBar.mainTabActions(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting
              Text('Hello, Prof. Dalia', style: AppTypography.h3()),
              const SizedBox(height: AppSpacing.spacingXs),
              Text(
                'Ready to inspire today?',
                style: AppTypography.bodyMedium(color: AppColors.neutral600),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // My Groups section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Groups', style: AppTypography.h5()),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See All >',
                      style: AppTypography.bodySmall(
                        color: AppColors.brandPrimary500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              ..._sampleGroups.map(
                (g) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
                  child: _GroupCardWidget(card: g),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Statistics
              Row(
                children: [
                  const Expanded(
                    child: _StatCard(
                      icon: Icons.person,
                      label: 'Active Students',
                      value: '124',
                      gradient: AppGradients.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingLg),
                  const Expanded(
                    child: _StatCard(
                      icon: Icons.check_circle,
                      label: 'Avg. Completion',
                      value: '87%',
                      gradient: AppGradients.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Recent Activity
              Text('Recent Activity', style: AppTypography.h5()),
              const SizedBox(height: AppSpacing.spacingLg),
              ..._sampleActivity.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
                  child: _ActivityCard(item: a),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupCard {
  const _GroupCard({
    required this.name,
    required this.studentCount,
    required this.isPrimaryGradient,
  });
  final String name;
  final int studentCount;
  final bool isPrimaryGradient;
}

class _GroupCardWidget extends StatelessWidget {
  const _GroupCardWidget({required this.card});

  final _GroupCard card;

  @override
  Widget build(BuildContext context) {
    final gradient = card.isPrimaryGradient
        ? AppGradients.primary
        : AppGradients.secondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.teacherClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.group, color: AppColors.white, size: 28),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name,
                      style: AppTypography.h6(color: AppColors.white),
                    ),
                    Text(
                      '${card.studentCount} students',
                      style: AppTypography.bodySmall(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.neutral600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  final IconData icon;
  final String label;
  final String value;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.white, size: 24),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(label, style: AppTypography.caption(color: AppColors.white)),
          const SizedBox(height: AppSpacing.spacing2xs),
          Text(value, style: AppTypography.h4(color: AppColors.white)),
        ],
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({required this.text, required this.timeAgo});
  final String text;
  final String timeAgo;
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingLg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_none, size: 24, color: AppColors.neutral600),
          const SizedBox(width: AppSpacing.spacingMd),
          Expanded(child: Text(item.text, style: AppTypography.bodyMedium())),
          Text(
            item.timeAgo,
            style: AppTypography.caption(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }
}
