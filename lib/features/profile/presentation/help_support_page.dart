import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: AppTextStyles.bodyText(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpSection(
            'Frequently Asked Questions',
            [
              _buildFAQItem(
                'How do I start a new lesson?',
                'Navigate to the Dashboard and select any available lesson to begin learning.',
              ),
              _buildFAQItem(
                'Can I track my progress?',
                'Yes! Your progress is automatically saved and can be viewed on your Dashboard.',
              ),
              _buildFAQItem(
                'How do I reset my password?',
                'Go to Settings > Change Password to update your account password.',
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildHelpSection(
            'Contact Support',
            [
              _buildContactTile(
                'Email Support',
                'Send us an email for detailed assistance',
                Icons.email_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email client...')),
                  );
                },
              ),
              _buildContactTile(
                'Live Chat',
                'Chat with our support team in real-time',
                Icons.chat_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Live chat feature coming soon!')),
                  );
                },
              ),
              _buildContactTile(
                'Report a Bug',
                'Help us improve by reporting issues',
                Icons.bug_report_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bug report feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildHelpSection(
            'Resources',
            [
              _buildResourceTile(
                'User Guide',
                'Complete guide to using KodeKid',
                Icons.book_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User guide feature coming soon!')),
                  );
                },
              ),
              _buildResourceTile(
                'Video Tutorials',
                'Watch tutorials to get started quickly',
                Icons.play_circle_outline,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Video tutorials feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          // App Version Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'KodeKid',
                  style: AppTextStyles.bodyText(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: AppTextStyles.bodyText(
                    fontSize: 14,
                  ).copyWith(color: AppColors.darkGrey.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyText(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: AppTextStyles.bodyText(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: AppTextStyles.bodyText(
              fontSize: 14,
            ).copyWith(color: AppColors.darkGrey.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.lightBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyText(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyText(
                          fontSize: 14,
                        ).copyWith(color: AppColors.darkGrey.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.lightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResourceTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return _buildContactTile(title, subtitle, icon, onTap);
  }
}