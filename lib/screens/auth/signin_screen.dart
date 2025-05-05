import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/country_codes.dart';
import 'package:souqe/services/phone_auth.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final PhoneAuthService _authService = PhoneAuthService();

  String countryCode = '+20';
  bool _isLoading = false;

  String getFlagEmoji(String isoCountryCode) {
    if (isoCountryCode.length != 2) return '';
    return isoCountryCode
        .toUpperCase()
        .codeUnits
        .map((c) => String.fromCharCode(c + 127397))
        .join();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _startPhoneVerification() async {
    final rawInput = _phoneController.text.trim();
    final sanitized = rawInput.startsWith('0') ? rawInput.substring(1) : rawInput;
    final fullPhone = '$countryCode$sanitized';
    final name = _nameController.text.trim();

    if (sanitized.isEmpty || sanitized.length < 8) {
      _showSnackBar("Enter a valid phone number");
      return;
    }

    if (name.isEmpty) {
      _showSnackBar("Enter your name");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: fullPhone,
        userName: name,
        codeSent: (verificationId) {
          setState(() => _isLoading = false);
          Navigator.pushNamed(
            context,
            AppRoutes.login,
            arguments: {
              'verificationId': verificationId,
              'phone': fullPhone,
              'name': name,
            },
          );
        },
        verificationCompleted: (AuthCredential credential) async {
          try {
            final UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            if (userCredential.user != null) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
          } catch (e) {
            _showSnackBar("Verification failed: $e");
          }
        },
        onError: (error) {
          setState(() => _isLoading = false);
          _showSnackBar("Verification failed: $error");
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Error: $e");
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.bagPhoto,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: AppColors.black40),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  const Text(
                    'STEP INTO A WORLD OF\nFLAVOR, FRESHNESS, AND\nENDLESS POSSIBILITIES!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white90,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Log in or sign up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.white,
                              ),
                              child: DropdownButton<String>(
                                value: countryCode,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: CountryCodes.codes.map((c) {
                                  final flag = getFlagEmoji(c['iso'] ?? '');
                                  return DropdownMenuItem<String>(
                                    value: c['code'],
                                    child: Text('$flag ${c['code']}'),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => countryCode = value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: const TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: 'Mobile number',
                                  hintStyle: const TextStyle(
                                    color: AppColors.textMedium,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: AppColors.primaryDark,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text.rich(
                          TextSpan(
                            text: 'By proceeding, you agree to our ',
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(color: AppColors.primaryDark),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style: TextStyle(color: AppColors.primaryDark),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            color: AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _startPhoneVerification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login or Signup',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
