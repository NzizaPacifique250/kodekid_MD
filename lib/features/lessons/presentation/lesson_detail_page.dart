import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/services/progress_service.dart';
import '../../../routes/app_routes.dart';
import '../../auth/data/auth_service.dart';
import '../../home/data/courses_data.dart';
import '../domain/lesson_model.dart';
import '../data/lessons_data.dart';
import '../../../core/services/course_service.dart';
import '../../../core/models/course.dart' as core;
import '../../../core/services/user_progress_service.dart';
import '../../../core/providers/user_progress_provider.dart';
import '../../../core/services/firebase_service.dart';
import 'widgets/code_editor_widget.dart';

class LessonDetailPage extends ConsumerStatefulWidget {
  final int? lessonId;
  final String? courseId;

  const LessonDetailPage({
    super.key,
    this.lessonId,
    this.courseId,
  });

  @override
  ConsumerState<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends ConsumerState<LessonDetailPage> {
  late LessonModel lesson;
  // completion state is derived from `completedCoursesProvider` so no local flag
  String currentCode = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    // If a Firestore courseId was provided, fetch that course and map it
    // to the LessonModel used by this page. Otherwise, fall back to
    // the local LessonsData by numeric lessonId.
    if (widget.courseId != null) {
      try {
        final course = await CourseService.getCourse(widget.courseId!);
        if (course != null) {
          lesson = _mapCourseToLesson(course);
        } else {
          // If not found, fall back to a default lesson or show empty
          lesson = LessonsData.getLessonById(widget.lessonId ?? 1);
        }
      } catch (_) {
        lesson = LessonsData.getLessonById(widget.lessonId ?? 1);
      }
    } else {
      lesson = LessonsData.getLessonById(widget.lessonId ?? 1);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    // completion state is handled reactively by Riverpod provider
  }

  LessonModel _mapCourseToLesson(core.Course course) {
    // Map the core Course model to the LessonModel structure used by the UI.
    final activities = course.activities
        .map((e) => (e['text'] ?? e['value'] ?? e.toString()).toString())
        .toList();
    return LessonModel(
      id: course.chapter,
      chapterTitle: course.title,
      chapterNumber: course.chapter.toString(),
      videoUrl: course.videoLink ?? '',
      hasGeeksterLogo: false,
      description: course.description,
      learningObjectives: course.goals,
      topicsCovered: course.topics,
      activities: activities,
      expectedOutput: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Logo and Chapter Title
            _buildHeader(),

            // Video Section
            _buildVideoSection(),

            const SizedBox(height: 24),

            // Lesson Description
            _buildDescription(),

            const SizedBox(height: 32),

            // What you'll Learn Section
            _buildLearningObjectives(),

            const SizedBox(height: 32),

            // Topics Covered Section
            _buildTopicsCovered(),

            const SizedBox(height: 32),

            // Time to Practice Section
            _buildPracticeSection(),

            const SizedBox(height: 32),

            // Activities Section
            _buildActivities(),

            const SizedBox(height: 32),

            // Instructions Section
            _buildInstructions(),

            const SizedBox(height: 32),

            // Code Editor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CodeEditorWidget(
                onCodeChanged: (code) {
                  setState(() {
                    currentCode = code;
                  });
                },
              ),
            ),

            const SizedBox(height: 40),

            // Mark as Completed
            _buildMarkAsCompleted(ref),

            const SizedBox(height: 40),

            // Previous/Next Navigation
            _buildNavigationButtons(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Logo
          const KodeKidLogo(),
          const SizedBox(height: 24),
          // Chapter Title
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.bodyText(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '${lesson.chapterNumber}: ',
                  style: const TextStyle(color: AppColors.darkGrey),
                ),
                // Split title and highlight PYTHON
                ..._buildChapterTitleSpans(lesson.chapterTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkGreen,
                  AppColors.darkGreenLight,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Geekster logo (if applicable)
                if (lesson.hasGeeksterLogo)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'G Geekster',
                        style: AppTextStyles.bodyText(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ).copyWith(color: AppColors.darkGrey),
                      ),
                    ),
                  ),
                // Title text
                const Positioned(
                  left: 20,
                  top: 60,
                  child: Text(
                    'Introduction to Python',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Python logo placeholder (top right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.code,
                      color: AppColors.yellow,
                      size: 28,
                    ),
                  ),
                ),
                // Play button (center)
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_filled,
                      color: AppColors.white,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        lesson.description,
        style: AppTextStyles.bodyText(),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildLearningObjectives() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What you'll Learn",
            style: AppTextStyles.bodyText(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 16),
          ...lesson.learningObjectives.map((objective) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        objective,
                        style: AppTextStyles.bodyText(),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopicsCovered() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Topics Covered',
            style: AppTextStyles.bodyText(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 16),
          ...lesson.topicsCovered.map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '+ ',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        topic,
                        style: AppTextStyles.bodyText(),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPracticeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIME TO PRACTICE!',
            style: AppTextStyles.bodyText(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's get our hands dirty!",
            style: AppTextStyles.bodyText(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activities',
            style: AppTextStyles.bodyText(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 16),
          ...lesson.activities.map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '> ',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        activity,
                        style: AppTextStyles.bodyText(),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions:',
            style: AppTextStyles.bodyText(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.darkGreen),
          ),
          const SizedBox(height: 16),
          _buildInstructionItem('1. Write your code below in the "Kode Board"'),
          _buildInstructionItem('2. Check if you made no errors :)'),
          _buildInstructionItem('3. Click the round green "Run" button'),
          _buildInstructionItem(
              '4. You should see your expected output on the "Output Board"'),
          _buildInstructionItem(
              '5. If it fails and you don\'t see anything - don\'t worry :) just go back to step 1 and try again'),
          const SizedBox(height: 16),
          Text(
            'Good Luck!!!!',
            style: AppTextStyles.bodyText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.darkGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkAsCompleted(WidgetRef ref) {
    if (widget.courseId == null) return const SizedBox.shrink();

    final completedAsync = ref.watch(completedCoursesProvider);

    return Center(
      child: completedAsync.when(
        data: (completed) {
          final isCompleted = completed.contains(widget.courseId);
          return ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isCompleted ? AppColors.darkGreen : AppColors.white,
              foregroundColor:
                  isCompleted ? AppColors.white : AppColors.darkGreen,
              side: const BorderSide(color: AppColors.darkGreen, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              final uid = FirebaseService.auth.currentUser?.uid;
              if (uid == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign in to track progress')),
                );
                return;
              }

              try {
                if (isCompleted) {
                  await UserProgressService.unmarkCourseCompleted(
                      uid, widget.courseId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marked as not completed')),
                  );
                } else {
                  await UserProgressService.markCourseCompleted(
                      uid, widget.courseId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Marked as completed')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating progress: $e')),
                );
              }
            },
            icon: Icon(isCompleted ? Icons.check_circle : Icons.check),
            label: Text(isCompleted ? 'Completed' : 'Mark as completed'),
          );
        },
        loading: () => ElevatedButton(
          onPressed: null,
          child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (_, __) => ElevatedButton(
          onPressed: null,
          child: const Text('Error'),
        ),
      ),
    );
  }

  List<TextSpan> _buildChapterTitleSpans(String title) {
    List<TextSpan> spans = [];
    String upperTitle = title.toUpperCase();
    int pythonIndex = upperTitle.indexOf('PYTHON');

    if (pythonIndex != -1) {
      // Text before PYTHON
      if (pythonIndex > 0) {
        spans.add(TextSpan(
          text: title.substring(0, pythonIndex),
          style: const TextStyle(color: AppColors.darkGrey),
        ));
      }
      // PYTHON highlighted
      spans.add(TextSpan(
        text: title.substring(pythonIndex, pythonIndex + 6),
        style: const TextStyle(color: AppColors.lightBlue),
      ));
      // Text after PYTHON
      if (pythonIndex + 6 < title.length) {
        spans.add(TextSpan(
          text: title.substring(pythonIndex + 6),
          style: const TextStyle(color: AppColors.darkGrey),
        ));
      }
    } else {
      // If PYTHON not found, just return the whole title
      spans.add(TextSpan(
        text: title,
        style: const TextStyle(color: AppColors.darkGrey),
      ));
    }

    return spans;
  }

  Widget _buildNavigationButtons() {
    final courses = CoursesData.getCourses();
    final currentIndex =
        courses.indexWhere((course) => course.id == widget.lessonId);
    final hasPrevious = currentIndex > 0;
    final hasNext = currentIndex < courses.length - 1 && currentIndex >= 0;

    if (!hasPrevious && !hasNext) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous Button
          if (hasPrevious)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToLesson(
                  context,
                  courses[currentIndex - 1].id,
                ),
                icon: const Icon(Icons.arrow_back, size: 20),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),

          if (hasPrevious && hasNext) const SizedBox(width: 16),

          // Next Button
          if (hasNext)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToLesson(
                  context,
                  courses[currentIndex + 1].id,
                ),
                icon: const Icon(Icons.arrow_forward, size: 20),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.oliveGreen,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  void _navigateToLesson(BuildContext context, int lessonId) {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.lessonDetail,
      arguments: {'lessonId': lessonId},
    );
  }
}
