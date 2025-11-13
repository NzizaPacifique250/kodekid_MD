import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../data/python_execution_service.dart';

class CodeEditorWidget extends StatefulWidget {
  final Function(String)? onCodeChanged;
  final String? initialCode;
  final String? output;

  const CodeEditorWidget({
    super.key,
    this.onCodeChanged,
    this.initialCode,
    this.output,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late TextEditingController _codeController;
  String _output = '';
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode ?? '');
    _output = widget.output ?? '';
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _runCode() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() {
        _output = 'Please write some code first!';
      });
      return;
    }

    setState(() {
      _isExecuting = true;
      _output = 'Executing code...';
    });

    try {
      final result = await PythonExecutionService.executeCode(
        _codeController.text,
      );

      setState(() {
        _isExecuting = false;
        _output = result.displayOutput;
      });
    } catch (e) {
      setState(() {
        _isExecuting = false;
        _output = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kode Board
        Text(
          'Kode Board',
          style: AppTextStyles.bodyText(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.oliveGreen.withOpacity(0.1),
            border: Border.all(
              color: AppColors.darkGrey.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _codeController,
            maxLines: null,
            expands: true,
            style: AppTextStyles.bodyText(
              fontSize: 14,
            ).copyWith(
              fontFamily: 'monospace',
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
              hintText: 'Write your code here...',
            ),
            onChanged: (value) {
              widget.onCodeChanged?.call(value);
            },
          ),
        ),
        const SizedBox(height: 16),
        // Run Button
        Center(
          child: ElevatedButton(
            onPressed: _isExecuting ? null : _runCode,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.oliveGreen,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.oliveGreen.withOpacity(0.6),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: _isExecuting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(
                    'Run',
                    style: AppTextStyles.buttonText(),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        // Output Board
        Text(
          'Output Board',
          style: AppTextStyles.bodyText(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.oliveGreen.withOpacity(0.1),
            border: Border.all(
              color: AppColors.darkGrey.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Text(
              _output.isEmpty ? 'Output will appear here...' : _output,
              style: AppTextStyles.bodyText(
                fontSize: 14,
              ).copyWith(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

