import 'package:elara/features/student/learn/domain/entities/student_learn_group.dart';

abstract class StudentLearnRepository {
  Future<List<StudentLearnGroup>> getGroups();

  Future<void> joinGroup(String code);
}