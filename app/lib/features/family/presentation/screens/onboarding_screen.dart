import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../providers/family_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _familyNameController = TextEditingController();
  final _childNameController = TextEditingController();
  DateTime _birthDate = DateTime.now();

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    String name = 'My';
    if (user != null) {
      name = user.displayName ?? user.email.split('@').first;
    }
    _familyNameController.text = "$name's Family";
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _childNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(familyControllerProvider.notifier).createFamilyWithChild(
          familyName: _familyNameController.text.trim(),
          childName: _childNameController.text.trim(),
          birthDate: _birthDate,
        );

    // Router will automatically redirect to dashboard when firestoreUserProvider
    // updates with the new familyIds. Give Firestore a moment to sync.
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        ref.invalidate(firestoreUserProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(familyControllerProvider);
    final isLoading = controllerState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Welcome!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's set up your family and add your first baby.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: Stepper(
                    currentStep: _currentStep,
                    onStepContinue: () {
                      if (_currentStep == 0) {
                        if (_familyNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a family name'),
                            ),
                          );
                          return;
                        }
                        setState(() => _currentStep = 1);
                      } else {
                        _submit();
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep--);
                      }
                    },
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            FilledButton(
                              onPressed:
                                  isLoading ? null : details.onStepContinue,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(_currentStep == 1
                                      ? 'Get Started'
                                      : 'Continue'),
                            ),
                            if (_currentStep > 0) ...[
                              const SizedBox(width: 12),
                              TextButton(
                                onPressed:
                                    isLoading ? null : details.onStepCancel,
                                child: const Text('Back'),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Family Name'),
                        subtitle: const Text('What should we call your family?'),
                        isActive: _currentStep >= 0,
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                        content: TextFormField(
                          controller: _familyNameController,
                          decoration: const InputDecoration(
                            labelText: 'Family Name',
                            hintText: "e.g., Smith Family",
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a family name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Step(
                        title: const Text('Add Your Baby'),
                        subtitle: const Text("Tell us about your little one"),
                        isActive: _currentStep >= 1,
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                        content: Column(
                          children: [
                            TextFormField(
                              controller: _childNameController,
                              decoration: const InputDecoration(
                                labelText: "Baby's Name",
                                hintText: 'e.g., Emma',
                                border: OutlineInputBorder(),
                              ),
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter your baby's name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Birth Date'),
                              subtitle: Text(
                                '${_birthDate.month}/${_birthDate.day}/${_birthDate.year}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: _selectDate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (controllerState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      controllerState.error.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
