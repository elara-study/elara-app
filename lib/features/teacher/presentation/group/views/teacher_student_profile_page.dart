import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/entities/teacher_group_entity.dart';
import 'package:elara/features/teacher/domain/group/entities/teacher_student_entity.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_student_insights_usecase.dart';
import 'package:elara/features/teacher/domain/group/usecases/get_teacher_student_profile_usecase.dart';
import 'package:elara/features/teacher/presentation/group/cubits/teacher_student_profile_cubit.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_student_profile_route_args.dart';
import 'package:elara/features/teacher/presentation/group/views/teacher_student_profile_screen.dart';
import 'package:elara/features/teacher/presentation/group/widgets/add_insight_options_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherStudentProfilePage extends StatelessWidget {
  const TeacherStudentProfilePage({
    super.key,
    required this.group,
    required this.student,
  });

  factory TeacherStudentProfilePage.fromArgs(
    TeacherStudentProfileRouteArgs args,
  ) {
    return TeacherStudentProfilePage(
      key: ValueKey('student-profile-${args.student.rank}'),
      group: args.group,
      student: args.student,
    );
  }

  final TeacherGroupEntity group;
  final TeacherStudentEntity student;

  static String _formatThousands(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = TeacherStudentProfileCubit(
          getProfile: getIt<GetTeacherStudentProfileUseCase>(),
          getInsights: getIt<GetTeacherStudentInsightsUseCase>(),
        );
        cubit.loadProfile(groupId: group.id, studentRank: student.rank);
        return cubit;
      },
      child:
          BlocBuilder<TeacherStudentProfileCubit, TeacherStudentProfileState>(
            builder: (context, state) {
              return switch (state) {
                TeacherStudentProfileInitial() ||
                TeacherStudentProfileLoading() => TeacherStudentProfileScreen(
                  handle: '@…',
                  studentName: student.name,
                  groupTitle: group.subject,
                  body: const Center(child: CircularProgressIndicator()),
                ),
                TeacherStudentProfileError(:final message) =>
                  TeacherStudentProfileScreen(
                    handle: '@…',
                    studentName: student.name,
                    groupTitle: group.subject,
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                        child: Text(
                          message,
                          style: AppTypography.bodyMedium(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                TeacherStudentProfileLoaded(:final profile) =>
                  TeacherStudentProfileScreen(
                    handle: profile.handle,
                    studentName: profile.student.name,
                    groupTitle: group.subject,
                    body: TeacherStudentProfileBody(
                      profile: profile,
                      formatThousands: _formatThousands,
                      onAddInsight: () => showAddInsightOptionsSheet(
                        context,
                        studentName: profile.student.name,
                      ),
                    ),
                  ),
              };
            },
          ),
    );
  }
}
