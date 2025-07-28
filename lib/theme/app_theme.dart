import 'package:flutter/material.dart';

class AppTheme {
  static ThemeStyle get style => ThemeStyle();

  // Define app-wide theme data
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF4A6572),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A6572),
        primary: const Color(0xFF4A6572),
        secondary: const Color(0xFF84A9AC),
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: ThemeStyle.iconColor),
        titleTextStyle: TextStyle(
          color: Color(0xFF4A6572),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF4A6572),
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A6572)),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

class ThemeStyle {
  // Gradients
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.grey[50]!, Colors.grey[100]!],
  );

  // Card Styles
  BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(cardBorderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 1,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Icon Styles
  BoxDecoration iconBoxDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).primaryColor.withOpacity(0.1),
    shape: BoxShape.circle,
  );

  // Text Styles
  TextStyle get titleStyle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF424242),
  );

  TextStyle get subtitleStyle => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF757575),
  );

  TextStyle headingStyle(BuildContext context) => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
  );

  TextStyle appBarTitleStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  TextStyle get buttonTextStyle => const TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  TextStyle linkStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).primaryColor,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // Common Dimensions
  static const double cardBorderRadius = 15.0;
  static const double defaultPadding = 24.0;
  static const double iconSize = 36.0;
  static const double buttonHeight = 50.0;
  static const double inputFieldHeight = 56.0;

  // Common Colors
  static const Color iconColor = Color(0xFF424242);
  static const Color primaryColor = Color(0xFF4A6572);
  static const Color secondaryColor = Color(0xFF84A9AC);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF424242);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Input Field Decoration
  InputDecoration inputDecoration({
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    BuildContext? context,
  }) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon, color: iconColor),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color:
              context != null ? Theme.of(context).primaryColor : primaryColor,
        ),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  // Button Styles
  ButtonStyle primaryButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, buttonHeight),
      );

  ButtonStyle secondaryButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        side: BorderSide(color: Theme.of(context).primaryColor),
        minimumSize: const Size(double.infinity, buttonHeight),
      );

  // AppBar Style
  AppBar buildAppBar(BuildContext context, String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      // Remove the custom leading builder to allow the default drawer icon
      // or modify it to properly open the drawer
      title: Text(title, style: appBarTitleStyle(context)),
      centerTitle: true,
    );
  }

  // Common Container Background
  Widget buildPageBackground({required Widget child}) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: SafeArea(
        child: Scaffold(backgroundColor: Colors.transparent, body: child),
      ),
    );
  }

  // Card with padding
  Widget buildCard({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      decoration: cardDecoration,
      padding: padding,
      child: child,
    );
  }

  // Loading indicator
  Widget loadingIndicator({Color? color}) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        strokeWidth: 2.0,
      ),
    );
  }

  // Divider with padding
  Widget buildDivider({double verticalPadding = 16.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: const Divider(color: dividerColor),
    );
  }

  // Dropdown Decoration
  InputDecoration dropdownDecoration({
    required String labelText,
    required IconData prefixIcon,
    BuildContext? context,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: iconColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color:
              context != null ? Theme.of(context).primaryColor : primaryColor,
        ),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
    );
  }

  // Search Dropdown Decoration
  InputDecoration searchDropdownDecoration({
    required String labelText,
    required IconData prefixIcon,
    BuildContext? context,
    String? hintText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: iconColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color:
              context != null ? Theme.of(context).primaryColor : primaryColor,
        ),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
  
  // Dropdown Button Style Properties
  Map<String, dynamic> dropdownButtonStyle(BuildContext context) => {
    'elevation': 3,
    'iconSize': 24.0,
    'style': TextStyle(
      color: textPrimaryColor,
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    'menuMaxHeight': 300.0,
    'dropdownColor': Colors.white,
  };

  // Dropdown Item Style
  TextStyle get dropdownItemStyle => const TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
    fontWeight: FontWeight.normal,
  );
}
