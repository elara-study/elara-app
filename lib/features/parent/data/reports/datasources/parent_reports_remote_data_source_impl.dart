import 'package:elara/features/parent/data/reports/datasources/parent_reports_remote_data_source.dart';
import 'package:elara/features/parent/data/reports/models/parent_insight_model.dart';
import 'package:elara/features/parent/data/reports/models/parent_reports_overview_model.dart';

/// Mock remote parent Reports API — Figma (1467:10103).
class ParentReportsRemoteDataSourceImpl
    implements ParentReportsRemoteDataSource {
  const ParentReportsRemoteDataSourceImpl();

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
  Future<ParentReportsOverviewModel> fetchReportsOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    return const ParentReportsOverviewModel(
      insights: [
        ParentInsightModel(
          id: 'insight-1',
          childName: 'Tyler',
          dateLabel: '5 min ago',
          reportParagraph1: _p1Tyler,
          reportParagraph2: _p2,
        ),
        ParentInsightModel(
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
