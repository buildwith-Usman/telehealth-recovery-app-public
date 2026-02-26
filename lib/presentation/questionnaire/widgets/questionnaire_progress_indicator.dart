import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';

class QuestionnaireProgressIndicator extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestionIndex;
  final List<bool> completedQuestions;
  final Function(int) onQuestionTapped;

  const QuestionnaireProgressIndicator({
    super.key,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    required this.completedQuestions,
    required this.onQuestionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalQuestions, (index) {
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => onQuestionTapped(index),
                    child: _buildQuestionCircle(index),
                  ),
                ),
                if (index < totalQuestions - 1) _buildConnectorLine(index),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuestionCircle(int index) {
    final isActive = index == currentQuestionIndex;
    final isCompleted = index < completedQuestions.length && completedQuestions[index];
    final isPassed = index < currentQuestionIndex;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isActive) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.white;
      borderColor = AppColors.primary;
    } else if (isCompleted || isPassed) {
      backgroundColor = AppColors.primary.withOpacity(0.1);
      textColor = AppColors.primary;
      borderColor = AppColors.primary;
    } else {
      backgroundColor = AppColors.grey80.withOpacity(0.3);
      textColor = AppColors.textSecondary;
      borderColor = AppColors.grey80;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectorLine(int index) {
    final isCompleted = index < currentQuestionIndex;
    
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: isCompleted ? AppColors.primary : AppColors.grey80,
          dashWidth: 4,
          dashSpace: 3,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
