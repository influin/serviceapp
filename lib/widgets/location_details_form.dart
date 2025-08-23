import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationDetailsForm extends StatefulWidget {
  final TextEditingController districtController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController pincodeController;
  final TextEditingController countryController;
  final bool showTitle;
  final bool isDesktop; // Add this line

  const LocationDetailsForm({
    Key? key,
    required this.districtController,
    required this.stateController,
    required this.cityController,
    required this.pincodeController,
    required this.countryController,
    this.showTitle = true,
    this.isDesktop = false, // Add this line
  }) : super(key: key);

  @override
  State<LocationDetailsForm> createState() => _LocationDetailsFormState();
}

class _LocationDetailsFormState extends State<LocationDetailsForm> {
  bool _isLoading = true;
  List<dynamic> _indiaData = [];
  List<String> _states = [];
  List<Map<String, dynamic>> _cities = [];
  List<String> _towns = [];

  String? _selectedState;
  String? _selectedCity;
  String? _selectedTown;

  @override
  void initState() {
    super.initState();
    widget.countryController.text = "INDIA";
    _fetchIndiaData();
  }

  Future<void> _fetchIndiaData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://levbitz-apis.netlify.app/locations/india/india.json',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _indiaData = data;
          _states = _extractStates(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load location data')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  List<String> _extractStates(List<dynamic> data) {
    final List<String> statesList = [];
    for (var item in data) {
      if (item['state'] != null) {
        statesList.add(item['state']);
      }
    }
    return statesList..sort();
  }

  void _updateCities(String state) {
    for (var stateData in _indiaData) {
      if (stateData['state'] == state && stateData['cities'] != null) {
        setState(() {
          // Fix the type casting issue by properly mapping the data
          _cities =
              (stateData['cities'] as List)
                  .map((city) => city as Map<String, dynamic>)
                  .toList();
          _selectedCity = null;
          _towns = [];
          _selectedTown = null;
          widget.stateController.text = state;
          widget.cityController.text = "";
          widget.districtController.text = "";
        });
        break;
      }
    }
  }

  void _updateTowns(String city) {
    for (var cityData in _cities) {
      if (cityData['city'] == city && cityData['towns'] != null) {
        setState(() {
          _towns = List<String>.from(cityData['towns']);
          _selectedTown = null;
          widget.cityController.text = city;
          widget.districtController.text = "";
        });
        break;
      }
    }
  }

  void _setTown(String town) {
    setState(() {
      _selectedTown = town;
      widget.districtController.text = town;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.style;

    return theme.buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle) ...[
            Text('Location Details', style: theme.titleStyle),
            const SizedBox(height: 16),
          ],
          // Country field (pre-filled with INDIA)
          TextFormField(
            controller: widget.countryController,
            enabled: false,
            decoration: theme.inputDecoration(
              labelText: 'Country',
              prefixIcon: Icons.public,
              context: context,
            ),
          ),
          const SizedBox(height: 16),

          // State dropdown
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : DropDownSearchField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: TextEditingController(text: _selectedState),
                    decoration: theme.searchDropdownDecoration(
                      labelText: 'State',
                      prefixIcon: Icons.map,
                      context: context,
                      hintText: 'Select State',
                    ),
                  ),
                  displayAllSuggestionWhenTap: true,
                  isMultiSelectDropdown: false,
                  suggestionsCallback: (pattern) {
                    return _states
                        .where((state) => state.toLowerCase().contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _selectedState = suggestion;
                    });
                    _updateCities(suggestion);
                    widget.stateController.text = suggestion;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                ),
          const SizedBox(height: 16),

          // City dropdown
          DropDownSearchField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: TextEditingController(text: _selectedCity),
              enabled: _selectedState != null,
              decoration: theme.searchDropdownDecoration(
                labelText: 'City',
                prefixIcon: Icons.location_city,
                context: context,
                hintText: 'Select City',
              ),
            ),
            displayAllSuggestionWhenTap: true,
            isMultiSelectDropdown: false,
            suggestionsCallback: (pattern) {
              if (_selectedState == null) return [];
              return _cities
                  .map((cityData) => cityData['city'] as String)
                  .where(
                    (city) =>
                        city.toLowerCase().contains(pattern.toLowerCase()),
                  )
                  .toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              setState(() {
                _selectedCity = suggestion;
              });
              _updateTowns(suggestion);
              widget.cityController.text = suggestion;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a city';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Town/District dropdown
          DropDownSearchField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: TextEditingController(text: _selectedTown),
              enabled: _selectedCity != null,

              decoration: theme.searchDropdownDecoration(
                labelText: 'Town/District',
                prefixIcon: Icons.location_on,
                context: context,
                hintText: 'Select Town/District',
              ),
            ),
            displayAllSuggestionWhenTap: true,
            isMultiSelectDropdown: false,
            suggestionsCallback: (pattern) {
              if (_selectedCity == null) return [];
              return _towns
                  .where(
                    (town) =>
                        town.toLowerCase().contains(pattern.toLowerCase()),
                  )
                  .toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(title: Text(suggestion));
            },
            onSuggestionSelected: (suggestion) {
              _setTown(suggestion);
              widget.districtController.text = suggestion;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a town/district';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Pincode field (at the bottom)
          TextFormField(
            controller: widget.pincodeController,
            keyboardType: TextInputType.number,
            decoration: theme.inputDecoration(
              labelText: 'Pincode',
              prefixIcon: Icons.pin_drop,
              context: context,
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Please enter Pincode'
                        : null,
          ),
        ],
      ),
    );
  }
}
