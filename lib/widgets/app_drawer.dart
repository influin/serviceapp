import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    // Removed l10n = AppLocalizations.of(context)!
    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isAuthenticated;
    final userData = authProvider.userData;

    return Drawer(
      // Apply the card decoration style for a consistent look
      child: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: Column(
          children: [
            if (isLoggedIn)
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  // Optional: Add a subtle gradient to the header
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      ThemeStyle.secondaryColor,
                    ],
                  ),
                ),
                accountName: Text(
                  userData?['name'] ?? '',
                  style: theme.titleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(
                  userData?['email'] ?? '',
                  style: theme.subtitleStyle.copyWith(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    (userData?['name'] as String?)?.isNotEmpty == true
                        ? userData!['name'][0].toUpperCase()
                        : '',
                    style: theme
                        .headingStyle(context)
                        .copyWith(
                          fontSize: 32.0,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              )
            else
              SizedBox(height: 64.0),
            // Apply theme divider with consistent padding
            theme.buildDivider(verticalPadding: 8.0),
            // Wrap the list items in an Expanded widget with ListView
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Add Home button at the top of the navigation options
                  _buildListTile(
                    context: context,
                    icon: Icons.home,
                    title: 'Home',
                    onTap:
                        () => Navigator.pushReplacementNamed(context, '/home'),
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.language,
                    title:
                        'Change Language', // Changed from l10n.changeLanguage
                    onTap: () => Navigator.pushNamed(context, '/language'),
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.card_giftcard,
                    title: 'Refer & Earn', // Changed from l10n.referEarn
                    enabled: isLoggedIn,
                    onTap:
                        isLoggedIn
                            ? () => Navigator.pushNamed(context, '/refer')
                            : null,
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.subscriptions,
                    title:
                        'Company Information', // Changed from l10n.mySubscriptions
                    enabled: isLoggedIn,
                    onTap:
                        isLoggedIn
                            ? () =>
                                Navigator.pushNamed(context, '/company-list')
                            : null,
                  ),

                  _buildListTile(
                    context: context,
                    icon: Icons.subscriptions,
                    title:
                        'My Subscriptions', // Changed from l10n.mySubscriptions
                    enabled: isLoggedIn,
                    onTap:
                        isLoggedIn
                            ? () => Navigator.pushNamed(
                              context,
                              '/my-subscriptions',
                            )
                            : null,
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.work,
                    title: 'My Job Posts',
                    enabled: isLoggedIn,
                    onTap:
                        isLoggedIn
                            ? () =>
                                Navigator.pushNamed(context, '/my-job-posts')
                            : null,
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.miscellaneous_services,
                    title: 'My Service Posts',
                    enabled: isLoggedIn,
                    onTap:
                        isLoggedIn
                            ? () => Navigator.pushNamed(
                              context,
                              '/my-service-posts',
                            )
                            : null,
                  ),
                  // Use the theme's buildDivider method for consistent styling
                  theme.buildDivider(),
                  _buildListTile(
                    context: context,
                    icon: Icons.description,
                    title:
                        'Terms & Conditions', // Changed from l10n.termsConditions
                    onTap: () => Navigator.pushNamed(context, '/terms'),
                  ),
                  _buildListTile(
                    context: context,
                    icon: Icons.info,
                    title: 'About App', // Changed from l10n.aboutApp
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  theme.buildDivider(),
                  if (isLoggedIn)
                    _buildListTile(
                      context: context,
                      icon: Icons.logout,
                      title: 'Logout', // Changed from l10n.logout
                      onTap: () {
                        authProvider.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    )
                  else ...[
                    _buildListTile(
                      context: context,
                      icon: Icons.login,
                      title: 'Login',
                      onTap:
                          () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                    ),
                    _buildListTile(
                      context: context,
                      icon: Icons.person_add,
                      title: 'Register',
                      onTap:
                          () => Navigator.pushReplacementNamed(
                            context,
                            '/register',
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    final theme = AppTheme.style;
    final Color itemColor =
        enabled ? Theme.of(context).primaryColor : Colors.grey[400]!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeStyle.cardBorderRadius),
        // Add subtle hover effect
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration:
              enabled
                  ? theme.iconBoxDecoration(context)
                  : BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
          child: Icon(icon, color: itemColor, size: 24),
        ),
        title: Text(
          title,
          style: theme.titleStyle.copyWith(
            color: itemColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: itemColor),
        enabled: enabled,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeStyle.cardBorderRadius),
        ),
        tileColor: Colors.transparent,
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
      ),
    );
  }

  // Add this after "My Service Posts" and before "Terms & Conditions"
}
