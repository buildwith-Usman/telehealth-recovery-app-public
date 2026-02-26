/// Examples of how to use the enhanced CustomNavigationButton widget
/// 
/// This file demonstrates various ways to customize the navigation button
/// with different icons, colors, and styling options.
library;

import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../button/custom_navigation_button.dart';

class NavigationButtonExamples extends StatelessWidget {
  const NavigationButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Button Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('1. Standard Navigation Buttons', [
              _buildExample(
                'Default Previous Button',
                CustomNavigationButton(
                  type: NavigationButtonType.previous,
                  onPressed: () {},
                ),
              ),
              _buildExample(
                'Default Next Button',
                CustomNavigationButton(
                  type: NavigationButtonType.next,
                  onPressed: () {},
                ),
              ),
            ]),
            
            _buildSection('2. Custom Icon Data', [
              _buildExample(
                'Close Button',
                CustomNavigationButton.withIcon(
                  type: NavigationButtonType.previous,
                  iconData: Icons.close,
                  onPressed: () {},
                ),
              ),
              _buildExample(
                'Home Button',
                CustomNavigationButton.withIcon(
                  type: NavigationButtonType.next,
                  iconData: Icons.home,
                  onPressed: () {},
                ),
              ),
            ]),
            
            _buildSection('3. Custom App Icons', [
              _buildExample(
                'Custom App Icon',
                CustomNavigationButton.withAppIcon(
                  type: NavigationButtonType.previous,
                  appIcon: AppIcon.rightArrowIcon,
                  onPressed: () {},
                ),
              ),
            ]),
            
            _buildSection('4. Custom Colors', [
              _buildExample(
                'Red Background',
                CustomNavigationButton(
                  type: NavigationButtonType.previous,
                  backgroundColor: Colors.red.shade100,
                  iconColor: Colors.red,
                  borderColor: Colors.red,
                  onPressed: () {},
                ),
              ),
              _buildExample(
                'Green Filled',
                CustomNavigationButton(
                  type: NavigationButtonType.next,
                  isFilled: true,
                  filledColor: Colors.green,
                  onPressed: () {},
                ),
              ),
            ]),
            
            _buildSection('5. Custom Widget Icon', [
              _buildExample(
                'Custom Widget',
                CustomNavigationButton.withWidget(
                  type: NavigationButtonType.previous,
                  widget: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: AppColors.white,
                      size: 12,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ]),
            
            _buildSection('6. Different Sizes', [
              _buildExample(
                'Large Button',
                CustomNavigationButton(
                  type: NavigationButtonType.previous,
                  size: 60,
                  iconSize: 20,
                  onPressed: () {},
                ),
              ),
              _buildExample(
                'Small Button',
                CustomNavigationButton(
                  type: NavigationButtonType.next,
                  size: 35,
                  iconSize: 12,
                  onPressed: () {},
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> examples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...examples,
      ],
    );
  }

  Widget _buildExample(String description, Widget button) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(description),
          ),
          const SizedBox(width: 16),
          button,
        ],
      ),
    );
  }
}
