import 'package:elara/features/student/learn/data/models/student_group_model.dart';

abstract class LearnRemoteDataSource {
  Future<List<StudentGroupModel>> getGroups();
}
