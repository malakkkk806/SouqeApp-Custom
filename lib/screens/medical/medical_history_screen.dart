import 'package:flutter/material.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _conditionsController = TextEditingController();

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
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
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 56),

                    const Text(
                      'SOUQÉ',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Your Medical Info',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Inter',
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white90,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _allergiesController,
                              decoration: const InputDecoration(
                                labelText: 'Allergies',
                                hintText: 'e.g. peanuts, dairy',
                                prefixIcon: Icon(Icons.warning_amber_outlined),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontFamily: 'Inter'),
                              ),
                              style: const TextStyle(fontFamily: 'Inter'),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _medicationsController,
                              decoration: const InputDecoration(
                                labelText: 'Current Medications',
                                hintText: 'e.g. insulin, paracetamol',
                                prefixIcon: Icon(Icons.medical_services),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontFamily: 'Inter'),
                              ),
                              style: const TextStyle(fontFamily: 'Inter'),
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _conditionsController,
                              decoration: const InputDecoration(
                                labelText: 'Medical Conditions',
                                hintText: 'e.g. diabetes, asthma',
                                prefixIcon: Icon(Icons.health_and_safety),
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(fontFamily: 'Inter'),
                              ),
                              style: const TextStyle(fontFamily: 'Inter'),
                            ),
                            const SizedBox(height: 24),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.home,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  textStyle: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text('Continue'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
