class CourseModel {
  final int id;
  final String title;
  final String videoUrl;
  final bool hasGeeksterLogo;

  CourseModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    this.hasGeeksterLogo = false,
  });
}

