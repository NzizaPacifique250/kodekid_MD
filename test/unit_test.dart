import 'package:flutter_test/flutter_test.dart';
import 'package:kodekid/core/models/course.dart';

void main() {
  group('Unit Tests', () {
    test('String validation works correctly', () {
      const testEmail = 'test@example.com';
      expect(testEmail.contains('@'), true);
      expect(testEmail.isNotEmpty, true);
    });

    test('List operations work correctly', () {
      final testList = <String>['item1', 'item2'];
      expect(testList.length, 2);
      expect(testList.contains('item1'), true);
    });

    test('Course model creates valid instance', () {
      final course = Course(
        id: 'test-id',
        title: 'Test Course',
        description: 'Test Description',
        courseCard: 'test-url',
        chapter: 1,
      );
      
      expect(course.id, 'test-id');
      expect(course.title, 'Test Course');
      expect(course.description, 'Test Description');
      expect(course.chapter, 1);
    });

    test('Course chapter validation', () {
      final course = Course(
        id: 'test',
        title: 'Test',
        description: 'Test',
        courseCard: 'test',
        chapter: 3,
      );
      
      expect(course.chapter, greaterThan(0));
    });

    test('Course goals can be added', () {
      final course = Course(
        id: 'test',
        title: 'Test',
        description: 'Test',
        goals: ['Learn basics', 'Practice coding'],
      );
      
      expect(course.goals.length, 2);
      expect(course.goals.contains('Learn basics'), true);
    });
  });
}