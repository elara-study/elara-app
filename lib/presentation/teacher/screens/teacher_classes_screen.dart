import 'package:elara/config/dependency_injection.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/data/api/class_api_service.dart';
import 'package:elara/data/models/api_models.dart';
import 'package:elara/presentation/common/widgets/app_app_bar.dart';
import 'package:flutter/material.dart';

/// Groups list content for Teacher - fetches from backend API.
class TeacherClassesScreenContent extends StatefulWidget {
  const TeacherClassesScreenContent({super.key});

  @override
  State<TeacherClassesScreenContent> createState() => _TeacherClassesScreenContentState();
}

class _TeacherClassesScreenContentState extends State<TeacherClassesScreenContent> {
  final _classApi = getIt<ClassApiService>();
  List<ClassModel>? _classes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final classes = await _classApi.getClasses();
      if (mounted) {
        setState(() {
          _classes = classes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppAppBar.withTabs(
          title: 'Groups',
          bottom: TabBar(
            indicatorColor: AppColors.brandPrimary500,
            labelColor: AppColors.brandPrimary500,
            unselectedLabelColor: AppColors.neutral600,
            tabs: const [Tab(text: 'Groups')],
          ),
          actions: AppAppBar.mainTabActions(context),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading classes', style: AppTypography.h6()),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error!, textAlign: TextAlign.center, style: AppTypography.bodySmall()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadClasses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_classes == null || _classes!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.class_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No classes yet', style: AppTypography.h5()),
            const SizedBox(height: 8),
            const Text('Create your first class to get started'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.teacherCreateClass),
              icon: const Icon(Icons.add),
              label: const Text('Create Class'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.spacing2xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Groups', style: AppTypography.h5()),
              Material(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.teacherCreateClass),
                  borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingMd,
                      vertical: AppSpacing.spacingSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18, color: AppColors.neutral700),
                        const SizedBox(width: AppSpacing.spacingXs),
                        Text('Create', style: AppTypography.labelMedium(color: AppColors.neutral800)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingLg),
          ..._classes!.map((classItem) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.spacingLg),
                child: _ClassCard(classModel: classItem),
              )),
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  final ClassModel classModel;

  const _ClassCard({required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.teacherClassDetail),
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with class name
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingLg,
                  vertical: AppSpacing.spacingMd,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.brandPrimary600,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.radiusLg)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        classModel.name,
                        style: AppTypography.h6(color: AppColors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
                      ),
                      child: Text(
                        classModel.joinCode,
                        style: AppTypography.caption(color: AppColors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Body with description and teacher
              Padding(
                padding: const EdgeInsets.all(AppSpacing.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(classModel.description, style: AppTypography.bodyMedium()),
                    const SizedBox(height: AppSpacing.spacingSm),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 16, color: AppColors.neutral600),
                        const SizedBox(width: 4),
                        Text(
                          classModel.teacherName,
                          style: AppTypography.bodySmall(color: AppColors.neutral600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
