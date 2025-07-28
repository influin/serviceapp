import 'package:app/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;

    return theme.buildPageBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/logo.jpeg', height: 120),
              const SizedBox(height: 30),
              Text(
                'Welcome Back!',
                style: theme.headingStyle(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Please sign in to continue',
                style: theme.titleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              theme.buildCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: theme.inputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icons.email_outlined,
                        context: context,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: theme.inputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        context: context,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                          _isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    final authProvider =
                                        Provider.of<AuthProvider>(
                                          context,
                                          listen: false,
                                        );
                                    final success = await authProvider.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    // Inside the login button onPressed callback, replace the existing success navigation with:
                                    if (success && mounted) {
                                      // Ensure we have the latest user data
                                      await authProvider.refreshUserData();

                                      // First check if user has companies
                                      try {
                                        var dio = Dio();
                                        final response = await dio.get(
                                          'https://service-899a.onrender.com/api/companies/my-companies',
                                          options: Options(
                                            headers: {
                                              'Authorization':
                                                  'Bearer ${authProvider.token}',
                                            },
                                          ),
                                        );

                                        if (response.statusCode == 200) {
                                          final data = response.data;
                                          final hasCompanies =
                                              data['status'] == 'success' &&
                                              data['results'] > 0 &&
                                              data['data']['companies']
                                                  is List &&
                                              (data['data']['companies']
                                                      as List)
                                                  .isNotEmpty;

                                          // Check if user has skipped company info
                                          final userData =
                                              authProvider.userData;
                                          final hasSkippedCompanyInfo =
                                              userData != null &&
                                              userData['skippedCompanyInfo'] ==
                                                  true;

                                          if (hasCompanies ||
                                              hasSkippedCompanyInfo) {
                                            // User either has companies or has skipped company info
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/home',
                                            );
                                          } else {
                                            // User has no companies and hasn't skipped company info
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/company-info',
                                            );
                                          }
                                        } else {
                                          // If API call fails, fall back to checking userData
                                          _fallbackNavigation(
                                            authProvider,
                                            context,
                                          );
                                        }
                                      } catch (e) {
                                        print('Error checking companies: $e');
                                        // If API call fails, fall back to checking userData
                                        _fallbackNavigation(
                                          authProvider,
                                          context,
                                        );
                                      }
                                    }
                                  } finally {
                                    if (mounted)
                                      setState(() => _isLoading = false);
                                  }
                                }
                              },
                      style: theme.primaryButtonStyle(context),
                      child:
                          _isLoading
                              ? theme.loadingIndicator()
                              : Text('Login', style: theme.buttonTextStyle),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: theme.subtitleStyle),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Text('Register', style: theme.linkStyle(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this helper method in the _LoginScreenState class
void _fallbackNavigation(AuthProvider authProvider, BuildContext context) {
  final userData = authProvider.userData;
  final hasCompanyInfo =
      userData != null &&
      userData['company'] != null &&
      userData['company'].isNotEmpty;
  final hasSkippedCompanyInfo =
      userData != null && userData['skippedCompanyInfo'] == true;

  if (hasCompanyInfo || hasSkippedCompanyInfo) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    Navigator.pushReplacementNamed(context, '/company-info');
  }
}
