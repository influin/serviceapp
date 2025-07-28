import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    
    return Scaffold(
      appBar: theme.buildAppBar(context, 'Terms and Conditions'),
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
                child: Text('''
Welcome to Serviceinfotek!

Please read these terms and conditions carefully before using our app.

1. Acceptance of Terms
By accessing or using this app, you agree to be bound by these terms.

2. Use License
Permission is granted to temporarily download one copy of the materials for personal, non-commercial transitory viewing only.

3. Limitations
You agree not to misuse the app or engage in any unauthorized activities.

4. Disclaimer
The materials are provided "as is" without warranties of any kind.

5. Changes to Terms
We may update these terms at any time without notice.

For full terms, visit our website or contact support.

Thank you for using Serviceinfotek!
''', style: theme.titleStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
