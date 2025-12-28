import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/entry.dart';
import '../providers/entry_provider.dart';

class FeedingFormScreen extends ConsumerStatefulWidget {
  const FeedingFormScreen({super.key});

  @override
  ConsumerState<FeedingFormScreen> createState() => _FeedingFormScreenState();
}

class _FeedingFormScreenState extends ConsumerState<FeedingFormScreen> {
  FeedingType _feedingType = FeedingType.bottle;
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _timestamp = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timestamp),
    );
    if (time != null) {
      setState(() {
        _timestamp = DateTime(
          _timestamp.year,
          _timestamp.month,
          _timestamp.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text);
    final duration = int.tryParse(_durationController.text);

    final entry = await ref.read(entryControllerProvider.notifier).logFeeding(
          feedingType: _feedingType,
          amount: amount,
          duration: duration,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          timestamp: _timestamp,
        );

    if (entry != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState = ref.watch(entryControllerProvider);
    final isLoading = controllerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Feeding'),
        backgroundColor: AppColors.feeding.withOpacity(0.1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Feeding type selector
          Text(
            'Type',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: FeedingType.values.map((type) {
              final isSelected = _feedingType == type;
              return ChoiceChip(
                label: Text(_feedingTypeLabel(type)),
                selected: isSelected,
                onSelected: (_) => setState(() => _feedingType = type),
                selectedColor: AppColors.feeding.withOpacity(0.3),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Time
          Text(
            'Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectTime,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              child: Text(
                _formatTime(_timestamp),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Amount (for bottle/formula)
          if (_feedingType == FeedingType.bottle ||
              _feedingType == FeedingType.formula) ...[
            Text(
              'Amount (oz)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 4',
                suffixText: 'oz',
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Duration (for breastfeeding)
          if (_feedingType == FeedingType.breastLeft ||
              _feedingType == FeedingType.breastRight) ...[
            Text(
              'Duration (minutes)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 15',
                suffixText: 'min',
              ),
            ),
            const SizedBox(height: 24),
          ],

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
              hintText: 'Any additional notes...',
            ),
          ),
          const SizedBox(height: 32),

          // Submit button
          FilledButton(
            onPressed: isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.feeding,
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
                : const Text('Save Feeding'),
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

  String _feedingTypeLabel(FeedingType type) {
    switch (type) {
      case FeedingType.breastLeft:
        return 'Breast (L)';
      case FeedingType.breastRight:
        return 'Breast (R)';
      case FeedingType.bottle:
        return 'Bottle';
      case FeedingType.formula:
        return 'Formula';
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
