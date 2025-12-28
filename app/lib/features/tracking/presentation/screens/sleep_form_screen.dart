import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/entry.dart';
import '../providers/entry_provider.dart';

class SleepFormScreen extends ConsumerStatefulWidget {
  const SleepFormScreen({super.key});

  @override
  ConsumerState<SleepFormScreen> createState() => _SleepFormScreenState();
}

class _SleepFormScreenState extends ConsumerState<SleepFormScreen> {
  DateTime _startTime = DateTime.now();
  DateTime? _endTime;
  SleepQuality? _quality;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (time != null) {
      setState(() {
        _startTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          time.hour,
          time.minute,
        );
        // If end time is before start time, clear it
        if (_endTime != null && _endTime!.isBefore(_startTime)) {
          _endTime = null;
        }
      });
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime != null
          ? TimeOfDay.fromDateTime(_endTime!)
          : TimeOfDay.fromDateTime(_startTime.add(const Duration(hours: 1))),
    );
    if (time != null) {
      setState(() {
        _endTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          time.hour,
          time.minute,
        );
        // Handle case where end time wraps to next day
        if (_endTime!.isBefore(_startTime)) {
          _endTime = _endTime!.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _submit() async {
    final entry = await ref.read(entryControllerProvider.notifier).logSleep(
          startTime: _startTime,
          endTime: _endTime,
          quality: _quality,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
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
        title: const Text('Log Sleep'),
        backgroundColor: AppColors.sleep.withOpacity(0.1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Start time
          Text(
            'Start Time',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectStartTime,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.bedtime),
              ),
              child: Text(
                _formatTime(_startTime),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // End time
          Text(
            'End Time (optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Leave empty if still sleeping',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectEndTime,
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.wb_sunny),
                suffixIcon: _endTime != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _endTime = null),
                      )
                    : null,
              ),
              child: Text(
                _endTime != null ? _formatTime(_endTime!) : 'Still sleeping...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _endTime != null ? null : Colors.grey,
                    ),
              ),
            ),
          ),

          // Duration display
          if (_endTime != null) ...[
            const SizedBox(height: 8),
            Text(
              'Duration: ${_formatDuration(_endTime!.difference(_startTime))}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.sleep,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
          const SizedBox(height: 24),

          // Sleep quality
          Text(
            'Quality (optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Good'),
                selected: _quality == SleepQuality.good,
                onSelected: (_) =>
                    setState(() => _quality = SleepQuality.good),
                selectedColor: AppColors.sleep.withOpacity(0.3),
                avatar: _quality == SleepQuality.good
                    ? null
                    : const Icon(Icons.sentiment_satisfied, size: 18),
              ),
              ChoiceChip(
                label: const Text('Fair'),
                selected: _quality == SleepQuality.fair,
                onSelected: (_) =>
                    setState(() => _quality = SleepQuality.fair),
                selectedColor: AppColors.sleep.withOpacity(0.3),
                avatar: _quality == SleepQuality.fair
                    ? null
                    : const Icon(Icons.sentiment_neutral, size: 18),
              ),
              ChoiceChip(
                label: const Text('Poor'),
                selected: _quality == SleepQuality.poor,
                onSelected: (_) =>
                    setState(() => _quality = SleepQuality.poor),
                selectedColor: AppColors.sleep.withOpacity(0.3),
                avatar: _quality == SleepQuality.poor
                    ? null
                    : const Icon(Icons.sentiment_dissatisfied, size: 18),
              ),
            ],
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
              hintText: 'Any additional notes...',
            ),
          ),
          const SizedBox(height: 32),

          // Submit button
          FilledButton(
            onPressed: isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.sleep,
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
                : const Text('Save Sleep'),
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

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
