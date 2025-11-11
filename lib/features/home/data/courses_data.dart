import '../domain/course_model.dart';

class CoursesData {
  static List<CourseModel> getCourses() {
    return [
      CourseModel(
        id: 1,
        title: 'Introduction to Python & Print Statements',
        videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
        hasGeeksterLogo: false,
      ),
      CourseModel(
        id: 2,
        title: 'Variables and Data types',
        videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
        hasGeeksterLogo: true,
      ),
      CourseModel(
        id: 3,
        title: 'User Input',
        videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
        hasGeeksterLogo: true,
      ),
      CourseModel(
        id: 4,
        title: 'Introduction to Python & Print Statements',
        videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
        hasGeeksterLogo: false,
      ),
      CourseModel(
        id: 5,
        title: 'Introduction to Python & Print Statements',
        videoUrl: 'https://www.youtube.com/watch?v=g4xs_5rZdos',
        hasGeeksterLogo: true,
      ),
    ];
  }
}

