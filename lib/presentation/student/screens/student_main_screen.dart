import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_bottom_nav_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Student shell with bottom nav: Home, Learn, Rewards, Alerts, Profile (per Figma).
class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _StudentHomeTab(),
          _StudentLearnTab(),
          _StudentRewardsTab(),
          _StudentAlertsTab(),
          _StudentProfileTab(),
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
            icon: Icons.book_outlined,
            selectedIcon: Icons.book,
            label: 'Learn',
          ),
          AppNavBarItem(
            icon: Icons.emoji_events_outlined,
            selectedIcon: Icons.emoji_events,
            label: 'Rewards',
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

/// Card with decorative circles at edges (light opacity) - rounded box style.
/// Circles are a lighter shade overlay, clipped by card bounds.
class _CardWithCircleBackground extends StatelessWidget {
  const _CardWithCircleBackground({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = AppRadius.radiusLg;
    // Lighter circles for subtle overlay (lighter shade than card background)
    final circleColor = AppColors.white.withValues(alpha: 0.12);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topLeft,
          children: [
            // Semi-transparent circles at top-right and bottom-left edges
            Positioned(
              top: -50,
              right: -50,
              child: IgnorePointer(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: IgnorePointer(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                ),
              ),
            ),
            // Content on top, drives stack size
            child,
          ],
        ),
      ),
    );
  }
}

class _StudentHomeTab extends StatelessWidget {
  const _StudentHomeTab();

