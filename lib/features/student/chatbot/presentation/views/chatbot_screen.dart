import 'dart:math' as math;

import 'package:elara/config/routes.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_shadows.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/chatbot/presentation/chatbot_route_args.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/sessions_cubit.dart';
import 'package:elara/features/student/chatbot/presentation/cubits/chatbot_state.dart';
import 'package:elara/features/student/chatbot/presentation/views/history_screen.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/attachment_menu.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/image_preview_sheet.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/message_tile.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/today_chip.dart';
import 'package:elara/features/student/chatbot/presentation/widgets/typing_indicator.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

const double containerHieght = 72;

const List<BoxShadow> innershadow = [
  BoxShadow(color: Color(0x04000000), offset: Offset(2, 2), blurRadius: 4),
];

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

  void _navigateFromHistory(ChatbotRouteArgs args) {
    _scaffoldKey.currentState?.closeDrawer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacementNamed(AppRoutes.chatbot, arguments: args);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final topInset = MediaQuery.paddingOf(context).top;
    final appBar = AppGlassHeader(
      height: containerHieght,
      title: 'elara',
      titleStyle: AppTypography.h5(
        font: 'Comfortaa',
        color: cs.onSurface,
      ).copyWith(fontWeight: FontWeight.w600),
      subtitle:
          widget.routeArgs.sessionTitle ?? 'Ask anything about your lessons',
      subtitleStyle: AppTypography.bodySmall(color: cs.onSurfaceVariant),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history_rounded),
          tooltip: 'Chat history',
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ],
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
        width: math.min(320.0, MediaQuery.sizeOf(context).width * 0.92),
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(banner)));
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
            return Padding(
              padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.loadError!,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(color: cs.error),
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    FilledButton(
                      onPressed: () => context.read<ChatbotCubit>().start(
                        routeSessionId: widget.routeArgs.sessionId,
                        routeSessionTitle: widget.routeArgs.sessionTitle,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
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
                    Builder(
                      builder: (context) {
                        final showTodayChip =
                            state.messages.isNotEmpty ||
                            state.isAssistantTyping;
                        final chipCount = showTodayChip ? 1 : 0;
                        final typingExtra = state.isAssistantTyping ? 1 : 0;
                        return ListView.builder(
                          controller: _scroll,
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.spacingLg.w,
                            AppSpacing.spacingMd.h,
                            AppSpacing.spacingLg.w,
                            AppSpacing.spacing6xl.h,
                          ),
                          itemCount:
                              chipCount + state.messages.length + typingExtra,
                          itemBuilder: (context, index) {
                            if (showTodayChip && index == 0) {
                              return const TodayChip();
                            }
                            final i = index - chipCount;
                            if (state.isAssistantTyping &&
                                i == state.messages.length) {
                              return const TypingIndicator();
                            }
                            return ChatbotMessageTile(
                              message: state.messages[i],
                            );
                          },
                        );
                      },
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
              SafeArea(
                top: false,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      boxShadow: AppShadows.dropShadow,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.spacingMd.w,
                      AppSpacing.spacingMd.h,
                      AppSpacing.spacingMd.w,
                      AppSpacing.spacingMd.h,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: innershadow,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          4.w,
                          AppSpacing.spacingXs.h,
                          AppSpacing.spacingSm.w,
                          AppSpacing.spacingXs.h,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              key: _attachmentMenuAnchorKey,
                              padding: EdgeInsets.only(left: 2.w),
                              icon: Icon(Icons.add_rounded, color: cs.primary),
                              onPressed: () async {
                                final source = await showAttachmentMenu(
                                  context: context,
                                  anchorKey: _attachmentMenuAnchorKey,
                                );
                                if (source != null && context.mounted) {
                                  await _pick(source);
                                }
                              },
                            ),
                            Expanded(
                              child: TextField(
                                controller: _text,
                                minLines: 1,
                                maxLines: 2,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'Type a message...',
                                  hintStyle: AppTypography.bodyMedium(
                                    color: cs.onSurfaceVariant,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(
                                    0,
                                    AppSpacing.spacingMd.h,
                                    AppSpacing.spacingSm.w,
                                    AppSpacing.spacingMd.h,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: Tooltip(
                                message: 'Voice input',
                                child: Icon(
                                  Icons.mic_rounded,
                                  color: ButtonColors.ghostText,
                                  size: 24.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.spacingLg.w),
                            SizedBox(
                              width: 40.sp,
                              height: 40.sp,
                              child: Material(
                                color: ButtonColors.ghostText,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: state.isSending
                                      ? null
                                      : () => _send(context),
                                  child: Center(
                                    child: state.isSending
                                        ? SizedBox(
                                            width: 22.w,
                                            height: 22.w,
                                            child:
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.white,
                                                ),
                                          )
                                        : Icon(
                                            Icons.send_rounded,
                                            color: Colors.white,
                                            size: 22.sp,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _send(BuildContext context) async {
    if (!mounted) return;
    final cubit = context.read<ChatbotCubit>();
    if (cubit.state.isSending) return;
    final trimmed = _text.text.trim();
    if (trimmed.isEmpty) return;
    _text.clear();
    await cubit.sendUserMessage(trimmed);
  }
}
