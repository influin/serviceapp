import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    
    return Scaffold(
      appBar: theme.buildAppBar(context, 'About App'),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
            child: Container(
              decoration: theme.cardDecoration,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('ServiceinfoTek', style: theme.headingStyle(context)),
                    const SizedBox(height: 16),
                    Text('Version: 1.0.0', style: theme.titleStyle),
                    const SizedBox(height: 24),
                    Text(
                      'Serviceinfotek is your one-stop app for finding and posting services and jobs with seamless subscription management.',
                      style: theme.titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Our mission is to connect users with trusted service providers and job opportunities in an easy and efficient way.',
                      style: theme.titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'For support, feedback, or inquiries, please contact us at support@serviceinfotek.com',
                      style: theme.titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for choosing Serviceinfotek!',
                      style: theme.titleStyle.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
