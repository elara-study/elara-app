import 'package:equatable/equatable.dart';

enum TeacherResourceType { pdf, video, link, image, document }

extension TeacherResourceTypeLabel on TeacherResourceType {
  String get label => switch (this) {
    TeacherResourceType.pdf => 'PDF',
    TeacherResourceType.video => 'Video',
    TeacherResourceType.link => 'Link',
    TeacherResourceType.image => 'Image',
    TeacherResourceType.document => 'Document',
  };

  String get sectionTitle => switch (this) {
    TeacherResourceType.pdf => 'PDF Guides',
    TeacherResourceType.video => 'Video Tutorials',
    TeacherResourceType.link => 'Useful Links',
    TeacherResourceType.image => 'Image Assets',
    TeacherResourceType.document => 'Documents',
  };
}

/// A learning resource attached to a module by the teacher.
class TeacherResourceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final TeacherResourceType type;
  final String url;
  final String addedAtLabel;

  /// Video duration displayed under the title (e.g. "12:45"). Null for other types.
  final String? duration;

  /// File size displayed under the title (e.g. "1.2 MB"). Used for pdf/image/document.
  final String? fileSize;

  /// Filename used as the label in image grid cells (e.g. "Palette_01.jpg").
  final String? fileName;

  const TeacherResourceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.url,
    required this.addedAtLabel,
    this.duration,
    this.fileSize,
    this.fileName,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    url,
    addedAtLabel,
    duration,
    fileSize,
    fileName,
  ];
}
