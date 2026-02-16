import 'package:get/get.dart';

/// Maps backend/dynamic strings from student performance data to translation keys.
/// Used in StudentDetailScreen for Essays and Analysis tabs.
class StudentDetailTranslations {
  StudentDetailTranslations._();

  static const Map<String, String> _textToKey = {
    // Criterion names
    'Thesis': 'studentDetail.criterionThesis',
    'Evidence': 'studentDetail.criterionEvidence',
    'Analysis': 'studentDetail.criterionAnalysis',
    'Grammar': 'studentDetail.criterionGrammar',
    // Essay titles
    'Impact of Technology': 'studentDetail.essayImpactOfTech',
    'Climate Change Essay': 'studentDetail.essayClimateChange',
    'Digital Privacy': 'studentDetail.essayDigitalPrivacy',
    // Rubric
    'Argumentative Essay Rubric': 'studentDetail.rubricArgumentative',
    // Performance metrics
    'Problem Solving': 'studentDetail.metricProblemSolving',
    'Evidence Use': 'studentDetail.metricEvidenceUse',
    'Critical Analysis': 'studentDetail.metricCriticalAnalysis',
    'Thesis Development': 'studentDetail.metricThesisDevelopment',
    'Time Management': 'studentDetail.metricTimeManagement',
    // Performance descriptions
    'Excellent analytical skills in quizzes': 'studentDetail.descExcellentAnalytical',
    'Strong use of sources in essays': 'studentDetail.descStrongSources',
    'Needs to develop deeper analytical thinking in essays': 'studentDetail.descNeedsDeeperThinking',
    'Thesis statements could be more focused': 'studentDetail.descThesisFocused',
    'Outstanding analytical and critical thinking skills': 'studentDetail.descOutstandingAnalytical',
    'Exceptional research and source integration': 'studentDetail.descExceptionalResearch',
    'Consistently strong thesis statements': 'studentDetail.descStrongThesis',
    'Takes longer on quizzes, could improve speed': 'studentDetail.descTimeManagement',
    // Feedback
    'Clear thesis but needs stronger argumentation': 'studentDetail.feedbackClearThesis',
    'Good use of sources but needs more depth': 'studentDetail.feedbackGoodSources',
    'Analysis could be more critical': 'studentDetail.feedbackAnalysisCritical',
    'Minor grammar issues': 'studentDetail.feedbackMinorGrammar',
    'Thesis needs more focus': 'studentDetail.feedbackThesisFocus',
    'Solid evidence provided': 'studentDetail.feedbackSolidEvidence',
    'Needs deeper analysis': 'studentDetail.feedbackNeedsDeeper',
    'Good grammar overall': 'studentDetail.feedbackGoodGrammar',
    'Strong thesis statement': 'studentDetail.feedbackStrongThesis',
    'Excellent use of sources': 'studentDetail.feedbackExcellentSources',
    'Good critical thinking': 'studentDetail.feedbackGoodCritical',
    'Minor punctuation issues': 'studentDetail.feedbackMinorPunctuation',
    'Excellent thesis statement': 'studentDetail.feedbackExcellentThesis',
    'Outstanding use of sources': 'studentDetail.feedbackOutstandingSources',
    'Deep critical analysis': 'studentDetail.feedbackDeepAnalysis',
    'Excellent writing quality': 'studentDetail.feedbackExcellentWriting',
    'Well-researched evidence': 'studentDetail.feedbackWellResearched',
    'Thoughtful analysis': 'studentDetail.feedbackThoughtfulAnalysis',
    'Polished writing': 'studentDetail.feedbackPolishedWriting',
    'Clear, focused thesis': 'studentDetail.feedbackClearFocused',
    'Comprehensive evidence': 'studentDetail.feedbackComprehensive',
    'Insightful analysis': 'studentDetail.feedbackInsightful',
    // Activity
    'graded': 'studentDetail.statusGraded',
    'submitted': 'studentDetail.statusSubmitted',
    'pending': 'studentDetail.statusPending',
    'quiz': 'studentDetail.typeQuiz',
    'essay': 'studentDetail.typeEssay',
    // Activity titles
    'Algebra Basics Quiz': 'studentDetail.activityAlgebraQuiz',
    'Impact of Technology Essay': 'studentDetail.activityImpactEssay',
    'Geometry Fundamentals': 'studentDetail.activityGeometry',
    'Calculus Quiz 1': 'studentDetail.quizCalculus',
    'Statistics Basics': 'studentDetail.quizStatistics',
    'Probability Quiz': 'studentDetail.quizProbability',
  };

  static String translate(String text) {
    final key = _textToKey[text.trim()];
    return key != null ? key.tr : text;
  }
}
