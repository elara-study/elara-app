abstract class ParentProfileRemoteDataSource {
  Future<Map<String, dynamic>> getParentProfile();
}

class ParentProfileRemoteDataSourceImpl implements ParentProfileRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getParentProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock data based on the screenshot
    return {
      'phoneNumber': '+20 10 12345678',
      'averageCompletionPercentage': 87,
      'averageAttendancePercentage': 92,
    };
  }
}
