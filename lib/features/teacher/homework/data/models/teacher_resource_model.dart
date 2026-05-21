import 'package:elara/features/teacher/homework/domain/entities/teacher_resource_entity.dart';

class TeacherResourceModel extends TeacherResourceEntity {
  const TeacherResourceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.url,
    required super.addedAtLabel,
    super.duration,
    super.fileSize,
    super.fileName,
  });
}
