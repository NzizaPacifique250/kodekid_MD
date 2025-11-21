import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';

class CourseService {
  static final CollectionReference _col =
      FirebaseFirestore.instance.collection('courses');

  /// Adds a new course to Firestore and returns the generated document id.
  static Future<String> addCourse(Course course) async {
    final data = course.toMap();
    final docRef = await _col.add(data);
    return docRef.id;
  }

  /// Returns all courses in the `courses` collection.
  static Future<List<Course>> getCourses() async {
    // Order by `order` then `chapter` in ascending order for consistent
    // ordering across reads.
    final snap = await _col.orderBy('chapter').get();
    return snap.docs
        .map((d) => Course.fromMap(d.data() as Map<String, dynamic>, id: d.id))
        .toList();
  }

  /// Get a single course by id.
  static Future<Course?> getCourse(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return Course.fromMap(doc.data()! as Map<String, dynamic>, id: doc.id);
  }

  /// Update an existing course. Course must have `id` set.
  static Future<void> updateCourse(Course course) async {
    if (course.id == null) throw Exception('Course id is null');
    await _col.doc(course.id).update(course.toMap());
  }

  /// Delete a course by id.
  static Future<void> deleteCourse(String id) async {
    await _col.doc(id).delete();
  }

  /// Append an exercise to the course's `exercises` array.
  static Future<void> addExercise(
      String courseId, Map<String, dynamic> exercise) async {
    await _col.doc(courseId).update({
      'exercises': FieldValue.arrayUnion([exercise])
    });
  }

  /// Append a goal string to the course's `goals` array.
  static Future<void> addGoal(String courseId, String goal) async {
    await _col.doc(courseId).update({
      'goals': FieldValue.arrayUnion([goal])
    });
  }

  /// Append a topic string to the course's `topics` array.
  static Future<void> addTopic(String courseId, String topic) async {
    await _col.doc(courseId).update({
      'topics': FieldValue.arrayUnion([topic])
    });
  }

  /// Set a course document with a specific id (useful when you created a doc in console and want to overwrite from app).
  static Future<void> setCourseWithId(String id, Course course) async {
    await _col.doc(id).set(course.toMap());
  }

  /// Stream all courses in real-time as a list of [Course].
  static Stream<List<Course>> streamCourses() {
    // Apply the same ordering to the stream so the list remains consistent
    // when documents change.
    return _col.orderBy('chapter').snapshots().map((snap) => snap.docs
        .map((d) => Course.fromMap(d.data() as Map<String, dynamic>, id: d.id))
        .toList());
  }
}
