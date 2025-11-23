import '../domain/lesson_model.dart';
import '../../../core/services/course_service.dart';

class LessonsData {
  static Future<LessonModel?> getLessonById(int id) async {
    return await CourseService.getLessonById(id);
  }

  static Future<List<LessonModel>> getLessonsByCourse(String courseId) async {
    return await CourseService.getLessonsByCourse(courseId);
  }

  // Fallback sample lesson for testing
  static LessonModel getSampleLesson() {
    return LessonModel(
      id: 1,
      chapterNumber: 'CHAPTER 1',
      chapterTitle: 'INTRODUCTION TO PYTHON & PRINT STATEMENT',
      videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
      hasGeeksterLogo: true,
      description:
          "In this lesson you'll learn how to use strings in Python! Strings are words or sentences written inside quotes, and they are used to display messages, names, and more.",
      learningObjectives: [
        'Understand what strings are in Python',
        'Learn how to use quotes to create strings',
        'Use print() to display string messages',
      ],
      topicsCovered: [
        'What are Strings',
        'Using quotes (single and double)',
        'The print() function with strings',
        'Basic string errors to avoid',
      ],
      activities: [
        'Print your full name using a string',
        'Write a sentence about your best friend',
        'Print this sentence: "I love learning with KodeKid"',
      ],
      expectedOutput: 'Hello, World!',
    );
  }
}

