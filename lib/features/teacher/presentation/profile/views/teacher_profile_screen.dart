import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/profile/cubits/teacher_profile_state.dart';
import 'package:elara/features/teacher/presentation/profile/widgets/teacher_profile_overview_body.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherProfileCubit, TeacherProfileState>(
      listenWhen: (previous, current) => current.pendingSnackMessage != null,
      listener: (context, profileState) {
        final snack = profileState.pendingSnackMessage;
        if (snack != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
          context.read<TeacherProfileCubit>().clearSnackMessage();
        }
      },
      builder: (context, profileState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final user = authState is AuthAuthenticated ? authState.user : null;
            final handle = user != null
                ? '@${user.fullName.split(' ').first.toLowerCase()}'
                : '@teacher';

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              extendBodyBehindAppBar: true,
              appBar: AppGlassHeader(
                title: handle,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () => AppNavigation.pushNamed(
                      context,
                      AppRoutes.teacherSettings,
                    ),
                  ),
                ],
              ),
              body: profileState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : profileState.errorMessage != null
                      ? Center(child: Text(profileState.errorMessage!))
                      : profileState.profileData != null
                          ? TeacherProfileOverviewBody(
                              user: user,
                              profileData: profileState.profileData!,
                            )
                          : const Center(child: Text('No profile data available.')),
            );
          },
        );
      },
    );
  }
}
