import 'package:flutter/material.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/country_codes.dart';
import 'package:souqe/constants/app_routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  String countryCode = '+20';
  bool showCountryPicker = false;
  String searchQuery = '';
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  void _selectCountry(String code) {
    setState(() {
      countryCode = code;
      showCountryPicker = false;
      searchQuery = '';
    });
    FocusScope.of(context).requestFocus(_phoneFocusNode);
  }

  List<Map<String, String>> get filteredCountries {
    return CountryCodes.codes.where((country) {
      final name = country['name']?.toLowerCase() ?? '';
      final code = country['code']?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return name.contains(query) || code.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.bagPhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay color
          Container(
            color: AppColors.black40,
          ),

          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'STEP INTO A WORLD OF\nFLAVOR, FRESHNESS, AND\nENDLESS POSSIBILITIES!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: 'Montserrat',
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white90,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => showCountryPicker = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppColors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      countryCode,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.grey[800],
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: AppColors.grey[600],
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                focusNode: _phoneFocusNode,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Enter your phone number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: AppColors.grey.shade300),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Or Join with social media',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Facebook Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F2),
                              foregroundColor: AppColors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.facebook, size: 28),
                                SizedBox(width: 14),
                                Text('Sign in with Facebook'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Google Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: AppColors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.g_mobiledata, size: 28),
                                SizedBox(width: 14),
                                Text('Sign in with Google'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Sign up prompt
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontFamily: 'Inter'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.explore);
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Country Picker Modal
          if (showCountryPicker)
            GestureDetector(
              onTap: () => setState(() {
                showCountryPicker = false;
                searchQuery = '';
              }),
              child: Container(
                color: AppColors.black50,
                child: Center(
                  child: SingleChildScrollView(
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Select Country'),
                      content: SizedBox(
                        width: double.maxFinite,
                        height: 400,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Search country...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) =>
                                  setState(() => searchQuery = value),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredCountries.length,
                                itemBuilder: (context, index) {
                                  final country = filteredCountries[index];
                                  return ListTile(
                                    leading: Text(
                                      country['code']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    title: Text(country['name']!),
                                    onTap: () =>
                                        _selectCountry(country['code']!),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => setState(() {
                            showCountryPicker = false;
                            searchQuery = '';
                          }),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
