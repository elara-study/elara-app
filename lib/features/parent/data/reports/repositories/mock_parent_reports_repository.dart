import 'package:elara/features/parent/domain/reports/entities/parent_insight_entity.dart';
import 'package:elara/features/parent/domain/reports/entities/parent_reports_overview_entity.dart';
import 'package:elara/features/parent/domain/reports/repositories/parent_reports_repository.dart';

/// Mock aligned with Figma parent Reports (1467:10103).
class MockParentReportsRepository implements ParentReportsRepository {
  static const String _p1Tyler =
      'Tyler has shown exceptional growth in Quantum Mechanics '
      'this term. His ability to grasp complex theoretical concepts, '
      'particularly regarding ware-particle duality, is outstanding and '
      'frequently pushes classroom discussions to higher levels.';

  static const String _p2 =
      'However, we noticed a slight dip in his practical lab applications. '
      'While his mathematical foundations are strong, a renewed focus on '
      'consistent experiment documentation and safety protocol adherence '
      'could bridge the gap between his theoretical brilliance and '
      'practical execution. ';

  static const String _p1Drake =
      'Drake has shown exceptional growth in Quantum Mechanics this term. '
      'His ability to grasp complex theoretical concepts, particularly '
      'regarding ware-particle duality, is outstanding and frequently '
      'pushes classroom discussions to higher levels.';

  @override
  Future<ParentReportsOverviewEntity> getReportsOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const ParentReportsOverviewEntity(
      insights: [
        ParentInsightEntity(
          id: 'insight-1',
          childName: 'Tyler',
          dateLabel: '5 min ago',
          reportParagraph1: _p1Tyler,
          reportParagraph2: _p2,
        ),
        ParentInsightEntity(
          id: 'insight-2',
          childName: 'Drake',
          dateLabel: '1 hour ago',
          reportParagraph1: _p1Drake,
          reportParagraph2: _p2,
        ),
      ],
    );
  }
}
