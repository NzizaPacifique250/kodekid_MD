class Course {
  final String? id;
  final String title;
  final String? courseCard; // URL or storage path
  final String description;
  final String? videoLink;
  final List<String> goals;
  final List<String> topics;
  final List<Map<String, dynamic>> exercises;
  final List<Map<String, dynamic>> activities;
  final int chapter;

  Course({
    this.id,
    required this.title,
    this.courseCard,
    required this.description,
    this.videoLink,
    List<String>? goals,
    List<String>? topics,
    List<Map<String, dynamic>>? exercises,
    List<Map<String, dynamic>>? activities,
    this.chapter = 1,
  })  : goals = goals ?? [],
        topics = topics ?? [],
        exercises = exercises ?? [],
        activities = activities ?? [];

  Course copyWith({
    String? id,
    String? title,
    String? courseCard,
    String? description,
    String? videoLink,
    List<String>? goals,
    List<String>? topics,
    List<Map<String, dynamic>>? exercises,
    List<Map<String, dynamic>>? activities,
    int? chapter,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      courseCard: courseCard ?? this.courseCard,
      description: description ?? this.description,
      videoLink: videoLink ?? this.videoLink,
      goals: goals ?? List.from(this.goals),
      topics: topics ?? List.from(this.topics),
      exercises: exercises ?? List.from(this.exercises),
      activities: activities ?? List.from(this.activities),
      chapter: chapter ?? this.chapter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'course_card': courseCard,
      'description': description,
      'video_link': videoLink,
      'goals': goals,
      'topics': topics,
      'exercises': exercises,
      'activities': activities,
      'chapter': chapter,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, {String? id}) {
    return Course(
      id: id,
      title: map['title'] as String? ?? '',
      courseCard: map['course_card'] as String?,
      description: map['description'] as String? ?? '',
      videoLink: map['video_link'] as String?,
      goals:
          (map['goals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
      topics: (map['topics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      exercises: (map['exercises'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      activities: (map['activities'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      chapter: (map['chapter'] is int)
          ? map['chapter'] as int
          : int.tryParse(map['chapter']?.toString() ?? '1') ?? 1,
    );
  }

  String displayOverview() {
    final goalsText = goals.isNotEmpty ? goals.join(', ') : 'No goals provided';
    return '$title\n\n$description\nGoals: $goalsText';
  }

  void addExercise(Map<String, dynamic> exercise) {
    exercises.add(exercise);
  }

  void addGoal(String goal) {
    goals.add(goal);
  }

  String getVideo() {
    return 'Watch the course video here: ${videoLink ?? 'no video link'}';
  }
}
