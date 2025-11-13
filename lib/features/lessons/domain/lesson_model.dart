class LessonModel {
  final int id;
  final String chapterTitle;
  final String chapterNumber;
  final String videoUrl;
  final bool hasGeeksterLogo;
  final String description;
  final List<String> learningObjectives;
  final List<String> topicsCovered;
  final List<String> activities;
  final String expectedOutput;

  LessonModel({
    required this.id,
    required this.chapterTitle,
    required this.chapterNumber,
    required this.videoUrl,
    this.hasGeeksterLogo = false,
    required this.description,
    required this.learningObjectives,
    required this.topicsCovered,
    required this.activities,
    required this.expectedOutput,
  });
}

