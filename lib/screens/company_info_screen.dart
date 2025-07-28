import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/location_details_form.dart';

class CompanyInfoScreen extends StatefulWidget {
  const CompanyInfoScreen({Key? key}) : super(key: key);

  @override
  State<CompanyInfoScreen> createState() => _CompanyInfoScreenState();
}

class _CompanyInfoScreenState extends State<CompanyInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _websiteController = TextEditingController();
  final _aboutController = TextEditingController();
  final _logoController = TextEditingController();

  // Location controllers
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingCompanyData = true;
  String? _companyId;
  bool _hasCompany = false;

  // In the initState method, add this:
  @override
  void initState() {
    super.initState();
    // Check if we received a company object for editing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final company = ModalRoute.of(context)?.settings.arguments;
      if (company != null) {
        // If we have a company object, prefill the form
        _prefillCompanyData(company);
      } else {
        // Otherwise fetch from API
        _fetchCompanyData();
      }
    });
  }
  
  // Add this method to prefill the form with company data
  void _prefillCompanyData(dynamic company) {
    setState(() {
      _isLoadingCompanyData = false;
      _companyId = company['_id'];
      _hasCompany = true;
  
      _nameController.text = company['name'] ?? '';
      _websiteController.text = company['website'] ?? '';
      _aboutController.text = company['about'] ?? '';
      _logoController.text = company['logo'] ?? '';
  
      // Prefill location data
      if (company['location'] != null) {
        _countryController.text = company['location']['country'] ?? '';
        _stateController.text = company['location']['state'] ?? '';
        _cityController.text = company['location']['city'] ?? '';
        _districtController.text = company['location']['district'] ?? '';
        _pincodeController.text = company['location']['pincode'] ?? '';
      }
    });
  }

  Future<void> _fetchCompanyData() async {
    setState(() {
      _isLoadingCompanyData = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        setState(() {
          _isLoadingCompanyData = false;
        });
        return;
      }

      var dio = Dio();
      final response = await dio.get(
        'https://service-899a.onrender.com/api/companies/my-companies',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success' && data['results'] > 0) {
          final companies = data['data']['companies'] as List;
          if (companies.isNotEmpty) {
            final company = companies[0];
            _companyId = company['_id'];
            _hasCompany = true;

            // Prefill the form with company data
            setState(() {
              _nameController.text = company['name'] ?? '';
              _websiteController.text = company['website'] ?? '';
              _aboutController.text = company['about'] ?? '';
              _logoController.text = company['logo'] ?? '';

              // Prefill location data
              if (company['location'] != null) {
                _countryController.text = company['location']['country'] ?? '';
                _stateController.text = company['location']['state'] ?? '';
                _cityController.text = company['location']['city'] ?? '';
                _districtController.text = company['location']['district'] ?? '';
                _pincodeController.text = company['location']['pincode'] ?? '';
              }
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching company data: $e');
    } finally {
      setState(() {
        _isLoadingCompanyData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: theme.buildPageBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: ThemeStyle.iconColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              _hasCompany ? 'Edit Company Information' : 'Company Information',
              style: theme.appBarTitleStyle(context),
            ),
            centerTitle: true,
            actions: [
              // Only show skip button if skippedCompanyInfo is false or not set
              // and user doesn't have a company yet
              if (!_hasCompany && (authProvider.userData == null || 
                  authProvider.userData!['skippedCompanyInfo'] != true))
                TextButton(
                  onPressed: () async {
                    // Store a flag indicating user skipped company info
                    final userData = authProvider.userData;
  
                    if (userData != null) {
                      // Create a copy of userData with the skippedCompanyInfo flag
                      final updatedUserData = Map<String, dynamic>.from(userData);
                      updatedUserData['skippedCompanyInfo'] = true;
  
                      // Update the user data in the provider
                      await authProvider.setUserData(updatedUserData);
  
                      // Save to SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                        'user_data',
                        jsonEncode(updatedUserData),
                      );
                      
                      // Add this line to ensure the AuthProvider is properly updated
                      await authProvider.refreshUserData();
                    }
  
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: Text('Skip', style: theme.linkStyle(context)),
                ),
            ],
          ),
          body: _isLoadingCompanyData
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(ThemeStyle.defaultPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hasCompany 
                              ? 'Edit your company information'
                              : 'Please provide your company information',
                          style: theme.titleStyle,
                        ),
                        const SizedBox(height: 20),
                        theme.buildCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: theme.inputDecoration(
                                  labelText: 'Company Name',
                                  prefixIcon: Icons.business,
                                  context: context,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter company name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _websiteController,
                                decoration: theme.inputDecoration(
                                  labelText: 'Website (Optional)',
                                  prefixIcon: Icons.language,
                                  context: context,
                                ),
                                keyboardType: TextInputType.url,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _aboutController,
                                decoration: theme.inputDecoration(
                                  labelText: 'About Company (Optional)',
                                  prefixIcon: Icons.description,
                                  context: context,
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _logoController,
                                decoration: theme.inputDecoration(
                                  labelText: 'Logo URL (Optional)',
                                  prefixIcon: Icons.image,
                                  context: context,
                                ),
                                keyboardType: TextInputType.url,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        LocationDetailsForm(
                          districtController: _districtController,
                          stateController: _stateController,
                          cityController: _cityController,
                          pincodeController: _pincodeController,
                          countryController: _countryController,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitCompanyInfo,
                          style: theme.primaryButtonStyle(context),
                          child:
                              _isLoading
                                  ? theme.loadingIndicator()
                                  : Text(_hasCompany ? 'Update' : 'Submit', style: theme.buttonTextStyle),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _submitCompanyInfo() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication error. Please login again.'),
          ),
        );
        return;
      }

      final Map<String, dynamic> requestData = {
        "name": _nameController.text,
        "location": {
          "country": _countryController.text,
          "state": _stateController.text,
          "city": _cityController.text,
          "district": _districtController.text,
          "pincode": _pincodeController.text,
        },
      };

      // Add optional fields if they're not empty
      if (_websiteController.text.isNotEmpty) {
        requestData["website"] = _websiteController.text;
      }

      if (_aboutController.text.isNotEmpty) {
        requestData["about"] = _aboutController.text;
      }

      if (_logoController.text.isNotEmpty) {
        requestData["logo"] = _logoController.text;
      }

      var dio = Dio();
      Response response;
      
      if (_hasCompany && _companyId != null) {
        // Update existing company
        response = await dio.patch(
          'https://service-899a.onrender.com/api/companies/${_companyId}',
          data: requestData,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      } else {
        // Create new company
        response = await dio.post(
          'https://service-899a.onrender.com/api/companies',
          data: requestData,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
  
      // Simplified response handling
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          // Update user data to include company info
          await authProvider.refreshUserData();
  
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_hasCompany ? 'Company updated successfully' : 'Company created successfully'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate to home screen only if this was a new company creation
          // and not an update to an existing company
          if (!_hasCompany) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
