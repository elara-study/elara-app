import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_bottom_nav_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:elara/presentation/common/widgets/card_with_circle_background.dart';
import 'package:elara/presentation/common/widgets/daily_goal_item.dart';
import 'package:elara/presentation/common/widgets/stat_badge.dart';
import 'package:elara/presentation/student/widgets/student_home_group_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        items: [
          AppNavBarItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'student.home'.tr,
          ),
          AppNavBarItem(
            icon: Icons.book_outlined,
            selectedIcon: Icons.book,
            label: 'student.learn'.tr,
          ),
          AppNavBarItem(
            icon: Icons.emoji_events_outlined,
            selectedIcon: Icons.emoji_events,
            label: 'student.rewards'.tr,
          ),
          AppNavBarItem(
            icon: Icons.notifications_outlined,
            selectedIcon: Icons.notifications,
            label: 'student.alerts'.tr,
          ),
          AppNavBarItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'student.profile'.tr,
          ),
        ],
      ),
    );
  }
}

class _StudentHomeTab extends StatelessWidget {
  const _StudentHomeTab();

  static const _sampleGroups = [
    StudentHomeGroup(nameKey: 'student.physics101', progress: 5, isPrimary: true),
    StudentHomeGroup(nameKey: 'student.scienceExplorers', progress: 45, isPrimary: false),
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
            const Spacer(),
            const StatBadge(
              icon: Icons.local_fire_department,
              value: '7',
              color: AppColors.brandSecondary500,
            ),
            const SizedBox(width: AppSpacing.spacingSm),
            const StatBadge(
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
              Text('student.greetingEvening'.tr, style: AppTypography.h3()),
              Text(
                'student.readyToContinue'.tr,
                style: AppTypography.bodyLarge(color: AppColors.neutral600),
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // Continue where you left off
              CardWithCircleBackground(
                gradient: AppGradients.custom(
                  AppColors.brandPrimary600,
                  AppColors.brandPrimary400,
                ),
                child: InkWell(
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.studentClassDetail),
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingLg,
                      vertical: AppSpacing.spacing3xl,
                    ),
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
                                    'student.continueWhereLeftOff'.tr,
                                    style: AppTypography.caption(
                                      color: AppColors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.spacingLg),
                              Text(
                                'student.physics101'.tr,
                                style: AppTypography.h5(color: AppColors.white),
                              ),
                              const SizedBox(height: AppSpacing.spacingLg),
                              Row(
                                children: [
                                  Text(
                                    '${'student.lesson'.tr} 2 ${'student.of'.tr} 20',
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
                            Icons.play_arrow_outlined,
                            color: Color(0xff4D6A8A),
                            size: 24,
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
                  Text('student.dailyGoals'.tr, style: AppTypography.h5()),
                  Text(
                    '1/3 ${'student.complete'.tr}',
                    style: AppTypography.caption(color: AppColors.neutral600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              DailyGoalsCard(
                children: [
                  DailyGoalItem(
                    icon: Icons.flag_outlined,
                    label: 'student.completeLessons'.tr,
                    progress: 0.33,
                    points: 50,
                    backgroundColor: AppColors.primary50,
                  ),
                  DailyGoalItem(
                    icon: Icons.emoji_events_outlined,
                    label: 'student.scoreQuiz'.tr,
                    progress: 0.50,
                    points: 30,
                    backgroundColor: AppColors.brandSecondary500Alpha20,
                  ),
                  DailyGoalItem(
                    icon: Icons.flag_outlined,
                    label: 'student.practiceMins'.tr,
                    progress: 0.65,
                    points: 25,
                    backgroundColor: AppColors.primary50,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing2xl),
              // My Groups
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('student.myGroups'.tr, style: AppTypography.h5()),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'student.seeAll'.tr,
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
                  child: StudentHomeGroupCard(group: g),
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

class _StudentRewardsTab extends StatelessWidget {
  const _StudentRewardsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'student.rewards'.tr,
        actions: AppAppBar.mainTabActions(context),
      ),
      body: Center(
        child: Text(
          'student.rewards'.tr,
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
        title: 'student.alerts'.tr,
        actions: AppAppBar.mainTabActions(context),
      ),
      body: Center(
        child: Text(
          'student.alerts'.tr,
          style: AppTypography.h5(color: AppColors.neutral600),
        ),
      ),
    );
  }
}

class _StudentLearnTab extends StatelessWidget {
  const _StudentLearnTab();

  static final _sampleClasses = [
    _StudentClassCard(
      nameKey: 'student.classMath7A',
      subjectKey: 'student.subjectMath',
      gradeKey: 'student.grade7',
      progress: 65,
      studentCount: 28,
      lessons: '12/20',
    ),
    _StudentClassCard(
      nameKey: 'student.classScienceExplorers',
      subjectKey: 'student.subjectScience',
      gradeKey: 'student.grade7',
      progress: 45,
      studentCount: 25,
      lessons: '8/18',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'student.learn'.tr,
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
                        Text('student.myClasses'.tr, style: AppTypography.h3()),
                        const SizedBox(height: AppSpacing.spacingXs),
                        Text(
                          'student.enrolledClasses'.tr,
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
                      text: 'student.join'.tr,
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
    required this.nameKey,
    required this.subjectKey,
    required this.gradeKey,
    required this.progress,
    required this.studentCount,
    required this.lessons,
  });
  final String nameKey;
  final String subjectKey;
  final String gradeKey;
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
                  Text(card.nameKey.tr, style: AppTypography.h6()),
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
                      card.subjectKey.tr,
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
                        card.gradeKey.tr,
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
                    '${card.studentCount} ${'student.students'.tr}',
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
                    '${card.lessons} ${'student.lessons'.tr}',
                    style: AppTypography.bodySmall(color: AppColors.neutral600),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              // Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('student.yourProgress'.tr, style: AppTypography.bodyMedium()),
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
        title: 'student.profile'.tr,
        actions: AppAppBar.settingsAction(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('teacher.editProfile'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('teacher.changePassword'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text('teacher.notifications'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('teacher.helpCenter'.tr, style: AppTypography.bodyLarge()),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.error500),
            title: Text(
              'teacher.logout'.tr,
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
