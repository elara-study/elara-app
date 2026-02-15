import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/presentation/common/widgets/app_bottom_nav_bar.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Student shell with bottom nav: Learn, Classes, Profile (per Figma).
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
          _StudentLearnTab(),
          _StudentClassesTab(),
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
            label: 'Learn',
          ),
          AppNavBarItem(
            icon: Icons.menu_book_outlined,
            selectedIcon: Icons.menu_book,
            label: 'Classes',
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

class _StudentLearnTab extends StatelessWidget {
  const _StudentLearnTab();

  static const _sampleClasses = [
    _StudentClassCard(name: 'Mathematics 7A', subject: 'MATHEMATICS', grade: 'Grade 7', progress: 65, studentCount: 28, lessons: '12/20'),
    _StudentClassCard(name: 'Science Explorers', subject: 'SCIENCE', grade: 'Grade 7', progress: 45, studentCount: 25, lessons: '8/18'),
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
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.studentJoinClass),
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

class _StudentClassesTab extends StatelessWidget {
  const _StudentClassesTab();

  static const _sampleClasses = [
    _StudentClassCard(name: 'Mathematics 7A', subject: 'MATHEMATICS', grade: 'Grade 7', progress: 65, studentCount: 28, lessons: '12/20'),
    _StudentClassCard(name: 'Science Explorers', subject: 'SCIENCE', grade: 'Grade 7', progress: 45, studentCount: 25, lessons: '8/18'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.mainTab(
        title: 'My Classes',
        actions: AppAppBar.addAction(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.studentJoinClass),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing2xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('My Classes', style: AppTypography.h3()),
            const SizedBox(height: AppSpacing.spacing2xl),
            ..._sampleClasses.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
                child: _StudentClassCardWidget(card: c),
              ),
            ),
          ],
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
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.studentClassDetail),
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
                      Icon(Icons.school_outlined, size: 16, color: AppColors.neutral600),
                      const SizedBox(width: AppSpacing.spacing2xs),
                      Text(
                        card.grade,
                        style: AppTypography.bodySmall(color: AppColors.neutral600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              // Stats: students, lessons
              Row(
                children: [
                  Icon(Icons.people_outline, size: 16, color: AppColors.neutral600),
                  const SizedBox(width: AppSpacing.spacingXs),
                  Text(
                    '${card.studentCount} students',
                    style: AppTypography.bodySmall(color: AppColors.neutral600),
                  ),
                  const SizedBox(width: AppSpacing.spacingLg),
                  Icon(Icons.menu_book_outlined, size: 16, color: AppColors.neutral600),
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
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandPrimary500),
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
            title: Text('Logout', style: AppTypography.bodyLarge(color: AppColors.error500)),
            onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelector),
          ),
        ],
      ),
    );
  }
}
