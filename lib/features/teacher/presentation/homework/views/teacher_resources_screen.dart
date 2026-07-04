import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';
import 'package:elara/features/teacher/presentation/homework/cubits/teacher_resources_cubit.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_module_route_args.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_add_resource_dialog.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_image_grid.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_resource_card.dart';
import 'package:elara/shared/widgets/app_dialog.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Fixed display order of resource-type sections.
const _kSectionOrder = [
  TeacherResourceType.video,
  TeacherResourceType.pdf,
  TeacherResourceType.image,
  TeacherResourceType.link,
  TeacherResourceType.document,
];

/// Teacher resources management screen for a specific module.
///
/// Provides its own [TeacherResourcesCubit] and loads on mount.
/// Pushed via [AppRoutes.teacherModuleResources].
class TeacherResourcesScreen extends StatelessWidget {
  final String moduleId;
  final String moduleTitle;
  final String moduleLabel;
  final String groupId;
  final String subject;

  const TeacherResourcesScreen({
    super.key,
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleLabel,
    required this.groupId,
    required this.subject,
  });

  factory TeacherResourcesScreen.fromArgs(TeacherModuleRouteArgs args) =>
      TeacherResourcesScreen(
        moduleId: args.moduleId,
        moduleTitle: args.moduleTitle,
        moduleLabel: args.moduleLabel,
        groupId: args.groupId,
        subject: args.subject,
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherResourcesCubit>(
      create: (_) =>
          getIt<TeacherResourcesCubit>()
            ..load(moduleId: moduleId, groupId: groupId),
      child: BlocBuilder<TeacherResourcesCubit, TeacherResourcesState>(
        builder: (context, state) => switch (state) {
          TeacherResourcesInitial() || TeacherResourcesLoading() => Scaffold(
            appBar: AppGlassHeader(
              title: 'Resources',
              subtitle: '$subject • $moduleTitle',
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
          TeacherResourcesError(:final message) => Scaffold(
            appBar: AppGlassHeader(
              title: 'Resources',
              subtitle: '$subject • $moduleTitle',
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 48.sp,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(message, textAlign: TextAlign.center),
                    SizedBox(height: AppSpacing.spacingXl.h),
                    TextButton(
                      onPressed: () => context
                          .read<TeacherResourcesCubit>()
                          .load(moduleId: moduleId, groupId: groupId),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TeacherResourcesLoaded(:final resources) => _ResourcesView(
            resources: resources,
            moduleTitle: moduleTitle,
            subject: subject,
            moduleId: moduleId,
            groupId: groupId,
          ),
        },
      ),
    );
  }
}

// ── Loaded view (owns search state) ──────────────────────────────────────────

class _ResourcesView extends StatefulWidget {
  final List<TeacherResourceEntity> resources;
  final String moduleTitle;
  final String subject;
  final String moduleId;
  final String groupId;

  const _ResourcesView({
    required this.resources,
    required this.moduleTitle,
    required this.subject,
    required this.moduleId,
    required this.groupId,
  });

  @override
  State<_ResourcesView> createState() => _ResourcesViewState();
}

class _ResourcesViewState extends State<_ResourcesView> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<TeacherResourceEntity> get _filtered {
    if (_query.isEmpty) return widget.resources;
    final q = _query.toLowerCase();
    return widget.resources
        .where((r) => r.title.toLowerCase().contains(q))
        .toList();
  }

  void _handleResourceTap(BuildContext context, TeacherResourceEntity resource) async {
    if (resource.type == TeacherResourceType.image) {
      _showImageFullScreen(context, resource.url);
      return;
    }

    if (resource.url.isNotEmpty) {
      final uri = Uri.parse(resource.url);
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched) {
          await launchUrl(
            uri,
            mode: LaunchMode.platformDefault,
          );
        }
      } catch (_) {
        if (context.mounted) {
          AppSnackBar.error(context, 'Could not open resource: ${resource.title}');
        }
      }
    }
  }

  void _showImageFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, TeacherResourceType type) {
    AppDialog.show(
      context: context,
      builder: (_) => AppDialog(
        title: 'Add Resource',
        content: TeacherAddResourceDialogContent(
          type: type,
          onSubmit: (title, url, description) {
            context.read<TeacherResourcesCubit>().addResource(
                  moduleId: widget.moduleId,
                  groupId: widget.groupId,
                  title: title,
                  filePath: url,
                );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSections(BuildContext context) {
    final filtered = _filtered;
    final widgets = <Widget>[];

    for (final type in _kSectionOrder) {
      final items = filtered.where((r) => r.type == type).toList();

      widgets.add(SizedBox(height: AppSpacing.spacingXl.h));
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
          child: AppSectionHeader(
            title: type.sectionTitle,
            onAdd: () => _showAddDialog(context, type),
          ),
        ),
      );
      widgets.add(SizedBox(height: AppSpacing.spacingMd.h));

      if (type == TeacherResourceType.image) {
        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacingLg.w),
            child: TeacherImageGrid(
              resources: items,
              onTap: (r) => _handleResourceTap(context, r),
            ),
          ),
        );
      } else {
        for (final resource in items) {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.spacingLg.w,
                right: AppSpacing.spacingLg.w,
                bottom: AppSpacing.spacingMd.h,
              ),
              child: TeacherResourceCard(
                resource: resource,
                onTap: () => _handleResourceTap(context, resource),
                onEdit: () {},
                onDelete: () {},
              ),
            ),
          );
        }
      }
    }

    widgets.add(SizedBox(height: AppSpacing.spacing5xl.h));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppGlassHeader(
        title: 'Resources',
        subtitle: '${widget.subject} • ${widget.moduleTitle}',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: topOffset),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg.w,
              vertical: AppSpacing.spacingMd.h,
            ),
            child: _SearchBar(
              controller: _searchCtrl,
              onChanged: (v) {
                setState(() => _query = v.trim());
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _buildSections(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _SearchBar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radiusFull.r),
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyMedium(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: 'Search resources...',
        hintStyle: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: cs.onSurfaceVariant,
          size: 20.sp,
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.spacingMd.h),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
