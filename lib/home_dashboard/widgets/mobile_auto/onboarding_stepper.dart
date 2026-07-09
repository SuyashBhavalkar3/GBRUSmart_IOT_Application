import 'package:flutter/material.dart';
import '../../app_colors.dart';

/// A 3-step custom horizontal stepper that indicates onboarding progress.
class OnboardingStepper extends StatelessWidget {
  final int currentStep; // 1, 2, or 3

  const OnboardingStepper({
    super.key,
    required this.currentStep,
  }) : assert(currentStep >= 1 && currentStep <= 3, 'Step must be 1, 2, or 3');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildStepCircle(1),
              _buildLine(1),
              _buildStepCircle(2),
              _buildLine(2),
              _buildStepCircle(3),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Device ID', 1),
              _buildLabel('IMEI Verify', 2),
              _buildLabel('Approval', 3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step) {
    final isCompleted = step < currentStep;
    final isActive = step == currentStep;

    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isActive ? AppColors.primaryGreen : Colors.white,
        border: Border.all(
          color: isCompleted || isActive ? AppColors.primaryGreen : AppColors.borderGrey,
          width: 2.0,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primaryGreen.withAlpha(76),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16.0,
              )
            : Text(
                '$step',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.textGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
      ),
    );
  }

  Widget _buildLine(int stepAfter) {
    final isCompleted = stepAfter < currentStep;
    return Expanded(
      child: Container(
        height: 2.0,
        color: isCompleted ? AppColors.primaryGreen : AppColors.borderGrey,
      ),
    );
  }

  Widget _buildLabel(String text, int step) {
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;

    return Expanded(
      child: Text(
        text,
        textAlign: step == 1
            ? TextAlign.left
            : (step == 3 ? TextAlign.right : TextAlign.center),
        style: TextStyle(
          color: isActive || isCompleted ? AppColors.primaryGreen : AppColors.textGrey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
