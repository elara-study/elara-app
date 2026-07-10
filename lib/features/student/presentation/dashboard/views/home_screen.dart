import 'package:elara/config/app_router.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/core/theme/app_radius.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/tab/student_tab_cubit.dart';
import 'package:elara/core/theme/app_colors.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/student/domain/dashboard/entities/student_group_entity.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/home/student_home_cubit.dart';
import 'package:elara/features/student/presentation/dashboard/cubits/home/student_home_state.dart';
import 'package:elara/features/student/presentation/dashboard/widgets/home/continue_learning_card.dart';
import 'package:elara/features/student/presentation/dashboard/widgets/home/daily_goal_item.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_cubit.dart';
import 'package:elara/features/student/presentation/rewards/cubits/rewards_state.dart';
import 'package:elara/shared/widgets/app_action_card.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:elara/shared/widgets/app_refresh_indicator.dart';
import 'package:elara/shared/widgets/app_section_header.dart';
import 'package:elara/core/localization/localization_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/utils/ui_helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  RewardsState? _displayedRewardsState;
  RewardsState? _pendingRewardsState;
  bool _isRouteActive = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    _isRouteActive = false;
  }

  @override
  void didPopNext() {
    _isRouteActive = true;
    if (_pendingRewardsState != null) {
      setState(() {
        _displayedRewardsState = _pendingRewardsState;
        _pendingRewardsState = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RewardsCubit, RewardsState>(
      listener: (context, rewardsState) {
        if (_isRouteActive) {
          setState(() {
            _displayedRewardsState = rewardsState;
            _pendingRewardsState = null;
          });
        } else {
          _pendingRewardsState = rewardsState;
        }
      },
      child: BlocBuilder<RewardsCubit, RewardsState>(
        builder: (context, rawRewardsState) {
          _displayedRewardsState ??= rawRewardsState;
          final currentRewards = _displayedRewardsState;

          return BlocBuilder<StudentHomeCubit, StudentHomeState>(
            builder: (context, state) {
              if (state is StudentHomeLoading || state is StudentHomeInitial) {
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: const Center(child: CircularProgressIndicator()),
                );
              }
              if (state is StudentHomeError) {
                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  body: _ErrorView(
                    message: state.message,
                    onRetry: () => context.read<StudentHomeCubit>().loadHome(),
                  ),
                );
              }
              if (state is StudentHomeLoaded) {
                final int streakDays = currentRewards is RewardsLoaded
                    ? currentRewards.profile.streakDays
                    : 7;
                final int totalXp = currentRewards is RewardsLoaded
                    ? currentRewards.profile.totalXp
                    : state.profile.points;

                return Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  extendBodyBehindAppBar: true,
                  appBar: AppGlassHeader(
                    title: context.l10n.appName.toLowerCase(),
                    actions: [
                      _HeaderChip(
                        iconAsset: 'assets/icons/fire_icon.svg',
                        value: streakDays,
                        color: AppColors.brandSecondary500,
                      ),
                      SizedBox(width: AppSpacing.spacingSm.w),
                      _HeaderChip(
                        iconAsset: 'assets/icons/rewards_icon.svg',
                        value: totalXp,
                        color: AppColors.brandPrimary500,
                      ),
                      SizedBox(width: AppSpacing.spacingLg.w),
                    ],
                  ),
                  body: _HomeContent(
                    state: state,
                    rewardsState: currentRewards,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}

// ── Loaded content

class _HomeContent extends StatelessWidget {
  final StudentHomeLoaded state;
  final RewardsState? rewardsState;

  const _HomeContent({required this.state, this.rewardsState});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final previewGroups = state.groups.take(2).toList();

    final hasRewards = rewardsState is RewardsLoaded;
    final dailyGoals = hasRewards
        ? (rewardsState as RewardsLoaded).dailyGoals
        : state.dailyGoals;
    final completedGoalsCount =
        dailyGoals.where((g) => g.isCompleted).length;

    return AppRefreshIndicator(
      onRefresh: () async {
        context.read<StudentHomeCubit>().loadHome();
      },
      child: SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.spacingLg.w,
        right: AppSpacing.spacingLg.w,
        top: kToolbarHeight + 62.h,
        bottom: 120.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: AppSpacing.spacingXl.h),
          Text(
            '${UiHelpers.getGreeting(context)}, ${state.profile.firstName}!',
            style: AppTypography.h3(
              color: cs.onSurface,
            ).copyWith(fontWeight: AppTypography.black, fontSize: 25.sp),
          ),

          SizedBox(height: AppSpacing.spacing2xs.h),

          Text(
            context.l10n.homeReadyToContinue,
            style: AppTypography.bodyLarge(color: cs.onSurfaceVariant),
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          ContinueLearningCard(
            progress: state.continuelearning,
            onTap: () {
              //  Navigate to lesson
            },
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          // ── Daily Goals ──────────────────────────────────────────────────
          AppSectionHeader(
            title: context.l10n.homeDailyGoals,
            seeAllLabel:
                context.l10n.homeComplete(completedGoalsCount, dailyGoals.length),
          ),

          SizedBox(height: AppSpacing.spacingLg.h),

          // All goals inside one white card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.spacingLg.w),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < dailyGoals.length; i++) ...[
                  DailyGoalItem(
                    goal: dailyGoals[i],
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: AppSpacing.spacing2xl.h),

          // ── My Groups ────────────────────────────────────────────────────
          AppSectionHeader(
            title: context.l10n.homeMyGroups,
            onSeeAll: () => context.read<StudentTabCubit>().goToLearn(),
          ),

          SizedBox(height: AppSpacing.spacingMd.h),

          ...previewGroups.map(
            (group) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spacingMd.h),
              child: AppActionCard(
                title: group.name,
                subtitle: context.l10n.homeGroupProgress((group.progressPercent * 100).round()),
                icon: _iconForGroup(group),
                primaryColor: UiHelpers.getGroupPrimaryColor(group.colorKey),
                secondaryColor: UiHelpers.getGroupSecondaryColor(
                  group.colorKey,
                ),
                onTap: () {
                  AppNavigation.pushNamed(
                    context,
                    AppRoutes.studentGroup,
                    arguments: group.id,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: AppSpacing.spacingSm.h),
        ],
      ),
      ),
    );
  }

  IconData _iconForGroup(StudentGroupEntity group) {
    switch (group.subject.toLowerCase()) {
      case 'mathematics':
        return Icons.calculate_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'english':
        return Icons.menu_book_outlined;
      default:
        return Icons.groups_outlined;
    }
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48.sp,
              color: AppColors.neutral300,
            ),
            SizedBox(height: AppSpacing.spacingLg.h),
            Text(
              message,
              style: AppTypography.bodyMedium(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.spacingXl.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                context.l10n.commonTryAgain,
                style: AppTypography.button(color: AppColors.brandPrimary500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderChip extends StatefulWidget {
  final String iconAsset;
  final int value;
  final Color color;

  const _HeaderChip({
    required this.iconAsset,
    required this.value,
    required this.color,
  });

  @override
  State<_HeaderChip> createState() => _HeaderChipState();
}

class _HeaderChipState extends State<_HeaderChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  int _oldValue = 0;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = IntTween(begin: _oldValue, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(_HeaderChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
      _animation = IntTween(begin: _oldValue, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMd.w,
        vertical: AppSpacing.spacingSm.h,
      ),
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            widget.iconAsset,
            width: 10.w,
            height: 13.w,
            colorFilter: ColorFilter.mode(widget.color, BlendMode.srcIn),
          ),
          SizedBox(width: AppSpacing.spacingXs.w),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                '${_animation.value}',
                style: AppTypography.labelRegular(color: widget.color),
              );
            },
          ),
        ],
      ),
    );
  }
}
