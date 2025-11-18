import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../data/auth_service.dart';
import '../../../core/services/firebase_test.dart';
import '../../../test_signup.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _showDebugInfo = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Trim whitespace from inputs
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;
      final name = _nameController.text.trim();
      
      // Additional validation
      if (name.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Name must be at least 2 characters long.',
              style: AppTextStyles.bodyText(),
            ),
            backgroundColor: AppColors.orange,
          ),
        );
        return;
      }
      
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid email address.',
              style: AppTextStyles.bodyText(),
            ),
            backgroundColor: AppColors.orange,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final result = await AuthService.register(email, password, name);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (result['success']) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result['message'] ?? 'Account created! Check your email for verification.',
                  style: AppTextStyles.bodyText(),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            
            // Navigate to email verification page if needed
            if (result['needsVerification'] == true) {
              Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
            }
          } else {
            // Check if it's an existing account error
            if (result['message']?.contains('already exists') == true) {
              _showExistingAccountDialog(email, password);
            } else {
              // Show specific error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result['message'] ?? 'Registration failed. Please try again.',
                    style: AppTextStyles.bodyText(),
                  ),
                  backgroundColor: AppColors.orange,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Network error. Please check your connection and try again.',
                style: AppTextStyles.bodyText(),
              ),
              backgroundColor: AppColors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }
  
  Future<void> _testFirebase() async {
    final result = await FirebaseTest.testFirebaseConnection();
    final authResult = await FirebaseTest.testEmailPasswordAuth();
    
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Firebase Test Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Connection: ${result['success'] ? 'SUCCESS' : 'FAILED'}'),
              Text('Message: ${result['message']}'),
              const SizedBox(height: 8),
              Text('Auth Test: ${authResult['success'] ? 'SUCCESS' : 'FAILED'}'),
              Text('Auth Message: ${authResult['message']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  
  Future<void> _testSignup() async {
    await SignupTest.testSignup();
  }

  void _showExistingAccountDialog(String email, String password) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Account Already Exists',
          style: AppTextStyles.sectionHeadline(fontSize: 18),
        ),
        content: Text(
          'An account with this email already exists. Would you like to resend the verification email?',
          style: AppTextStyles.bodyText(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyText().copyWith(color: AppColors.darkGrey),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleExistingAccount(email, password);
            },
            child: Text(
              'Resend Email',
              style: AppTextStyles.bodyText().copyWith(color: AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleExistingAccount(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    final result = await AuthService.handleExistingAccount(email, password);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result['message'] ?? 'Operation completed.',
            style: AppTextStyles.bodyText(),
          ),
          backgroundColor: result['success'] ? Colors.green : AppColors.orange,
          duration: const Duration(seconds: 4),
        ),
      );

      if (result['success'] && result['needsVerification'] == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo
                    const Center(
                      child: KodeKidLogo(),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Welcome Text
                    Text(
                      'CREATE ACCOUNT',
                      style: AppTextStyles.sectionHeadline(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Join KodeKid and start your coding journey',
                      style: AppTextStyles.bodyText(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hint: 'Enter your name',
                      prefixIcon: Icons.person_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
                          return 'Name can only contain letters and spaces';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.darkGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                          return 'Password must contain at least one letter and one number';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Confirm Password Field
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icons.lock_outlined,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.darkGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Register Button
                    PrimaryButton(
                      text: _isLoading ? 'SIGNING UP...' : 'SIGN UP',
                      backgroundColor: AppColors.orange,
                      onPressed: _isLoading ? null : _handleRegister,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Debug button (only show in debug mode)
                    if (_showDebugInfo) ...[
                      TextButton(
                        onPressed: _testFirebase,
                        child: Text(
                          'Test Firebase Connection',
                          style: AppTextStyles.bodyText(
                            fontSize: 12,
                          ).copyWith(color: AppColors.darkGrey),
                        ),
                      ),
                      TextButton(
                        onPressed: _testSignup,
                        child: Text(
                          'Test Signup Process',
                          style: AppTextStyles.bodyText(
                            fontSize: 12,
                          ).copyWith(color: AppColors.orange),
                        ),
                      ),
                    ],
                    
                    // Toggle debug info
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _showDebugInfo = !_showDebugInfo;
                        });
                      },
                      child: Container(
                        height: 20,
                        color: Colors.transparent,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTextStyles.bodyText(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
                            style: AppTextStyles.bodyText(
                              fontWeight: FontWeight.bold,
                            ).copyWith(
                              color: AppColors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyText(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyText().copyWith(
              color: AppColors.darkGrey.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppColors.darkGrey,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.backgroundGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.lightGrey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.orange,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.orange,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.orange,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