  static const _sampleGroups = [
    _StudentHomeGroup(name: 'Physics 101', progress: 5, isPrimary: true),
    _StudentHomeGroup(
      name: 'Science Explorers',
      progress: 45,
      isPrimary: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final fgColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.neutral50
        : AppColors.neutral900;

    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'elara',
        titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('elara', style: AppTypography.h6(color: fgColor)),
            const SizedBox(width: AppSpacing.spacingLg),
            _StatBadge(
              icon: Icons.local_fire_department,
              value: '7',
              color: AppColors.brandSecondary500,
            ),
            const SizedBox(width: AppSpacing.spacingSm),
            _StatBadge(
              icon: Icons.emoji_events,
              value: '1250',
              color: AppColors.neutral500,
            ),
          ],
        ),
        titleAlign: Alignment.centerLeft,
        actions: AppAppBar.mainTabActions(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Good evening, Tyler!', style: AppTypography.h3()),
              Text(
                'Ready to continue your learning journey?',
                style: AppTypography.bodyMedium(color: AppColors.neutral600),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Continue where you left off
              _CardWithCircleBackground(
                backgroundColor: AppColors.brandPrimary600,
                child: InkWell(
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.studentClassDetail),
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.spacingLg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: AppColors.white.withValues(
                                      alpha: 0.85,
                                    ),
                                    size: 18,
                                  ),
                                  const SizedBox(width: AppSpacing.spacingXs),
                                  Text(
                                    'Continue where you left off',
                                    style: AppTypography.caption(
                                      color: AppColors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spacingSm),
                              Text(
                                'Physics 101',
                                style: AppTypography.h5(color: AppColors.white),
                              ),
                              const SizedBox(height: AppSpacing.spacing2xs),
                              Row(
                                children: [
                                  Text(
                                    'Lesson 2 of 20',
                                    style: AppTypography.bodySmall(
                                      color: AppColors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '5%',
                                    style: AppTypography.bodySmall(
                                      color: AppColors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spacingXs),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.radiusFull,
                                ),
                                child: LinearProgressIndicator(
                                  value: 0.05,
                                  backgroundColor: AppColors.white.withValues(
                                    alpha: 0.25,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white.withValues(alpha: 0.5),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacingMd),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: AppColors.neutral800,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Daily Goals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Daily Goals', style: AppTypography.h5()),
                  Text(
                    '1/3 completed',
                    style: AppTypography.caption(color: AppColors.neutral600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              _DailyGoalItem(
                icon: Icons.flag_outlined,
                label: 'Complete 3 lessons',
                progress: 0.33,
                points: 50,
              ),
              _DailyGoalItem(
                icon: Icons.emoji_events_outlined,
                label: 'Score 80% on a quiz',
                progress: 0,
                points: 30,
              ),
              _DailyGoalItem(
                icon: Icons.flag_outlined,
                label: 'Practice for 15 mins',
                progress: 0,
                points: 25,
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // My Groups
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
                  child: _StudentHomeGroupCard(group: g),
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

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm,
        vertical: AppSpacing.spacing2xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.spacing2xs),
          Text(value, style: AppTypography.labelMedium(color: color)),
        ],
      ),
    );
  }
}

class _DailyGoalItem extends StatelessWidget {
  const _DailyGoalItem({
    required this.icon,
    required this.label,
    required this.progress,
    required this.points,
  });

  final IconData icon;
  final String label;
  final double progress;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
      child: Container(
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.brandPrimary600, size: 20),
            ),
            const SizedBox(width: AppSpacing.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTypography.bodyMedium()),
                  const SizedBox(height: AppSpacing.spacingXs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.neutral200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.brandPrimary500,
                      ),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+$points',
                  style: AppTypography.labelMedium(
                    color: AppColors.brandSecondary600,
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing2xs),
                Icon(Icons.bolt, size: 14, color: AppColors.brandAccent500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentHomeGroup {
  const _StudentHomeGroup({
    required this.name,
    required this.progress,
    required this.isPrimary,
  });
  final String name;
  final int progress;
  final bool isPrimary;
}

class _StudentHomeGroupCard extends StatelessWidget {
  const _StudentHomeGroupCard({required this.group});

  final _StudentHomeGroup group;

  @override
  Widget build(BuildContext context) {
    final bgColor = group.isPrimary
        ? AppColors.brandPrimary600
        : AppColors.brandSecondary500;
    return _CardWithCircleBackground(
      backgroundColor: bgColor,
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.studentClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: AppTypography.h6(color: AppColors.white),
                    ),
                    Text(
                      '${group.progress}% complete',
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
                  color: group.isPrimary
                      ? AppColors.neutral600
                      : AppColors.brandSecondary600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentRewardsTab extends StatelessWidget {
  const _StudentRewardsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'Rewards',
        actions: AppAppBar.mainTabActions(context),
      ),
      body: Center(
        child: Text(
          'Rewards',
          style: AppTypography.h5(color: AppColors.neutral600),
        ),
      ),
    );
  }
}

class _StudentAlertsTab extends StatelessWidget {
  const _StudentAlertsTab();

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

class _StudentLearnTab extends StatelessWidget {
  const _StudentLearnTab();

  static const _sampleClasses = [
    _StudentClassCard(
      name: 'Mathematics 7A',
      subject: 'MATHEMATICS',
      grade: 'Grade 7',
      progress: 65,
      studentCount: 28,
      lessons: '12/20',
    ),
    _StudentClassCard(
      name: 'Science Explorers',
      subject: 'SCIENCE',
      grade: 'Grade 7',
      progress: 45,
      studentCount: 25,
      lessons: '8/18',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'Learn',
        actions: AppAppBar.mainTabActions(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing2xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header: My Classes + body + Join (Figma)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Classes', style: AppTypography.h3()),
                        const SizedBox(height: AppSpacing.spacingXs),
                        Text(
                          'Your enrolled classes',
                          style: AppTypography.bodyLarge(
                            color: AppColors.neutral600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingMd),
                  Flexible(
                    child: AppOutlineButton(
                      text: 'Join',
                      icon: Icons.login,
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.studentJoinClass),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Class cards (Figma Group Card style)
              ..._sampleClasses.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
                  child: _StudentClassCardWidget(card: c),
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

class _StudentClassCard {
  const _StudentClassCard({
    required this.name,
    required this.subject,
    required this.grade,
    required this.progress,
    required this.studentCount,
    required this.lessons,
  });
  final String name;
  final String subject;
  final String grade;
  final int progress;
  final int studentCount;
  final String lessons;
}

/// Figma Group Card for student: subject, grade, teacher, stats, progress.
class _StudentClassCardWidget extends StatelessWidget {
  const _StudentClassCardWidget({required this.card});

  final _StudentClassCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.studentClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top: subject, grade
              Wrap(
                spacing: AppSpacing.spacingSm,
                runSpacing: AppSpacing.spacingXs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(card.name, style: AppTypography.h6()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingSm,
                      vertical: AppSpacing.spacing2xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary100,
                      borderRadius: BorderRadius.circular(AppRadius.radiusXs),
                    ),
                    child: Text(
                      card.subject,
                      style: AppTypography.caption(
                        color: AppColors.brandPrimary700,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 16,
                        color: AppColors.neutral600,
                      ),
                      const SizedBox(width: AppSpacing.spacing2xs),
                      Text(
                        card.grade,
                        style: AppTypography.bodySmall(
                          color: AppColors.neutral600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              // Stats: students, lessons
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: AppColors.neutral600,
                  ),
                  const SizedBox(width: AppSpacing.spacingXs),
                  Text(
                    '${card.studentCount} students',
                    style: AppTypography.bodySmall(color: AppColors.neutral600),
                  ),
                  const SizedBox(width: AppSpacing.spacingLg),
                  Icon(
                    Icons.menu_book_outlined,
                    size: 16,
                    color: AppColors.neutral600,
                  ),
                  const SizedBox(width: AppSpacing.spacingXs),
                  Text(
                    '${card.lessons} lessons',
                    style: AppTypography.bodySmall(color: AppColors.neutral600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your progress', style: AppTypography.bodyMedium()),
                  Text('${card.progress}%', style: AppTypography.bodyMedium()),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingXs),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                child: LinearProgressIndicator(
                  value: card.progress / 100,
                  backgroundColor: AppColors.neutral200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.brandPrimary500,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudentProfileTab extends StatelessWidget {
  const _StudentProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'Profile',
        actions: AppAppBar.settingsAction(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('Edit Profile', style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('Change Password', style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text('Notifications', style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('Help Center', style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error500),
            title: Text(
              'Logout',
              style: AppTypography.bodyLarge(color: AppColors.error500),
            ),
            onTap: () => Navigator.of(
              context,
            ).pushReplacementNamed(AppRoutes.roleSelector),
          ),
        ],
      ),
    );
  }
}
