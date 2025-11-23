import 'firebase_service.dart';
import '../../features/lessons/domain/lesson_model.dart';

class CourseService {
  static const String _lessonsCollection = 'lessons';
  static const String _coursesCollection = 'courses';

  static Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    final snapshot = await FirebaseService.firestore
        .collection(_lessonsCollection)
        .where('courseId', isEqualTo: courseId)
        .orderBy('order')
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LessonModel(
        id: int.parse(doc.id),
        chapterNumber: data['chapterNumber'] ?? '',
        chapterTitle: data['chapterTitle'] ?? '',
        videoUrl: data['videoUrl'] ?? '',
        hasGeeksterLogo: data['hasGeeksterLogo'] ?? false,
        description: data['description'] ?? '',
        learningObjectives: List<String>.from(data['learningObjectives'] ?? []),
        topicsCovered: List<String>.from(data['topicsCovered'] ?? []),
        activities: List<String>.from(data['activities'] ?? []),
        expectedOutput: data['expectedOutput'] ?? '',
      );
    }).toList();
  }

  static Future<LessonModel?> getLessonById(int lessonId) async {
    final doc = await FirebaseService.getDocument(_lessonsCollection, lessonId.toString());
    if (doc == null) return null;
    
    return LessonModel(
      id: lessonId,
      chapterNumber: doc['chapterNumber'] ?? '',
      chapterTitle: doc['chapterTitle'] ?? '',
      videoUrl: doc['videoUrl'] ?? '',
      hasGeeksterLogo: doc['hasGeeksterLogo'] ?? false,
      description: doc['description'] ?? '',
      learningObjectives: List<String>.from(doc['learningObjectives'] ?? []),
      topicsCovered: List<String>.from(doc['topicsCovered'] ?? []),
      activities: List<String>.from(doc['activities'] ?? []),
      expectedOutput: doc['expectedOutput'] ?? '',
    );
  }

  static Future<List<Map<String, dynamic>>> getAllCourses() async {
    return await FirebaseService.getCollection(_coursesCollection);
  }
}