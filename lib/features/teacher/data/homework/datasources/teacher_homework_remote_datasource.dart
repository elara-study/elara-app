import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/features/teacher/data/homework/datasources/mock_teacher_homework_datasource.dart';
import 'package:elara/features/teacher/data/homework/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_problem_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_rated_student_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_resource_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_answer_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_submission_model.dart';

class TeacherHomeworkRemoteDatasource implements TeacherHomeworkDatasource {
  TeacherHomeworkRemoteDatasource(this._dio);

  final Dio _dio;
  final MockTeacherHomeworkDatasource _mockResources =
      MockTeacherHomeworkDatasource();

  @override
  Future<TeacherHomeworkModel> getModuleHomework({
    required String moduleId,
    required String groupId,
  }) async {
    final response = await _dio.get(
      ApiConstants.teacherModuleHomework(moduleId),
    );
    final payload = _unwrapRoot(response.data);

    final module = _readMap(payload, const ['module']) ?? payload;
    final problemsRaw = _readList(payload, const [
      'problems',
      'homeworkProblems',
      'questions',
      'problemList',
    ]);
    final submissionsRaw = _readList(payload, const [
      'submissions',
      'studentSubmissions',
    ]);
    final ratedRaw = _readList(payload, const [
      'ratedStudents',
      'gradedStudents',
      'rated',
    ]);

    final problems = problemsRaw
        .asMap()
        .entries
        .map((entry) => _toProblem(entry.value, entry.key))
        .toList();

    final submissions = submissionsRaw
        .map((item) => _toSubmission(item, problems.length))
        .toList();

    final ratedStudents = ratedRaw
        .map(
          (item) => _toRatedStudent(
            item,
            _int(payload, ['totalXp', 'totalXP', 'maxXp', 'maxXP']),
          ),
        )
        .toList();

    return TeacherHomeworkModel(
      moduleId: _string(module, const ['id'], fallback: moduleId),
      moduleTitle: _string(module, const ['title', 'name', 'moduleTitle']),
      moduleLabel: _string(module, const [
        'label',
        'moduleLabel',
      ], fallback: _string(payload, const ['moduleLabel'], fallback: 'MODULE')),
      groupId: _string(payload, const ['groupId'], fallback: groupId),
      subject: _string(payload, const ['subject', 'courseSubject']),
      totalXp: _int(payload, const ['totalXp', 'totalXP', 'maxXp', 'maxXP']),
      problems: problems,
      submissions: submissions,
      ratedStudents: ratedStudents,
    );
  }

  @override
  Future<List<TeacherResourceModel>> getModuleResources({
    required String moduleId,
    required String groupId,
  }) {
    // This task integrates only the homework endpoint.
    // Keep current resources behavior until its API is provided.
    return _mockResources.getModuleResources(
      moduleId: moduleId,
      groupId: groupId,
    );
  }

  Map<String, dynamic> _unwrapRoot(dynamic value) {
    final root = value is Map<String, dynamic> ? value : <String, dynamic>{};
    final data = root['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return root;
  }

  Map<String, dynamic>? _readMap(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = source[key];
      if (value is Map<String, dynamic>) {
        return value;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _readList(
    Map<String, dynamic> source,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = source[key];
      if (value is List) {
        return value.whereType<Map<String, dynamic>>().toList();
      }
    }
    return const [];
  }

  TeacherHomeworkProblemModel _toProblem(Map<String, dynamic> json, int index) {
    final sampleAnswerText = _string(json, const [
      'sampleAnswerText',
      'sampleAnswer',
      'answerPreview',
    ]);

    final hasImage = _bool(json, const [
      'hasImageSubmission',
      'hasImage',
      'containsImageAnswer',
    ]);

    return TeacherHomeworkProblemModel(
      id: _string(json, const ['id'], fallback: 'problem_${index + 1}'),
      problemNumber: _int(json, const [
        'problemNumber',
        'number',
        'order',
      ], fallback: index + 1),
      questionText: _string(json, const [
        'questionText',
        'question',
        'title',
        'prompt',
      ]),
      sampleAnswerText: sampleAnswerText.isEmpty ? null : sampleAnswerText,
      hasImageSubmission: hasImage,
    );
  }

  TeacherStudentSubmissionModel _toSubmission(
    Map<String, dynamic> json,
    int totalProblems,
  ) {
    final answersRaw = _readList(json, const ['answers', 'submissions']);
    final answers = answersRaw
        .asMap()
        .entries
        .map((entry) => _toAnswer(entry.value, entry.key))
        .toList();

    final student = _readMap(json, const ['student']) ?? json;

    return TeacherStudentSubmissionModel(
      id: _string(json, const ['id'], fallback: _string(student, const ['id'])),
      studentName: _string(student, const [
        'name',
        'fullName',
        'username',
      ], fallback: _string(json, const ['studentName'])),
      avatarUrl: _nullable(
        _string(student, const ['avatarUrl', 'avatar', 'imageUrl']),
      ),
      submittedCount: _int(json, const [
        'submittedCount',
        'submittedAnswersCount',
      ], fallback: answers.length),
      totalProblems: _int(json, const [
        'totalProblems',
        'problemsCount',
      ], fallback: totalProblems),
      answers: answers,
    );
  }

  TeacherStudentAnswerModel _toAnswer(Map<String, dynamic> json, int index) {
    final answerText = _string(json, const [
      'answerText',
      'textAnswer',
      'answer',
    ]);

    return TeacherStudentAnswerModel(
      answerNumber: _int(json, const [
        'answerNumber',
        'number',
        'order',
      ], fallback: index + 1),
      questionText: _string(json, const ['questionText', 'question', 'prompt']),
      answerText: _nullable(answerText),
      imageUrl: _nullable(
        _string(json, const ['imageUrl', 'image', 'photoUrl']),
      ),
      score: _nullableInt(_int(json, const ['score', 'grade'], fallback: -1)),
      maxScore: _int(json, const [
        'maxScore',
        'maximumScore',
        'points',
      ], fallback: 0),
    );
  }

  TeacherRatedStudentModel _toRatedStudent(
    Map<String, dynamic> json,
    int fallbackMaxXp,
  ) {
    final student = _readMap(json, const ['student']) ?? json;

    return TeacherRatedStudentModel(
      id: _string(json, const ['id'], fallback: _string(student, const ['id'])),
      studentName: _string(student, const [
        'name',
        'fullName',
        'username',
      ], fallback: _string(json, const ['studentName'])),
      avatarUrl: _nullable(
        _string(student, const ['avatarUrl', 'avatar', 'imageUrl']),
      ),
      totalXp: _int(json, const ['totalXp', 'xp', 'score']),
      maxXp: _int(json, const [
        'maxXp',
        'totalMaxXp',
        'maxScore',
      ], fallback: fallbackMaxXp),
    );
  }

  String _string(
    Map<String, dynamic> json,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        final asString = value.toString().trim();
        if (asString.isNotEmpty) {
          return asString;
        }
      }
    }
    return fallback;
  }

  int _int(Map<String, dynamic> json, List<String> keys, {int fallback = 0}) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return fallback;
  }

  bool _bool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        if (value.toLowerCase() == 'true') {
          return true;
        }
        if (value.toLowerCase() == 'false') {
          return false;
        }
      }
      if (value is num) {
        return value != 0;
      }
    }
    return false;
  }

  String? _nullable(String value) => value.isEmpty ? null : value;

  int? _nullableInt(int value) => value < 0 ? null : value;
}
