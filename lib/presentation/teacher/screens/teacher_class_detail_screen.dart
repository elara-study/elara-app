import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/presentation/common/widgets/app_buttons.dart';
import 'package:flutter/material.dart';

/// Class detail with Students and Quizzes tabs (per Figma).
class TeacherClassDetailScreen extends StatefulWidget {
  const TeacherClassDetailScreen({super.key});

  @override
  State<TeacherClassDetailScreen> createState() => _TeacherClassDetailScreenState();
}

class _TeacherClassDetailScreenState extends State<TeacherClassDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar.withTabs(
        title: 'Mathematics Class',
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Quizzes'),
          ],
        ),
        actions: AppAppBar.addAction(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.teacherAddStudent),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StudentsTab(),
          _QuizzesTab(),
        ],
      ),
    );
  }
}

class _StudentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final students = [
      _StudentRow(name: 'Ahmed Mohamed', email: 'ahmed@example.com'),
      _StudentRow(name: 'Sara Ali', email: 'sara@example.com'),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      itemCount: students.length,
      itemBuilder: (_, i) {
        final s = students[i];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.brandPrimary100,
              child: Text(s.name[0], style: AppTypography.labelLarge(color: AppColors.brandPrimary600)),
            ),
            title: Text(s.name, style: AppTypography.labelLarge()),
            subtitle: Text(s.email, style: AppTypography.bodySmall()),
          ),
        );
      },
    );
  }
}

class _StudentRow {
  const _StudentRow({required this.name, required this.email});
  final String name;
  final String email;
}

class _QuizzesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Class quizzes', style: AppTypography.bodyLarge()),
          const SizedBox(height: AppSpacing.spacingLg),
          AppPrimaryButton(
            text: 'Create Quiz',
            icon: Icons.add,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.teacherCreateQuiz),
          ),
        ],
      ),
    );
  }
}
