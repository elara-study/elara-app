import 'package:dio/dio.dart';
import 'package:elara/core/constants/api_constants.dart';
import 'package:elara/features/teacher/data/homework/datasources/teacher_homework_datasource.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_homework_problem_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_rated_student_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_resource_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_answer_model.dart';
import 'package:elara/features/teacher/data/homework/models/teacher_student_submission_model.dart';
import 'package:elara/features/teacher/domain/homework/entities/teacher_resource_entity.dart';

class TeacherHomeworkRemoteDatasource implements TeacherHomeworkDatasource {
  TeacherHomeworkRemoteDatasource(this._dio);

  final Dio _dio;

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
    final problemsRaw = _extractProblemMaps(payload);
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
            _int(payload, [
              'totalScoreXp',
              'totalXp',
              'totalXP',
              'maxXp',
              'maxXP',
            ]),
          ),
        )
        .toList();

    return TeacherHomeworkModel(
      moduleId: _string(module, const ['id'], fallback: moduleId),
      moduleTitle: _string(module, const [
        'moduleName',
        'title',
        'name',
        'moduleTitle',
      ]),
      moduleLabel: _string(module, const [
        'label',
        'moduleLabel',
      ], fallback: _string(payload, const ['moduleLabel'], fallback: 'MODULE')),
      groupId: _string(payload, const ['groupId'], fallback: groupId),
      subject: _string(payload, const ['subject', 'courseSubject']),
      totalXp: _int(payload, const [
        'totalScoreXp',
        'totalXp',
        'totalXP',
        'maxXp',
        'maxXP',
      ]),
      problems: problems,
      submissions: submissions,
      ratedStudents: ratedStudents,
    );
  }

  @override
  Future<TeacherHomeworkProblemModel> addModuleProblem({
    required String moduleId,
    required String description,
  }) async {
    final response = await _dio.post(
      ApiConstants.teacherModuleHomeworkProblems(moduleId),
      data: {'description': description},
    );

    final payload = _unwrapRoot(response.data);
    final json = _readMap(payload, const ['problem']) ?? payload;

    return TeacherHomeworkProblemModel(
      id: _problemId(
        json,
        fallback: '${DateTime.now().millisecondsSinceEpoch}',
      ),
      problemNumber: _int(json, const ['problemNumber', 'number', 'order']),
      questionText: _string(json, const [
        'description',
        'questionText',
        'question',
        'text',
      ], fallback: description),
      sampleAnswerText: _nullable(
        _string(json, const ['sampleAnswerText', 'sampleAnswer']),
      ),
      hasImageSubmission: _bool(json, const [
        'hasImageSubmission',
        'hasImage',
        'containsImageAnswer',
      ]),
    );
  }

  @override
  Future<TeacherHomeworkProblemModel> updateProblem({
    required String problemId,
    required String description,
  }) async {
    final response = await _dio.patch(
      ApiConstants.teacherProblem(problemId),
      data: {'description': description},
    );

    final payload = _unwrapRoot(response.data);
    final json = _readMap(payload, const ['problem']) ?? payload;

    return TeacherHomeworkProblemModel(
      id: _string(json, const ['id'], fallback: problemId),
      problemNumber: _int(json, const ['problemNumber', 'number', 'order']),
      questionText: _string(json, const [
        'description',
        'questionText',
        'question',
        'text',
      ], fallback: description),
      sampleAnswerText: _nullable(
        _string(json, const ['sampleAnswerText', 'sampleAnswer']),
      ),
      hasImageSubmission: _bool(json, const [
        'hasImageSubmission',
        'hasImage',
        'containsImageAnswer',
      ]),
    );
  }

  @override
  Future<void> deleteProblem({required String problemId}) async {
    await _dio.delete(ApiConstants.teacherProblem(problemId));
  }

  @override
  Future<List<TeacherResourceModel>> getModuleResources({
    required String moduleId,
    required String groupId,
  }) async {
    final response = await _dio.get(
      ApiConstants.teacherModuleResources(moduleId),
    );
    final payload = _unwrapRoot(response.data);
    final resourceEntries = _extractResourceEntries(payload);

    return resourceEntries
        .asMap()
        .entries
        .map(
          (entry) =>
              _toResource(entry.value.$1, entry.key, hint: entry.value.$2),
        )
        .toList();
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
      final maps = _asListOfMaps(source[key]);
      if (maps.isNotEmpty) {
        return maps;
      }
    }
    return const [];
  }

  List<Map<String, dynamic>> _extractProblemMaps(Map<String, dynamic> payload) {
    final direct = _readList(payload, const [
      'problems',
      'homeworkProblems',
      'questions',
      'problemList',
      'items',
    ]);
    if (direct.isNotEmpty) {
      return direct;
    }

    final nestedContainers = <Map<String, dynamic>>[
      ...['homework', 'overview', 'homeworkOverview', 'assignment']
          .map((key) => _readMap(payload, [key]))
          .whereType<Map<String, dynamic>>(),
    ];

    for (final container in nestedContainers) {
      final nested = _readList(container, const [
        'problems',
        'homeworkProblems',
        'questions',
        'problemList',
        'items',
      ]);
      if (nested.isNotEmpty) {
        return nested;
      }
    }

    return const [];
  }

  List<Map<String, dynamic>> _asListOfMaps(dynamic value) {
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }

    if (value is Map<String, dynamic>) {
      final nestedList = value['items'] ?? value['data'] ?? value['problems'];
      if (nestedList is List) {
        return nestedList.whereType<Map<String, dynamic>>().toList();
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
      id: _problemId(json, fallback: '${index + 1}'),
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
        'text',
        'description',
        'problemText',
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

  List<(Map<String, dynamic>, TeacherResourceType?)> _extractResourceEntries(
    Map<String, dynamic> payload,
  ) {
    final typed = <(Map<String, dynamic>, TeacherResourceType?)>[];

    void addTyped(String key, TeacherResourceType type) {
      final list = _readList(payload, [key]);
      for (final item in list) {
        typed.add((item, type));
      }
    }

    addTyped('videos', TeacherResourceType.video);
    addTyped('pdfs', TeacherResourceType.pdf);
    addTyped('images', TeacherResourceType.image);
    addTyped('links', TeacherResourceType.link);
    addTyped('documents', TeacherResourceType.document);

    if (typed.isNotEmpty) {
      return typed;
    }

    final direct = _readList(payload, const [
      'resources',
      'items',
      'assets',
      'moduleResources',
    ]);
    if (direct.isNotEmpty) {
      return direct.map((item) => (item, null)).toList();
    }

    final nestedContainers = <Map<String, dynamic>>[
      ...['resources', 'module', 'overview', 'data']
          .map((key) => _readMap(payload, [key]))
          .whereType<Map<String, dynamic>>(),
    ];

    for (final container in nestedContainers) {
      final nestedTyped = _extractResourceEntries(container);
      if (nestedTyped.isNotEmpty) {
        return nestedTyped;
      }
    }

    return const [];
  }

  TeacherResourceModel _toResource(
    Map<String, dynamic> json,
    int index, {
    TeacherResourceType? hint,
  }) {
    final url = _string(json, const ['url', 'link', 'resourceUrl', 'fileUrl']);
    final fileName = _string(json, const [
      'fileName',
      'filename',
      'name',
    ], fallback: '');

    final type = hint ?? _resourceType(json, url: url, fileName: fileName);

    return TeacherResourceModel(
      id: _string(json, const ['id', 'resourceId'], fallback: '${index + 1}'),
      title: _string(json, const [
        'title',
        'name',
      ], fallback: fileName.isEmpty ? 'Untitled resource' : fileName),
      description: _string(json, const ['description', 'summary']),
      type: type,
      url: url,
      addedAtLabel: _string(json, const [
        'addedAtLabel',
        'createdAtLabel',
        'createdAt',
        'updatedAt',
      ], fallback: 'Recently added'),
      duration: _nullable(_string(json, const ['duration', 'videoDuration'])),
      fileSize: _nullable(_string(json, const ['fileSize', 'size'])),
      fileName: _nullable(fileName),
    );
  }

  TeacherResourceType _resourceType(
    Map<String, dynamic> json, {
    required String url,
    required String fileName,
  }) {
    final rawType = _string(json, const [
      'type',
      'resourceType',
      'kind',
      'mimeType',
    ]).toLowerCase();

    if (rawType.contains('video')) {
      return TeacherResourceType.video;
    }
    if (rawType.contains('pdf')) {
      return TeacherResourceType.pdf;
    }
    if (rawType.contains('image')) {
      return TeacherResourceType.image;
    }
    if (rawType.contains('link') || rawType.contains('url')) {
      return TeacherResourceType.link;
    }
    if (rawType.contains('doc')) {
      return TeacherResourceType.document;
    }

    final source = '${url.toLowerCase()} ${fileName.toLowerCase()}';
    if (source.contains('.mp4') ||
        source.contains('.mov') ||
        source.contains('.webm')) {
      return TeacherResourceType.video;
    }
    if (source.contains('.pdf')) {
      return TeacherResourceType.pdf;
    }
    if (source.contains('.png') ||
        source.contains('.jpg') ||
        source.contains('.jpeg') ||
        source.contains('.gif') ||
        source.contains('.webp')) {
      return TeacherResourceType.image;
    }
    if (source.contains('.doc') ||
        source.contains('.docx') ||
        source.contains('.ppt') ||
        source.contains('.pptx') ||
        source.contains('.xls') ||
        source.contains('.xlsx') ||
        source.contains('.txt')) {
      return TeacherResourceType.document;
    }
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return TeacherResourceType.link;
    }

    return TeacherResourceType.document;
  }

  String _problemId(Map<String, dynamic> json, {required String fallback}) {
    return _string(json, const [
      'id',
      'problemId',
      'homeworkProblemId',
    ], fallback: fallback);
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
