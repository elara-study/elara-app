import 'package:elara/config/dependency_injection.dart';
import 'package:elara/features/student/quiz/presentation/cubits/quiz_cubit.dart';
import 'package:elara/features/student/quiz/presentation/quiz_route_args.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_load_error_view.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_results_body.dart';
import 'package:elara/features/student/quiz/presentation/widgets/quiz_session_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Quiz route: provides [QuizCubit], loads the session, and maps state to UI.
///
/// Step widgets live under `presentation/widgets/`.
class QuizFlowPage extends StatelessWidget {
  const QuizFlowPage({
    super.key,
    required this.quizId,
    this.groupId,
    this.moduleId,
  });

  final String quizId;
  final String? groupId;
  final String? moduleId;

  factory QuizFlowPage.fromArgs(QuizRouteArgs args) {
    return QuizFlowPage(
      quizId: args.quizId,
      groupId: args.groupId,
      moduleId: args.moduleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<QuizCubit>()
        ..loadSession(quizId: quizId, groupId: groupId, moduleId: moduleId),
      child: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          return switch (state.status) {
            QuizStatus.initial => const Scaffold(
                body: Center(child: SizedBox.shrink()),
              ),
            QuizStatus.loading => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            QuizStatus.failure => QuizLoadErrorView(
                message: state.message ?? 'Something went wrong',
                onRetry: () => context.read<QuizCubit>().retry(),
              ),
            QuizStatus.inProgress => QuizSessionBody(state: state),
            QuizStatus.submitting => QuizSessionBody(state: state),
            QuizStatus.completed => QuizResultsBody(state: state),
          };
        },
      ),
    );
  }
}
