import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../domain/entities/entry.dart';

class EntryListTile extends StatelessWidget {
  const EntryListTile({
    super.key,
    required this.entry,
    this.onTap,
    this.onDelete,
  });

  final Entry entry;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColor().withOpacity(0.2),
          child: Icon(
            _getIcon(),
            color: _getColor(),
          ),
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_getSubtitle()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(entry.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: onDelete,
                color: Colors.grey,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getColor() {
    switch (entry.type) {
      case EntryType.feeding:
        return AppColors.feeding;
      case EntryType.diaper:
        return AppColors.diaper;
      case EntryType.sleep:
        return AppColors.sleep;
    }
  }

  IconData _getIcon() {
    switch (entry.type) {
      case EntryType.feeding:
        return Icons.restaurant;
      case EntryType.diaper:
        return Icons.baby_changing_station;
      case EntryType.sleep:
        return Icons.bedtime;
    }
  }

  String _getTitle() {
    switch (entry.type) {
      case EntryType.feeding:
        return _getFeedingTitle();
      case EntryType.diaper:
        return _getDiaperTitle();
      case EntryType.sleep:
        return 'Sleep';
    }
  }

  String _getFeedingTitle() {
    switch (entry.feedingType) {
      case FeedingType.breastLeft:
        return 'Breast (Left)';
      case FeedingType.breastRight:
        return 'Breast (Right)';
      case FeedingType.bottle:
        return 'Bottle';
      case FeedingType.formula:
        return 'Formula';
      case null:
        return 'Feeding';
    }
  }

  String _getDiaperTitle() {
    switch (entry.diaperType) {
      case DiaperType.wet:
        return 'Wet Diaper';
      case DiaperType.dirty:
        return 'Dirty Diaper';
      case DiaperType.both:
        return 'Wet & Dirty Diaper';
      case null:
        return 'Diaper Change';
    }
  }

  String _getSubtitle() {
    final parts = <String>[];

    switch (entry.type) {
      case EntryType.feeding:
        if (entry.amount != null) {
          parts.add('${entry.amount} oz');
        }
        if (entry.duration != null) {
          parts.add('${entry.duration} min');
        }
        break;
      case EntryType.diaper:
        // No additional details for diaper
        break;
      case EntryType.sleep:
        if (entry.endTime != null) {
          final duration = entry.sleepDuration;
          if (duration != null) {
            final hours = duration.inHours;
            final minutes = duration.inMinutes % 60;
            if (hours > 0) {
              parts.add('${hours}h ${minutes}m');
            } else {
              parts.add('${minutes}m');
            }
          }
        } else {
          parts.add('In progress...');
        }
        if (entry.quality != null) {
          parts.add(entry.quality!.name);
        }
        break;
    }

    if (entry.notes != null && entry.notes!.isNotEmpty) {
      parts.add(entry.notes!);
    }

    return parts.isEmpty ? 'Logged' : parts.join(' • ');
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
