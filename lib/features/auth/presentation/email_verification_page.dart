import 'package:flutter/material.dart';
import 'dart:async';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../data/auth_service.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isLoading = false;
  bool _canResendEmail = true;
  Timer? _timer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _startEmailVerificationCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await AuthService.reloadUser();
      if (AuthService.isEmailVerified) {
        timer.cancel();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        }
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResendEmail) return;

    setState(() {
      _isLoading = true;
    });

    final success = await AuthService.sendEmailVerification();

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _startResendCountdown();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Verification email sent!',
              style: AppTextStyles.bodyText(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send verification email. Please try again.',
              style: AppTextStyles.bodyText(),
            ),
            backgroundColor: AppColors.orange,
          ),
        );
      }
    }
  }

  void _startResendCountdown() {
    setState(() {
      _canResendEmail = false;
      _resendCountdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResendEmail = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo
                  const Center(
                    child: KodeKidLogo(),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Email verification icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      size: 60,
                      color: AppColors.orange,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Title
                  Text(
                    'VERIFY YOUR EMAIL',
                    style: AppTextStyles.sectionHeadline(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    'We\'ve sent a verification email to:',
                    style: AppTextStyles.bodyText(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    AuthService.currentUserEmail ?? '',
                    style: AppTextStyles.bodyText(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ).copyWith(color: AppColors.orange),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Please check your email and click the verification link to continue.',
                    style: AppTextStyles.bodyText(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Resend email button
                  PrimaryButton(
                    text: _isLoading
                        ? 'SENDING...'
                        : _canResendEmail 
                            ? 'RESEND EMAIL' 
                            : 'RESEND IN ${_resendCountdown}s',
                    backgroundColor: _canResendEmail && !_isLoading
                        ? AppColors.orange 
                        : AppColors.lightGrey,
                    onPressed: _canResendEmail && !_isLoading 
                        ? _resendVerificationEmail 
                        : null,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Manual check button
                  TextButton(
                    onPressed: _checkVerificationManually,
                    child: Text(
                      'I\'ve verified my email - Check now',
                      style: AppTextStyles.bodyText(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ).copyWith(
                        color: AppColors.orange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Back to login
                  TextButton(
                    onPressed: () async {
                      await AuthService.logout();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                    child: Text(
                      'Back to Login',
                      style: AppTextStyles.bodyText(
                        fontWeight: FontWeight.bold,
                      ).copyWith(
                        color: AppColors.orange,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Decorative elements
          Positioned(
            top: -50,
            right: -50,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _checkVerificationManually() async {
    try {
      await AuthService.reloadUser();
      if (AuthService.isEmailVerified) {
        _timer?.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email verified successfully! Welcome to KodeKid!',
                style: AppTextStyles.bodyText(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.dashboard,
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email not yet verified. Please check your email and click the verification link.',
                style: AppTextStyles.bodyText(),
              ),
              backgroundColor: AppColors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error checking verification status. Please try again.',
              style: AppTextStyles.bodyText(),
            ),
            backgroundColor: AppColors.orange,
          ),
        );
      }
    }
  }
}