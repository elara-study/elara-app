import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/features/student/chatbot/presentation/chatbot_route_args.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_state.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/views/history_screen.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/attachment_menu.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_composer_bar.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_glass_app_bar.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_load_error_view.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_message_list_view.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/chatbot/chatbot_screen_dimensions.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/image_preview_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, required this.routeArgs});

  final ChatbotRouteArgs routeArgs;

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scroll = ScrollController();
  final TextEditingController _text = TextEditingController();
  final TextEditingController _caption = TextEditingController();
  final GlobalKey _attachmentMenuAnchorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ChatbotCubit>().start(
            routeSessionId: widget.routeArgs.sessionId,
            routeSessionTitle: widget.routeArgs.sessionTitle,
          );
    });
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final cubit = context.read<ChatbotCubit>();
    final max = _scroll.position.maxScrollExtent;
    final offset = _scroll.offset;
    final nearBottom = max - offset < 100;
    cubit.setScrollFabVisible(!nearBottom && max > 80);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _text.dispose();
    _caption.dispose();
    super.dispose();
  }

  Future<void> _pick(ImageSource source) async {
    await context.read<ChatbotCubit>().pickImageForPreview(source);
  }

  Future<void> _openAttachmentMenu() async {
    final source = await showAttachmentMenu(
      context: context,
      anchorKey: _attachmentMenuAnchorKey,
    );
    if (source != null && mounted) {
      await _pick(source);
    }
  }

  void _navigateFromHistory(ChatbotRouteArgs args) {
    _scaffoldKey.currentState?.closeDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.chatbot,
        arguments: args,
      );
    });
  }

  Future<void> _send() async {
    if (!mounted) return;
    final cubit = context.read<ChatbotCubit>();
    if (cubit.state.isSending) return;
    final trimmed = _text.text.trim();
    if (trimmed.isEmpty) return;
    _text.clear();
    await cubit.sendUserMessage(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final appBar = ChatbotGlassAppBar(
      sessionTitle: widget.routeArgs.sessionTitle,
      onBack: () => Navigator.of(context).maybePop(),
      onOpenHistory: () => _scaffoldKey.currentState?.openDrawer(),
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.neutral50,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      onDrawerChanged: (opened) {
        if (opened && mounted) {
          context.read<SessionsCubit>().load(refresh: true);
        }
      },
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        width: ChatbotScreenDimensions.drawerWidth(context),
        child: HistoryPanel(
          onClose: () => _scaffoldKey.currentState?.closeDrawer(),
          onNavigateToChat: _navigateFromHistory,
        ),
      ),
      appBar: appBar,
      body: BlocConsumer<ChatbotCubit, ChatbotState>(
        listenWhen: (p, c) =>
            p.bannerMessage != c.bannerMessage ||
            p.messages.length != c.messages.length,
        listener: (context, state) {
          final banner = state.bannerMessage;
          if (banner != null && banner.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(banner)),
            );
            context.read<ChatbotCubit>().clearBanner();
          }
          if (state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state.phase == ChatbotSessionPhase.initializing &&
              state.loadError == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.loadError != null && state.sessionId == null) {
            return ChatbotLoadErrorView(
              message: state.loadError!,
              onRetry: () => context.read<ChatbotCubit>().start(
                    routeSessionId: widget.routeArgs.sessionId,
                    routeSessionTitle: widget.routeArgs.sessionTitle,
                  ),
            );
          }

          return Column(
            children: [
              SizedBox(height: topInset + appBar.preferredSize.height),
              Expanded(
                child: Stack(
                  children: [
                    if (state.isLoadingHistory)
                      const LinearProgressIndicator(minHeight: 2),
                    ChatbotMessageListView(
                      scrollController: _scroll,
                      messages: state.messages,
                      isAssistantTyping: state.isAssistantTyping,
                    ),
                  ],
                ),
              ),
              if (state.pendingImagePath != null)
                ImagePreviewBar(
                  path: state.pendingImagePath!,
                  captionController: _caption,
                  onCancel: () {
                    _caption.clear();
                    context.read<ChatbotCubit>().cancelImagePreview();
                  },
                  onSend: () async {
                    await context.read<ChatbotCubit>().sendPendingImage(
                          caption: _caption.text,
                        );
                    _caption.clear();
                  },
                  isSending: state.isSending,
                ),
              ChatbotComposerBar(
                attachmentMenuAnchorKey: _attachmentMenuAnchorKey,
                textController: _text,
                isSending: state.isSending,
                onAttachmentTap: _openAttachmentMenu,
                onSendTap: _send,
              ),
            ],
          );
        },
      ),
    );
  }
}
