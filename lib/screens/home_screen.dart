import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:app/screens/settings/language_screen.dart';
import 'package:app/widgets/government_jobs_section.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/service_subscription_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showSubscriptionSheet(
    BuildContext context, {
    required String serviceType,
    required int price,
    required List<String> benefits,
    bool isPremium = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeStyle.cardBorderRadius),
        ),
      ),
      builder:
          (context) => ServiceSubscriptionSheet(
            serviceType: serviceType,
            price: price,
            benefits: benefits,
            isPremium: isPremium,
          ),
    );
  }

  void _handleCardTap(BuildContext context, String serviceType) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = authProvider.isAuthenticated;

    if (!isAuthenticated) {
      final result = await Navigator.pushNamed(context, '/login');
      if (result != true) return;
    }

    final token = authProvider.token;
    final userData = authProvider.userData;
    var dio = Dio();

    // Check if user has company information
    if ((serviceType == 'Service Post' || serviceType == 'Job Post') &&
        (userData == null ||
            userData['company'] == null &&
                userData['skippedCompanyInfo'] != true)) {
      // Store the intended service type before redirecting
      final result = await Navigator.pushNamed(context, '/company-info');

      // If company info was successfully added and the context is still valid
      if (result == true && context.mounted) {
        // Refresh user data
        await authProvider.refreshUserData();
        // Retry the operation with updated user data
        _handleCardTap(context, serviceType);
      }
      return;
    }

    // Job Post is free
    if (serviceType == 'Job Post') {
      Navigator.pushNamed(context, '/job-post');
      return;
    }

    try {
      final response = await dio.request(
        'https://service-899a.onrender.com/api/subscriptions/my-subscriptions',
        options: Options(
          method: 'GET',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      bool hasServicePostSubscription = false;
      bool hasCurrentServiceSubscription = false;

      if (response.statusCode == 200) {
        final subscriptions = response.data['data']['subscriptions'] as List;

        hasServicePostSubscription = subscriptions.any(
          (sub) =>
              sub['type'] == 'SERVICE_POST' &&
              DateTime.parse(sub['endDate']).isAfter(DateTime.now()),
        );

        hasCurrentServiceSubscription = subscriptions.any(
          (sub) =>
              sub['type'] == serviceType.toUpperCase().replaceAll(' ', '_') &&
              DateTime.parse(sub['endDate']).isAfter(DateTime.now()),
        );
      }

      // If serviceType is Service Post and user has already subscribed, allow
      if (serviceType == 'Service Post') {
        Navigator.pushNamed(context, '/service-post');
        return;
      }

      // If Service Post is subscribed, allow access to Service Search and Job Search
      if ((serviceType == 'Service Search' || serviceType == 'Job Search') &&
          hasServicePostSubscription) {
        Navigator.pushNamed(
          context,
          '/${serviceType.toLowerCase().replaceAll(' ', '-')}',
        );
        return;
      }

      // Check if this is the first Service Post use (free only for Service Post)
      if (serviceType == 'Service Post') {
        final usageResponse = await dio.get(
          'https://service-899a.onrender.com/api/usage/check-first-use?type=SERVICE_POST',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );

        if (usageResponse.statusCode == 200 &&
            usageResponse.data['isFirstTime'] == true) {
          // Record first use
          await dio.post(
            'https://service-899a.onrender.com/api/usage/record',
            data: {'type': 'SERVICE_POST'},
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          Navigator.pushNamed(context, '/service-post');
          return;
        }
      }

      // If user has current subscription to service, allow
      if (hasCurrentServiceSubscription) {
        Navigator.pushNamed(
          context,
          '/${serviceType.toLowerCase().replaceAll(' ', '-')}',
        );
        return;
      }
    } catch (e) {
      print('Error checking subscription: $e');
    }

    if (!context.mounted) return;

    // Show subscription sheet
    switch (serviceType) {
      case 'Service Search':
        _showSubscriptionSheet(
          context,
          serviceType: serviceType,
          price: 100,
          benefits: [
            'Unlimited service search for 365 days',
            'Direct booking with service providers',
            'Verified service providers only',
          ],
          isPremium: true,
        );
        break;
      case 'Job Search':
        _showSubscriptionSheet(
          context,
          serviceType: serviceType,
          price: 100,
          benefits: [
            'Access to all job listings for 365 days',
            'Direct application to jobs',
            'Early access to new job postings',
            'Resume builder and job alerts',
          ],
          isPremium: true,
        );
        break;
      case 'Service Post':
        _showSubscriptionSheet(
          context,
          serviceType: serviceType,
          price: 500,
          benefits: [
            'Post unlimited services for 365 days',
            'Business profile customization',
            'Priority listing in search results',
            'Analytics and insights',
            'Includes access to Job & Service search feature',
          ],
          isPremium: true,
        );
        break;
    }
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    final theme = AppTheme.style;
    return Container(
      decoration: theme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleCardTap(context, title),
          borderRadius: BorderRadius.circular(ThemeStyle.cardBorderRadius),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: theme.iconBoxDecoration(context),
                child: Icon(
                  icon,
                  size: ThemeStyle.iconSize,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(title, style: theme.titleStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;

    return theme.buildPageBackground(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Serviceinfo',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextSpan(
                    text: 'tek',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
          drawer: const AppDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome to Serviceinfo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'tek',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeStyle.defaultPadding - 4,
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                    children: [
                      _buildCard(
                        context,
                        'Service Search',
                        Icons.search,
                        '/service-search',
                      ),
                      _buildCard(
                        context,
                        'Service Post',
                        Icons.post_add,
                        '/service-post',
                      ),
                      _buildCard(
                        context,
                        'Job Search',
                        Icons.search_outlined,
                        '/job-search',
                      ),
                      _buildCard(context, 'Job Post', Icons.work, '/job-post'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const GovernmentJobsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
