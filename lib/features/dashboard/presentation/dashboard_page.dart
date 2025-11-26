import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/widgets/persistent_bottom_nav.dart';
import '../../../routes/app_routes.dart';
import '../data/dashboard_data.dart';
import '../domain/chapter_progress_model.dart';
import 'widgets/chapter_progress_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = DashboardData.getCurrentUserName();
    
    return FutureBuilder<List<ChapterProgressModel>>(
      future: DashboardData.getChapterProgress(),
      builder: (context, snapshot) {
        final chapters = snapshot.data ?? [];
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.white,
            body: Center(child: CircularProgressIndicator()),
            bottomNavigationBar: PersistentBottomNav(),
          );
        }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header with Logo
                _buildHeader(),
                
                const SizedBox(height: 20),
                
                // Greeting Section with Character
                _buildGreetingSection(userName),
                
                const SizedBox(height: 24),
                
                // Ready to Code Section
                _buildReadyToCodeSection(context),
                
                const SizedBox(height: 32),
                
                // Course Progress Section
                _buildCourseProgressSection(chapters, context),
                
                const SizedBox(height: 40),
                
                // Continue Coding Button
                _buildContinueCodingButton(context),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
          // Decorative background element (top right)
          Positioned(
            top: -30,
            right: -30,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const PersistentBottomNav(),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: const KodeKidLogo(),
    );
  }

  Widget _buildGreetingSection(String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Character Image (placeholder - replace with actual character asset)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.face,
              size: 50,
              color: AppColors.lightBlue,
            ),
          ),
          const SizedBox(width: 16),
          // Speech Bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.darkGrey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyText(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'HI ',
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.lightBlue,
                        decorationThickness: 3,
                      ),
                    ),
                    TextSpan(
                      text: userName.toUpperCase(),
                      style: const TextStyle(color: AppColors.darkGrey),
                    ),
                    const TextSpan(
                      text: '!',
                      style: TextStyle(color: AppColors.darkGrey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyToCodeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Question Text
          Expanded(
            child: Text(
              'READY TO CODE\nTODAY ?',
              style: AppTextStyles.bodyText(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // YES Button
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.courses);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'YES',
              style: AppTextStyles.buttonText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseProgressSection(
    List<ChapterProgressModel> chapters,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          RichText(
            text: TextSpan(
              style: AppTextStyles.bodyText(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(
                  text: "Here's your road to becoming a ",
                  style: TextStyle(color: AppColors.darkGrey),
                ),
                TextSpan(
                  text: 'Python Superstart',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.oliveGreen,
                    decorationThickness: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Chapter Progress Grid (2x2)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.9,
            ),
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              return ChapterProgressWidget(chapter: chapters[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContinueCodingButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.courses);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange.withOpacity(0.2),
            foregroundColor: AppColors.orange,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Continue coding',
            style: AppTextStyles.bodyText(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ).copyWith(color: AppColors.orange),
          ),
        ),
      ),
    );
  }
}

