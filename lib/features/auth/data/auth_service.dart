class AuthService {
  static bool _isLoggedIn = false;
  static String? _currentUserEmail;
  static String? _currentUserName;

  // Check if user is logged in
  static bool get isLoggedIn => _isLoggedIn;

  // Get current user email
  static String? get currentUserEmail => _currentUserEmail;

  // Get current user name
  static String? get currentUserName => _currentUserName;

  // Login with email and password
  static Future<bool> login(String email, String password) async {
    // TODO: Implement actual authentication logic (Firebase, API, etc.)
    // For now, this is a mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      // Extract name from email (before @) or use a default
      _currentUserName = email.split('@').first;
      return true;
    }
    return false;
  }

  // Logout
  static Future<void> logout() async {
    // TODO: Implement actual logout logic (Firebase, API, etc.)
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    _currentUserEmail = null;
    _currentUserName = null;
  }

  // Register new user
  static Future<bool> register(String email, String password, String name) async {
    // TODO: Implement actual registration logic (Firebase, API, etc.)
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      _isLoggedIn = true;
      _currentUserEmail = email;
      _currentUserName = name;
      return true;
    }
    return false;
  }
}

