import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';  // Add this import

class ReferEarnScreen extends StatelessWidget {
  const ReferEarnScreen({super.key});

  void _shareApp(String referralCode) {
    final message =
        'Check out this amazing app! Download now and get exclusive benefits. Use my referral code: $referralCode';
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;
    final referralCode =
        userData?['referralId'] ?? 'FRIEND2024'; // Get referralId from userData
    final theme = AppTheme.style;

    return theme.buildPageBackground(
      child: Scaffold(
        appBar: theme.buildAppBar(context, 'Refer & Earn'),
        drawer: const AppDrawer(),  // Add this line
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                theme.buildCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: theme.iconBoxDecoration(context),
                        child: const Icon(
                          Icons.card_giftcard,
                          size: ThemeStyle.iconSize * 1.5,
                          color: ThemeStyle.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Invite Friends & Earn Rewards',
                        style: theme.headingStyle(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Share your referral code with friends and earn exciting rewards!',
                        style: theme.subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                theme.buildCard(
                  child: Column(
                    children: [
                      Text(
                        'Your Referral Code',
                        style: theme.titleStyle,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeStyle.dividerColor),
                          borderRadius: BorderRadius.circular(ThemeStyle.cardBorderRadius / 2),
                          color: Colors.grey[50],
                        ),
                        child: Text(
                          referralCode,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _shareApp(referralCode),
                  icon: const Icon(Icons.share),
                  label: Text('Share with Friends', style: theme.buttonTextStyle),
                  style: theme.primaryButtonStyle(context),
                ),
                const SizedBox(height: 24),
                theme.buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works',
                        style: theme.headingStyle(context).copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Text('1', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        title: Text('Share your referral code', style: theme.titleStyle),
                        subtitle: Text('Send your unique code to friends', style: theme.subtitleStyle),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Text('2', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        title: Text('Friend signs up', style: theme.titleStyle),
                        subtitle: Text(
                          'Your friend creates an account using your code',
                          style: theme.subtitleStyle,
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Text('3', style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        title: Text('Both get rewards', style: theme.titleStyle),
                        subtitle: Text(
                          'You and your friend receive special benefits',
                          style: theme.subtitleStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
