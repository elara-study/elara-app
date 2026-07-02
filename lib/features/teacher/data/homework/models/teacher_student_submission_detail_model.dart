import 'package:elara/features/teacher/domain/homework/entities/teacher_student_submission_detail_entity.dart';

class TeacherStudentAnswerDetailModel extends TeacherStudentAnswerDetailEntity {
  const TeacherStudentAnswerDetailModel({
    required super.problemId,
    required super.problemText,
    super.studentTextAnswer,
    super.studentImageUrl,
  });

  factory TeacherStudentAnswerDetailModel.fromJson(Map<String, dynamic> json) {
    String? str(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v != null) {
          final s = v.toString().trim();
          if (s.isNotEmpty && s != 'null') return s;
        }
      }
      return null;
    }

    int intVal(List<String> keys) {
      for (final k in keys) {
        final v = json[k];
        if (v is int) return v;
        if (v is num) return v.toInt();
        if (v is String) return int.tryParse(v) ?? 0;
      }
      return 0;
    }

    return TeacherStudentAnswerDetailModel(
      problemId: intVal(const ['problemId', 'id', 'number']),
      problemText: str(const [
            'problemText',
            'questionText',
            'question',
            'title',
            'description',
          ]) ??
          'Unknown Question',
      studentTextAnswer: str(const [
        'studentTextAnswer',
        'textAnswer',
        'answerText',
        'answer',
      ]),
      studentImageUrl: str(const [
        'studentImageUrl',
        'imageUrl',
        'image',
        'photoUrl',
      ]),
    );
  }
}

class TeacherStudentSubmissionDetailModel
    extends TeacherStudentSubmissionDetailEntity {
  const TeacherStudentSubmissionDetailModel({
    required super.studentName,
    required super.answers,
  });

  factory TeacherStudentSubmissionDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // Unwrap envelope { status, message, data: { ... } }
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawAnswers = data['answers'];
    final answers = <TeacherStudentAnswerDetailModel>[];
    if (rawAnswers is List) {
      for (final item in rawAnswers) {
        if (item is Map<String, dynamic>) {
          answers.add(TeacherStudentAnswerDetailModel.fromJson(item));
        }
      }
    }

    String str(Map<String, dynamic> src, List<String> keys) {
      for (final k in keys) {
        final v = src[k];
        if (v != null) {
          final s = v.toString().trim();
          if (s.isNotEmpty) return s;
        }
      }
      return '';
    }

    return TeacherStudentSubmissionDetailModel(
      studentName: str(data, const ['studentName', 'name', 'fullName']),
      answers: answers,
    );
  }
}
