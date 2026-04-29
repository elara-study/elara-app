import 'dart:ui';

import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/chatbot/core/history_formatters.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/presentation/chatbot_route_args.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_state.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/history_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Past conversations — search, list, new chat. Intended for [Scaffold.drawer].
class HistoryPanel extends StatefulWidget {
  const HistoryPanel({
    super.key,
    required this.onNavigateToChat,
    required this.onClose,
  });

  /// Replace current chat route with the selected / new thread.
  final ValueChanged<ChatbotRouteArgs> onNavigateToChat;

  final VoidCallback onClose;

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SessionsCubit cubit,
    ChatbotSessionSummary session,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete chat?'),
        content: const Text('This removes the conversation from your history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await cubit.deleteSession(session.sessionId);
    }
  }

  Future<void> _openNewChat(BuildContext context) async {
    final cubit = context.read<SessionsCubit>();
    final id = await cubit.createSessionAndReturnId();
    if (id != null && context.mounted) {
      widget.onNavigateToChat(ChatbotRouteArgs(sessionId: id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HistoryHeader(
            searchController: _search,
            onClose: widget.onClose,
            onSearchChanged: (q) =>
                context.read<SessionsCubit>().updateSearchQuery(q),
          ),
          Expanded(
            child: BlocConsumer<SessionsCubit, SessionsState>(
              listenWhen: (p, c) => p.message != c.message && c.message != null,
              listener: (context, state) {
                final m = state.message;
                if (m != null && m.isNotEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(m)));
                }
              },
              builder: (context, state) {
                final cs = Theme.of(context).colorScheme;
                final textTheme = Theme.of(context).textTheme;
                if ((state.status == SessionsStatus.initial ||
                        state.status == SessionsStatus.loading) &&
                    state.sessions.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(color: cs.primary),
                  );
                }
                if (state.status == SessionsStatus.failure &&
                    state.sessions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message ?? 'Something went wrong',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: AppSpacing.spacingLg.h),
                          FilledButton(
                            onPressed: () => context.read<SessionsCubit>().load(
                              refresh: true,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final cubit = context.read<SessionsCubit>();
                final rows = cubit.filteredSessions();
                if (rows.isEmpty) {
                  return Center(
                    child: Text(
                      state.searchQuery.trim().isEmpty
                          ? 'No conversations yet.\nTap New Chat to begin.'
                          : 'No chats match your search.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: cs.primary,
                  backgroundColor: cs.surface,
                  onRefresh: () =>
                      context.read<SessionsCubit>().load(refresh: true),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.spacingLg.w,
                      AppSpacing.spacingMd.h,
                      AppSpacing.spacingLg.w,
                      AppSpacing.spacing2xl.h,
                    ),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSpacing.spacingSm.h),
                    itemBuilder: (context, index) {
                      final s = rows[index];
                      final title = s.title ?? 'New Chat';
                      return HistorySessionCard(
                        title: title,
                        timeLabel: s.lastUpdatedAt != null
                            ? formatRelativeTime(s.lastUpdatedAt!)
                            : '—',
                        preview: previewSubtitle(s),
                        onTap: () {
                          widget.onNavigateToChat(
                            ChatbotRouteArgs(
                              sessionId: s.sessionId,
                              sessionTitle: title,
                            ),
                          );
                        },
                        onDelete: () => _confirmDelete(context, cubit, s),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          _HistoryBottomBar(onNewChat: () => _openNewChat(context)),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({
    required this.searchController,
    required this.onClose,
    required this.onSearchChanged,
  });

  final TextEditingController searchController;
  final VoidCallback onClose;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.94),
            border: Border(bottom: BorderSide(color: cs.outlineVariant)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.spacingLg.w,
              AppSpacing.spacingMd.h,
              AppSpacing.spacingLg.w,
              AppSpacing.spacingLg.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'History',
                        style:
                            AppTypography.h5(
                              font: 'Comfortaa',
                              color: cs.onSurface,
                            ).copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              height: 28 / 20,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: cs.onSurface),
                      onPressed: onClose,
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).closeButtonLabel,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.spacingSm.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radiusXl.r),
                  clipBehavior: Clip.antiAlias,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        AppRadius.radiusFull.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withValues(alpha: 0.08),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearchChanged,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface,
                      ),
                      cursorColor: cs.primary,
                      decoration: InputDecoration(
                        hintText: 'Search chats...',
                        hintStyle: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          height: 18 / 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: cs.onSurfaceVariant,
                          size: 20.sp,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingMd.w,
                          vertical: AppSpacing.spacingMd.h,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryBottomBar extends StatelessWidget {
  const _HistoryBottomBar({required this.onNewChat});

  final VoidCallback onNewChat;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.94),
            border: Border(top: BorderSide(color: cs.outlineVariant)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.spacingLg.w),
              child: FilledButton.icon(
                onPressed: onNewChat,
                icon: Icon(Icons.add_rounded, size: 22.sp),
                label: Text(
                  'New Chat',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                    height: 24 / 16,
                    color: LightModeColors.textPrimaryInverse,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  minimumSize: Size(double.infinity, 52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radiusMd.r),
                  ),
                  elevation: 2,
                  shadowColor: cs.shadow.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
