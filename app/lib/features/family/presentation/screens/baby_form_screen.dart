import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/child.dart';
import '../providers/family_provider.dart';

class BabyFormScreen extends ConsumerStatefulWidget {
  const BabyFormScreen({
    super.key,
    this.childId,
  });

  final String? childId;

  @override
  ConsumerState<BabyFormScreen> createState() => _BabyFormScreenState();
}

class _BabyFormScreenState extends ConsumerState<BabyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime _birthDate = DateTime.now();
  bool _isInitialized = false;

  bool get isEditing => widget.childId != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _initializeFromChild(Child child) {
    if (_isInitialized) return;
    _nameController.text = child.name;
    _birthDate = child.birthDate;
    _isInitialized = true;
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

    final family = ref.read(currentFamilyProvider);
    if (family == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No family found')),
      );
      return;
    }

    final controller = ref.read(familyControllerProvider.notifier);

    if (isEditing) {
      await controller.updateChild(
        familyId: family.id,
        childId: widget.childId!,
        name: _nameController.text.trim(),
        birthDate: _birthDate,
      );
    } else {
      await controller.addChild(
        familyId: family.id,
        name: _nameController.text.trim(),
        birthDate: _birthDate,
      );
    }

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(familyControllerProvider);
    final isLoading = controllerState.isLoading;

    // If editing, find the child and initialize form
    if (isEditing) {
      final children = ref.watch(childrenProvider).valueOrNull ?? [];
      final child = children.cast<Child?>().firstWhere(
            (c) => c?.id == widget.childId,
            orElse: () => null,
          );
      if (child != null) {
        _initializeFromChild(child);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Baby' : 'Add Baby'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Avatar placeholder
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.child_care,
                  size: 50,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Baby's Name",
                hintText: 'e.g., Emma',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter your baby's name";
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Birth date
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Birth Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${_birthDate.month}/${_birthDate.day}/${_birthDate.year}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _calculateAge(_birthDate),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),

            // Submit button
            FilledButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEditing ? 'Save Changes' : 'Add Baby'),
            ),

            if (controllerState.hasError) ...[
              const SizedBox(height: 16),
              Text(
                controllerState.error.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    final difference = now.difference(birthDate);

    if (difference.inDays < 0) {
      return 'Due in ${-difference.inDays} days';
    } else if (difference.inDays == 0) {
      return 'Born today!';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} old';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks week${weeks == 1 ? '' : 's'} old';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months month${months == 1 ? '' : 's'} old';
    } else {
      final years = difference.inDays ~/ 365;
      final months = (difference.inDays % 365) ~/ 30;
      if (months == 0) {
        return '$years year${years == 1 ? '' : 's'} old';
      }
      return '$years year${years == 1 ? '' : 's'}, $months month${months == 1 ? '' : 's'} old';
    }
  }
}
