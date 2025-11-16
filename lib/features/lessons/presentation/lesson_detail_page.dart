import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/widgets/youtube_player_widget.dart';
import '../../../core/providers/lesson_provider.dart';
import '../../../routes/app_routes.dart';
import '../../home/data/courses_data.dart';
import '../domain/lesson_model.dart';
import '../data/lessons_data.dart';
import 'widgets/code_editor_widget.dart';

class LessonDetailPage extends ConsumerStatefulWidget {
  final int lessonId;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends ConsumerState<LessonDetailPage> {
  LessonModel? lesson;
  String currentCode = '';

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final loadedLesson = await LessonsData.getLessonById(widget.lessonId);
    if (mounted) {
      setState(() {
        lesson = loadedLesson ?? LessonsData.getSampleLesson();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lesson == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progressAsync = ref.watch(lessonProgressProvider(widget.lessonId));
    final isCompleted = progressAsync.value?['completed'] ?? false;

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
                lessonId: widget.lessonId,
                onCodeChanged: (code) {
                  setState(() {
                    currentCode = code;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Mark as Completed
            _buildMarkAsCompleted(),
            
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
      child: lesson!.videoUrl.isNotEmpty
          ? YouTubePlayerWidget(videoUrl: lesson!.videoUrl)
          : Container(
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
              child: const Center(
                child: Text(
                  'Video Coming Soon',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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

  Widget _buildMarkAsCompleted() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          await ref.read(lessonProgressProvider(widget.lessonId).notifier)
              .updateProgress(completed: !isCompleted, code: currentCode);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppColors.darkGreen
                : AppColors.darkGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.darkGreen,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: isCompleted
                    ? AppColors.white
                    : AppColors.darkGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Mark as completed ${isCompleted ? '✓' : ''}',
                style: AppTextStyles.bodyText(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ).copyWith(
                  color: isCompleted
                      ? AppColors.white
                      : AppColors.darkGreen,
                ),
              ),
            ],
          ),
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
    final currentIndex = courses.indexWhere((course) => course.id == widget.lessonId);
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

