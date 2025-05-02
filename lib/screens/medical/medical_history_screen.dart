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
  List<String> selectedAllergies = [];
  List<String> selectedConditions = [];

  final List<String> allergyOptions = [
    'None', 'Peanuts', 'Dairy', 'Seafood', 'Gluten', 'Eggs', 'Soy'
  ];

  final List<String> conditionOptions = [
    'None', 'Diabetes', 'Asthma', 'Hypertension', 'Heart Disease', 'Epilepsy'
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _selectMultiple({
    required String title,
    required List<String> options,
    required List<String> selectedList,
    required Function(List<String>) onSelected,
  }) {
    List<String> tempSelection = List.from(selectedList);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.white90,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select $title',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (_, index) {
                          final option = options[index];
                          final selected = tempSelection.contains(option);

                          return CheckboxListTile(
                            value: selected,
                            activeColor: AppColors.primary,
                            checkColor: Colors.white,
                            title: Text(option, style: const TextStyle(fontFamily: 'Inter')),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            onChanged: (bool? value) {
                              setModalState(() {
                                if (option == 'None') {
                                  tempSelection = ['None'];
                                } else {
                                  tempSelection.remove('None');
                                  value!
                                      ? tempSelection.add(option)
                                      : tempSelection.remove(option);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(tempSelection);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter', color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackBar('User not logged in');
      return;
    }

    if (selectedAllergies.isEmpty || selectedConditions.isEmpty) {
      _showSnackBar('Please complete all fields');
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
        'allergyStatus': selectedAllergies,
        'condition': selectedConditions,
      });

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      _showSnackBar('Failed to save data: $e');
    }
  }

  Widget buildSelectableBox({
    required IconData icon,
    required String label,
    required List<String> selection,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          selection.isEmpty ? label : selection.join(', '),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.3,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white90,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        buildSelectableBox(
                          icon: Icons.warning_amber_outlined,
                          label: 'Allergies',
                          selection: selectedAllergies,
                          onTap: () {
                            _selectMultiple(
                              title: 'Allergies',
                              options: allergyOptions,
                              selectedList: selectedAllergies,
                              onSelected: (value) =>
                                  setState(() => selectedAllergies = value),
                            );
                          },
                        ),
                        buildSelectableBox(
                          icon: Icons.health_and_safety,
                          label: 'Medical Conditions',
                          selection: selectedConditions,
                          onTap: () {
                            _selectMultiple(
                              title: 'Medical Conditions',
                              options: conditionOptions,
                              selectedList: selectedConditions,
                              onSelected: (value) =>
                                  setState(() => selectedConditions = value),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveToFirestore,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Continue',
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
