import 'dart:async';
import 'package:flutter/material.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';
import 'package:souqe/constants/app_images.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late Timer _timer;
  int _start = 30;
  bool _isResendEnabled = false;

  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isResendEnabled = false;
    _start = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isResendEnabled = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOTP() {
    // Skip backend verification
    if (_otpController.text.length == 6) {
      Navigator.pushReplacementNamed(context, AppRoutes.medicalHistory);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit code'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.bagPhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay
          Container(color: AppColors.black40),

          // Content
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),

                    // Logo
                    Center(
                      child: Text(
                        'SOUQÉ',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          letterSpacing: 2,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // OTP container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white90,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Enter OTP',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'We’ve sent a 6-digit verification code to your phone.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Inter',
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // OTP input
                          TextFormField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              labelText: 'Enter OTP',
                              border: OutlineInputBorder(),
                              counterText: '',
                            ),
                            style: const TextStyle(
                              letterSpacing: 16,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Resend Code
                          Center(
                            child: _isResendEnabled
                                ? TextButton(
                                    onPressed: () {
                                      startTimer();
                                      // Skip resend logic for now
                                    },
                                    child: const Text(
                                      'Resend Code',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Resend available in $_start sec',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      color: AppColors.grey,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 24),

                          // Verify button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _verifyOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.white,
                                textStyle: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Verify'),
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
        ],
      ),
    );
  }
}
