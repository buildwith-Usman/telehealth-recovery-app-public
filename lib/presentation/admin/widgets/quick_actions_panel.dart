import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class QuickActionsPanel extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsPanel({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.primary(
            'Quick Actions',
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH16,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _buildActionTile(action);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(QuickAction action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: action.backgroundColor?.withOpacity(0.1) ?? AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: action.backgroundColor?.withOpacity(0.2) ?? AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: action.backgroundColor ?? AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                action.icon,
                color: AppColors.white,
                size: 20,
              ),
            ),
            gapH8,
            AppText.primary(
              action.title,
              fontSize: 12,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            if (action.badge != null) ...[
              gapH4,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppText.primary(
                  action.badge!,
                  fontSize: 10,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final String? badge;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.badge,
  });
}
