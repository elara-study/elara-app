enum UserRole {
  student,
  teacher,
  parent;

  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.parent:
        return 'Parent';
    }
  }

  String get subtitle {
    switch (this) {
      case UserRole.student:
        return 'Join as a student';
      case UserRole.teacher:
        return 'Join as a teacher';
      case UserRole.parent:
        return 'Join as a parent';
    }
  }

  String get value {
    return name; // 'student' | 'teacher' | 'parent'
  }
}
