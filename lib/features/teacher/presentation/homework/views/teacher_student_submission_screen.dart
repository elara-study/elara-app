import 'package:elara/config/dependency_injection.dart';
import 'package:elara/core/theme/app_spacing.dart';
import 'package:elara/core/theme/app_typography.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_detail_entity.dart';
import 'package:elara/features/teacher/domain/homework/usecases/get_teacher_student_submission_usecase.dart';
import 'package:elara/features/teacher/presentation/homework/route_args/teacher_student_submission_route_args.dart';
import 'package:elara/features/teacher/presentation/homework/widgets/teacher_answer_section.dart';
import 'package:elara/shared/widgets/app_glass_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen that displays a single student's submission details.
///
/// Fetches the submission directly via [GetTeacherStudentSubmissionUseCase]
/// and shows a scrollable list of answers with a score input row.
class TeacherStudentSubmissionScreen extends StatefulWidget {
  final String moduleId;
  final String studentId;
  final String studentName;
  final String groupId;
  final int totalXp;

  const TeacherStudentSubmissionScreen({
    super.key,
    required this.moduleId,
    required this.studentId,
    required this.studentName,
    required this.groupId,
    required this.totalXp,
  });

  factory TeacherStudentSubmissionScreen.fromArgs(
    TeacherStudentSubmissionRouteArgs args,
  ) =>
      TeacherStudentSubmissionScreen(
        moduleId: args.moduleId,
        studentId: args.studentId,
        studentName: args.studentName,
        groupId: args.groupId,
        totalXp: args.totalXp,
      );

  @override
  State<TeacherStudentSubmissionScreen> createState() =>
      _TeacherStudentSubmissionScreenState();
}

class _TeacherStudentSubmissionScreenState
    extends State<TeacherStudentSubmissionScreen> {
  late final TextEditingController _scoreCtrl;
  late final Future<TeacherStudentSubmissionDetailEntity?> _submissionFuture;

  @override
  void initState() {
    super.initState();
    _scoreCtrl = TextEditingController();
    _submissionFuture = _fetchSubmission();
  }

  Future<TeacherStudentSubmissionDetailEntity?> _fetchSubmission() async {
    final useCase = getIt<GetTeacherStudentSubmissionUseCase>();
    final result = await useCase(
      moduleId: widget.moduleId,
      studentId: widget.studentId,
      groupId: widget.groupId,
    );
    return result.fold(
      onSuccess: (detail) => detail,
      onFailure: (_) => null,
    );
  }

  @override
  void dispose() {
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppGlassHeader(
        title: widget.studentName,
        subtitle: 'Submission Details',
      ),
      body: FutureBuilder<TeacherStudentSubmissionDetailEntity?>(
        future: _submissionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final detail = snapshot.data;
          if (detail == null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.spacing2xl.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 48.sp,
                      color: cs.outline,
                    ),
                    SizedBox(height: AppSpacing.spacingLg.h),
                    Text(
                      'Failed to load submission details.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium(color: cs.onSurface),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.spacingLg.w,
                    AppSpacing.spacingLg.h,
                    AppSpacing.spacingLg.w,
                    AppSpacing.spacing5xl.h,
                  ),
                  itemCount: detail.answers.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: AppSpacing.spacingLg.h),
                  itemBuilder: (ctx, i) =>
                      TeacherAnswerDetailSection(answer: detail.answers[i]),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.spacingLg.w,
                  0,
                  AppSpacing.spacingLg.w,
                  AppSpacing.spacingLg.h,
                ),
                child: TeacherScoreInputRow(
                  ctrl: _scoreCtrl,
                  maxXp: widget.totalXp,
                  isGrading: true,
                  onSubmit: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
