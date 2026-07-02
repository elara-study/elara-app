import 'package:elara/features/student/learn/data/models/student_learn_group_model.dart';

abstract class StudentLearnRemoteDataSource {
  Future<List<StudentLearnGroupModel>> getGroups();

  Future<void> joinGroup(String code);
}