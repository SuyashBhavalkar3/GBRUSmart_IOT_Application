import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputWidget extends StatefulWidget {
  final Function(String) onChanged;
  final bool hasError;

  const OtpInputWidget({super.key, required this.onChanged, this.hasError = false});

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final int _otpLength = 6;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    _controllers = List.generate(_otpLength, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Auto-advance
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, dismiss keyboard
        _focusNodes[index].unfocus();
      }
    }
    _notifyChange();
  }

  void _notifyChange() {
    String currentOtp = _controllers.map((c) => c.text).join();
    widget.onChanged(currentOtp);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // Calculate box size dynamically to fit 6 boxes proportionally on the screen
    final double boxWidth = width * (48.0 / 393.0);
    final double boxHeight = width * (56.0 / 393.0); // Slightly taller than wide

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_otpLength, (index) {
        return Container(
          width: boxWidth,
          height: boxHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: widget.hasError ? Colors.red : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: Center(
            child: KeyboardListener(
              focusNode: FocusNode(), // Dummy node to capture key events before textfield
              onKeyEvent: (event) {
                if (event is KeyDownEvent && 
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[index].text.isEmpty &&
                    index > 0) {
                  // If backspace is pressed on an empty field, move focus back
                  _focusNodes[index - 1].requestFocus();
                  _controllers[index - 1].clear();
                  _notifyChange();
                }
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(
                  fontSize: width * (20.0 / 393.0),
                  fontWeight: FontWeight.w600,
                  color: widget.hasError ? Colors.red : const Color(0xFF1F2937),
                  fontFamily: 'Inter',
                ),
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) => _onChanged(value, index),
              ),
            ),
          ),
        );
      }),
    );
  }
}
