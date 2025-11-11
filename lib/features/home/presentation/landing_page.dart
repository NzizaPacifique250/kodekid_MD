import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/colored_text.dart';
import '../../../core/widgets/primary_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Top Section with Logo
                _buildTopSection(context),
                
                // Hero Section
                _buildHeroSection(context),
                
                // Computer Illustration Section
                _buildComputerSection(context),
                
                // Lower Section with Headline
                _buildLowerSection(context),
              ],
            ),
          ),
          // Union decorative image in top right corner
          Positioned(
            top: -30,
            right: -30,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  'assets/images/Union.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          // Logo image
          SvgPicture.asset(
            'assets/images/logo kidkoder.svg',
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/logo kidkoder.svg',
                height: 50,
                fit: BoxFit.contain,
              );
            },
          ),
          const Spacer(),
          // Navigation items can be added here
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Text content
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline with colored text
                ColoredText(
                  segments: [
                    TextSegment('DIVE INTO THE ', AppColors.orange),
                    TextSegment('GREATNESS OF ', AppColors.darkGrey),
                    TextSegment('LEARNING ', AppColors.limeGreen),
                    TextSegment('PYTHON.', AppColors.lightBlue),
                  ],
                  baseStyle: AppTextStyles.heroHeadline(fontSize: 28),
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'Online educational platform for digital skills where students aged between 6-17 makes their dreams come true by designing real projects',
                  style: AppTextStyles.bodyText(fontSize: 16),
                ),
                const SizedBox(height: 32),
                // Get Started Button
                PrimaryButton(
                  text: 'Get Started',
                  backgroundColor: AppColors.orange,
                  onPressed: () {
                    // Handle navigation
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          // Right side - Child image with decorative elements
          Expanded(
            flex: 1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Decorative element (light blue flower/star shape)
                Positioned(
                  left: -30,
                  top: 40,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Child image
                Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/child.png',
                      width: double.infinity,
                      height: 450,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 450,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 50,
                              color: AppColors.lightGrey,
                            ),
                          ),
                        );
                      },
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

  Widget _buildComputerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: SizedBox(
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Background decorative elements (faint geometric shapes)
            Positioned(
              left: -50,
              bottom: 0,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: 20,
              child: Opacity(
                opacity: 0.08,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Orange decorative element
            Positioned(
              left: 20,
              top: 0,
              child: Opacity(
                opacity: 0.15,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Computer illustration - centered
            Center(
              child: Image.asset(
                'assets/images/computer.png',
                width: 350,
                height: 280,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 350,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 50,
                        color: AppColors.lightGrey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          // Headline
          ColoredText(
            segments: [
              TextSegment('QUICKLY ', AppColors.darkGrey),
              TextSegment('MASTER ', AppColors.yellow),
              TextSegment('PYTHON ', AppColors.lightBlue),
              TextSegment('CONCEPTS', AppColors.orange),
            ],
            baseStyle: AppTextStyles.sectionHeadline(fontSize: 36),
          ),
          const SizedBox(height: 24),
          // Description
          Text(
            'A platform for digital skills where students make their dreams come true.',
            style: AppTextStyles.bodyText(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Explore Courses Button
          PrimaryButton(
            text: 'Explore coursers',
            backgroundColor: AppColors.lightBlue,
            onPressed: () {
              // Handle navigation
            },
          ),
          const SizedBox(height: 40),
          // Yesterday kids tomorrow creators image
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Image.asset(
                  'assets/images/yesterday kids tomorrow creators.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Yesterday's kids tomorrow's creators",
                        style: AppTextStyles.taglineText(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

 

 
}

