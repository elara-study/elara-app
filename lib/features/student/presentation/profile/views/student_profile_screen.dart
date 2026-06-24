import 'package:elara/config/routes.dart';
import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_profile_cubit.dart';
import 'package:elara/features/student/presentation/profile/cubits/student_profile_state.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_error_view.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_overview_body.dart';
import 'package:elara/features/student/presentation/profile/widgets/profile_signed_out_body.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Student profile tab — UI from Figma; data from [StudentProfileCubit]
/// → [GetStudentProfileOverviewUseCase] → [StudentProfileRepositoryImpl].
class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  static String _formatIntWithComma(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          appBar: AppGlassHeader(
            title: user != null ? user.fullName : 'Profile',
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                tooltip: 'Settings',
                onPressed: () =>
                    AppNavigation.pushNamed(context, AppRoutes.studentSettings),
              ),
            ],
          ),
          body: user == null
              ? const ProfileSignedOutBody()
              : BlocBuilder<StudentProfileCubit, StudentProfileState>(
                  builder: (context, profileState) {
                    return switch (profileState) {
                      StudentProfileInitial() || StudentProfileLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      StudentProfileError(:final message) => ProfileErrorView(
                        message: message,
                        onRetry: () =>
                            context.read<StudentProfileCubit>().loadProfile(),
                      ),
                      StudentProfileLoaded(:final overview) =>
                        ProfileOverviewBody(
                          user: user,
                          overview: overview,
                          formatThousands: _formatIntWithComma,
                        ),
                    };
                  },
                ),
        );
      },
    );
  }
}
