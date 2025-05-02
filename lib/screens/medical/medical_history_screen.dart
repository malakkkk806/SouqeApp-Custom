import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:souqe/constants/app_images.dart';
import 'package:souqe/constants/colors.dart';
import 'package:souqe/constants/app_routes.dart';

class MedicalHistoryScreen extends StatefulWidget {
  const MedicalHistoryScreen({super.key});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  String? selectedAllergy;
  String? selectedCondition;

  final List<String> allergyOptions = [
    'Peanuts', 'Dairy', 'Seafood', 'Gluten', 'Eggs', 'Soy'
  ];

  final List<String> conditionOptions = [
    'Diabetes', 'Asthma', 'Hypertension', 'Heart Disease', 'Epilepsy'
  ];

  void _selectFromList(String title, List<String> options, Function(String) onSelected) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Select $title'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (_, index) => ListTile(
              title: Text(options[index]),
              onTap: () {
                onSelected(options[index]);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (selectedAllergy == null || selectedCondition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both fields')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('allergyWarning')
          .doc(user.uid)
          .set({
            'userID': user.uid,
            'email': user.email ?? '',
            'name': user.displayName ?? '',
            'phone': user.phoneNumber ?? '',
            'allergyStatus': selectedAllergy,
            'condition': selectedCondition,
          });

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.bagPhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(color: AppColors.black40),
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
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.warning_amber_outlined),
                            title: Text(selectedAllergy ?? 'Allergies'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _selectFromList('Allergy', allergyOptions, (value) {
                                setState(() {
                                  selectedAllergy = value;
                                });
                              });
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.health_and_safety),
                            title: Text(selectedCondition ?? 'Medical Conditions'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              _selectFromList('Medical Condition', conditionOptions, (value) {
                                setState(() {
                                  selectedCondition = value;
                                });
                              });
                            },
                          ),
                          const Divider(),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _saveToFirestore,
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
