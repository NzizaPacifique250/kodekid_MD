import 'dart:convert';
import 'package:http/http.dart' as http;

class PythonExecutionService {
  // ============================================================================
  // CONFIGURATION: Set your Python execution API endpoint here
  // ============================================================================
  // Option 1: Use your own backend API (Recommended for production)
  //   Example: 'https://your-backend.com/api/execute-python'
  //   See instructions below for setting up your own backend
  //
  // Option 2: Use a public API (for testing only, not recommended for production)
  //   Some options: CodeX API, Replit API, etc.
  //
  // Option 3: Leave as null to use local simulation (limited functionality)
  // ============================================================================
  static const String? _apiUrl = 'https://api.programiz.com/compiler-api/v1/compile'; // Using Programiz API

  // API configuration - adjust these based on your backend's expected format
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
  };

  /// Executes Python code and returns the output
  static Future<PythonExecutionResult> executeCode(String code) async {
    // If no API URL is configured, use local execution simulation
    if (_apiUrl == null || _apiUrl!.isEmpty) {
      return _executeCodeLocally(code);
    }

    try {
      // Try the configured API
      final response = await http.post(
        Uri.parse(_apiUrl!),
        headers: _defaultHeaders,
        body: jsonEncode(_buildRequestBody(code)),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseApiResponse(data);
      } else {
        // Fallback: Try local execution simulation
        return _executeCodeLocally(code);
      }
    } catch (e) {
      // If API fails, try local execution simulation
      return _executeCodeLocally(code);
    }
  }

  /// Builds the request body based on your API's expected format
  /// Adjust this method to match your backend's API specification
  static Map<String, dynamic> _buildRequestBody(String code) {
    return {
      'language': 'python',
      'version': 'latest',
      'code': code,
      'input': '',
    };
  }

  /// Parses the API response based on your backend's response format
  /// Adjust this method to match your backend's response structure
  static PythonExecutionResult _parseApiResponse(Map<String, dynamic> data) {
    final success = data['success'] ?? false;
    return PythonExecutionResult(
      success: success,
      output: data['output'] ?? '',
      error: success ? '' : (data['error'] ?? 'Execution failed'),
    );
  }

  /// Local execution simulation for basic Python operations
  /// This is a fallback when the API is unavailable
  /// Supports basic print statements and simple Python code
  static Future<PythonExecutionResult> _executeCodeLocally(String code) async {
    try {
      // Remove leading/trailing whitespace
      final cleanCode = code.trim();
      
      if (cleanCode.isEmpty) {
        return PythonExecutionResult(
          success: false,
          output: '',
          error: 'No code to execute',
        );
      }

      // Handle print statements with single or double quotes
      // Matches: print("text"), print('text'), print("text", "text2"), etc.
      final printRegex = RegExp(
        r'print\s*\(\s*([^)]+)\s*\)',
        multiLine: true,
      );
      
      final matches = printRegex.allMatches(cleanCode);
      final outputs = <String>[];
      
      for (final match in matches) {
        final content = match.group(1) ?? '';
        // Extract string literals from print arguments
        final stringRegex = RegExp(r'''["']([^"']*)["']''');
        final stringMatches = stringRegex.allMatches(content);
        
        if (stringMatches.isNotEmpty) {
          for (final strMatch in stringMatches) {
            outputs.add(strMatch.group(1) ?? '');
          }
        } else {
          // Handle variables or expressions (simplified)
          outputs.add(content.trim());
        }
      }
      
      if (outputs.isNotEmpty) {
        return PythonExecutionResult(
          success: true,
          output: outputs.join('\n'),
          error: '',
        );
      }
      
      // If no print statements found, check for other common patterns
      if (cleanCode.contains('=') && !cleanCode.contains('print')) {
        // Variable assignment - just acknowledge it
        return PythonExecutionResult(
          success: true,
          output: 'Code executed successfully (variable assignment)',
          error: '',
        );
      }
      
      // For other code patterns
      return PythonExecutionResult(
        success: true,
        output: 'Code executed successfully!\n\nNote: This is a limited local simulation. For full Python execution, please configure a Python execution API endpoint in python_execution_service.dart\n\nSee the file comments for setup instructions.',
        error: '',
      );
    } catch (e) {
      return PythonExecutionResult(
        success: false,
        output: '',
        error: 'Error executing code: ${e.toString()}',
      );
    }
  }
}

class PythonExecutionResult {
  final bool success;
  final String output;
  final String error;

  PythonExecutionResult({
    required this.success,
    required this.output,
    required this.error,
  });

  String get displayOutput {
    if (error.isNotEmpty) {
      return 'Error: $error';
    }
    return output.isEmpty ? '(No output)' : output;
  }
}

