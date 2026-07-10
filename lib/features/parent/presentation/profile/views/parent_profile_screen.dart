import 'package:elara/core/navigation/app_navigation.dart';
import 'package:elara/config/routes.dart';
import 'package:elara/core/utils/app_snackbar.dart';
import 'package:elara/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:elara/features/auth/presentation/cubits/auth_state.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_cubit.dart';
import 'package:elara/features/parent/presentation/profile/cubits/parent_profile_state.dart';
import 'package:elara/features/parent/presentation/profile/widgets/parent_profile_overview_body.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentProfileCubit, ParentProfileState>(
      listenWhen: (previous, current) =>
          current.pendingSnackMessage != null || current.shouldNavigateToLogin,
      listener: (context, profileState) {
        if (profileState.shouldNavigateToLogin) {
          AppNavigation.pushNamedAndRemoveUntil(context, AppRoutes.login);
        }
        final snack = profileState.pendingSnackMessage;
        if (snack != null) {
          AppSnackBar.info(context, snack);
          context.read<ParentProfileCubit>().clearSnackMessage();
        }
      },
      builder: (context, profileState) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final user = authState is AuthAuthenticated ? authState.user : null;
            // Generate a handle from the name if none exists (fallback logic)
            final handle = user != null
                ? '@${user.fullName.split(' ').first.toLowerCase()}'
                : '@parent';

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
                      AppRoutes.parentSettings,
                    ),
                  ),
                ],
              ),
              body: profileState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : profileState.errorMessage != null
                      ? Center(child: Text(profileState.errorMessage!))
                      : profileState.profileData != null
                          ? ParentProfileOverviewBody(
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
