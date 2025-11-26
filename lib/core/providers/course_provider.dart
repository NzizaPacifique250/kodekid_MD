import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/course_service.dart';
import '../models/course.dart';

/// StreamProvider that exposes the list of courses as a global reactive state.
final coursesStreamProvider = StreamProvider<List<Course>>((ref) {
  return CourseService.streamCourses();
});

/// A convenience FutureProvider that reads the current snapshot once.
final coursesOnceProvider = FutureProvider<List<Course>>((ref) async {
  return CourseService.getCourses();
});
