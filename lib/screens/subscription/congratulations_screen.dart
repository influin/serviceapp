import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';

class CongratulationsScreen extends StatelessWidget {
  final String serviceType;
  final String nextRoute;

  const CongratulationsScreen({
    super.key,
    required this.serviceType,
    required this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    
    return theme.buildPageBackground(
      child: Padding(
        padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            theme.buildCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Lottie Animation
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      'assets/animations/celebration.json',
                      repeat: true,
                      animate: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Congratulations Text
                  Text(
                    'Congratulations!',
                    style: theme.headingStyle(context),
                  ),
                  const SizedBox(height: 16),
                  
                  // Success Message
                  Text(
                    'Your subscription for $serviceType has been activated successfully.',
                    textAlign: TextAlign.center,
                    style: theme.titleStyle,
                  ),
                  const SizedBox(height: 12),
                  
                  // Additional Info
                  Text(
                    'You can now access all the premium features.',
                    textAlign: TextAlign.center,
                    style: theme.subtitleStyle,
                  ),
                  
                  theme.buildDivider(verticalPadding: 24),
                  
                  // Benefits List
                  _buildBenefitItem(context, 'Unlimited service posts', Icons.check_circle_outline),
                  const SizedBox(height: 8),
                  _buildBenefitItem(context, 'Priority customer support', Icons.support_agent),
                  const SizedBox(height: 8),
                  _buildBenefitItem(context, 'Enhanced visibility', Icons.visibility),
                  
                  const SizedBox(height: 32),
                  
                  // Continue Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, nextRoute);
                    },
                    style: theme.primaryButtonStyle(context),
                    child: Text('Continue', style: theme.buttonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBenefitItem(BuildContext context, String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: ThemeStyle.primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: ThemeStyle.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
