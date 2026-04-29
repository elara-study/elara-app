import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/features/student/chatbot/core/history_formatters.dart';
import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/presentation/chatbot_route_args.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_state.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/history_session_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Session list area: loading, error, empty, or refreshable list.
class HistorySessionsSection extends StatelessWidget {
  const HistorySessionsSection({
    super.key,
    required this.state,
    required this.filteredSessions,
    required this.onRefresh,
    required this.onRetry,
    required this.onSessionTap,
    required this.onRequestDelete,
  });

  final SessionsState state;
  final List<ChatbotSessionSummary> filteredSessions;
  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final ValueChanged<ChatbotRouteArgs> onSessionTap;
  final Future<void> Function(ChatbotSessionSummary session) onRequestDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if ((state.status == SessionsStatus.initial ||
            state.status == SessionsStatus.loading) &&
        state.sessions.isEmpty) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    if (state.status == SessionsStatus.failure && state.sessions.isEmpty) {
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
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (filteredSessions.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.trim().isEmpty
              ? 'No conversations yet.\nTap New Chat to begin.'
              : 'No chats match your search.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }

    return RefreshIndicator(
      color: cs.primary,
      backgroundColor: cs.surface,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.spacingLg.w,
          AppSpacing.spacingMd.h,
          AppSpacing.spacingLg.w,
          AppSpacing.spacing2xl.h,
        ),
        itemCount: filteredSessions.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: AppSpacing.spacingSm.h),
        itemBuilder: (context, index) {
          final s = filteredSessions[index];
          final title = s.title ?? 'New Chat';
          return HistorySessionCard(
            title: title,
            timeLabel: s.lastUpdatedAt != null
                ? formatRelativeTime(s.lastUpdatedAt!)
                : '—',
            preview: previewSubtitle(s),
            onTap: () => onSessionTap(
              ChatbotRouteArgs(sessionId: s.sessionId, sessionTitle: title),
            ),
            onDelete: () => onRequestDelete(s),
          );
        },
      ),
    );
  }
}
