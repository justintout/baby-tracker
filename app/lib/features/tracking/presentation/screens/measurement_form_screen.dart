import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/measurement_provider.dart';

class MeasurementFormScreen extends ConsumerStatefulWidget {
  const MeasurementFormScreen({super.key});

  @override
  ConsumerState<MeasurementFormScreen> createState() =>
      _MeasurementFormScreenState();
}

class _MeasurementFormScreenState extends ConsumerState<MeasurementFormScreen> {
  DateTime _date = DateTime.now();
  final _weightLbsController = TextEditingController();
  final _weightOzController = TextEditingController();
  final _heightFeetController = TextEditingController();
  final _heightInchesController = TextEditingController();
  final _headController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _weightLbsController.dispose();
    _weightOzController.dispose();
    _heightFeetController.dispose();
    _heightInchesController.dispose();
    _headController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _date = date);
    }
  }

  double? _parseWeight() {
    final lbs = int.tryParse(_weightLbsController.text) ?? 0;
    final oz = int.tryParse(_weightOzController.text) ?? 0;
    if (lbs == 0 && oz == 0) return null;
    return (lbs * 16 + oz).toDouble();
  }

  double? _parseHeight() {
    final feet = int.tryParse(_heightFeetController.text) ?? 0;
    final inches = double.tryParse(_heightInchesController.text) ?? 0;
    if (feet == 0 && inches == 0) return null;
    return feet * 12 + inches;
  }

  double? _parseHeadCircumference() {
    return double.tryParse(_headController.text);
  }

  Future<void> _submit() async {
    final weightOz = _parseWeight();
    final heightInches = _parseHeight();
    final headCircumference = _parseHeadCircumference();

    if (weightOz == null && heightInches == null && headCircumference == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least one measurement'),
        ),
      );
      return;
    }

    final measurement =
        await ref.read(measurementControllerProvider.notifier).logMeasurement(
              date: _date,
              weightOz: weightOz,
              heightInches: heightInches,
              headCircumferenceInches: headCircumference,
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            );

    if (measurement != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(measurementControllerProvider);
    final isLoading = controllerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Measurement'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date selector
          Text(
            'Date',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _formatDate(_date),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Weight
          Text(
            'Weight',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightLbsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'lbs',
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _weightOzController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'oz',
                    hintText: '0',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Height
          Text(
            'Height',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightFeetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ft',
                    hintText: '0',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _heightInchesController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'in',
                    hintText: '0',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Head circumference
          Text(
            'Head Circumference',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _headController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'inches',
              hintText: 'e.g., 14.5',
            ),
          ),
          const SizedBox(height: 24),

          // Notes
          Text(
            'Notes (optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Doctor visit, checkup notes...',
            ),
          ),
          const SizedBox(height: 32),

          // Submit button
          FilledButton(
            onPressed: isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Save Measurement'),
          ),

          if (controllerState.hasError) ...[
            const SizedBox(height: 16),
            Text(
              controllerState.error.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
