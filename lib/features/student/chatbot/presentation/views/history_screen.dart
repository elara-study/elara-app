import 'package:elara/features/student/chatbot/domain/entities/chatbot_session_summary.dart';
import 'package:elara/features/student/chatbot/presentation/chatbot_route_args.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_state.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/history/history_panel_bottom_bar.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/history/history_panel_header.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/history/history_sessions_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          HistoryPanelHeader(
            searchController: _search,
            onClose: widget.onClose,
            onSearchChanged: (q) =>
                context.read<SessionsCubit>().updateSearchQuery(q),
          ),
          Expanded(
            child: BlocConsumer<SessionsCubit, SessionsState>(
              listenWhen: (p, c) =>
                  p.message != c.message && c.message != null,
              listener: (context, state) {
                final m = state.message;
                if (m != null && m.isNotEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(m)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<SessionsCubit>();
                final rows = cubit.filteredSessions();
                return HistorySessionsSection(
                  state: state,
                  filteredSessions: rows,
                  onRefresh: () => cubit.load(refresh: true),
                  onRetry: () => cubit.load(refresh: true),
                  onSessionTap: widget.onNavigateToChat,
                  onRequestDelete: (s) => _confirmDelete(context, cubit, s),
                );
              },
            ),
          ),
          HistoryPanelBottomBar(onNewChat: () => _openNewChat(context)),
        ],
      ),
    );
  }
}
