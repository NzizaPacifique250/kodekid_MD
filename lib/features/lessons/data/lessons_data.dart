import '../domain/lesson_model.dart';

class LessonsData {
  static LessonModel getLessonById(int id) {
    // For now, return a sample lesson. In production, this would fetch from a database
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
        'User print() to display string messages',
      ],
      topicsCovered: [
        'What are Strings',
        'Using quotes (single and double)',
        'THe print() function with strings',
        'Basic string errors to avoid',
      ],
      activities: [
        'print your full name using a string',
        'write a sentence about your best friend',
        'Print this sentence: "I love learning with KodeKid"',
      ],
      expectedOutput: '',
    );
  }
}

