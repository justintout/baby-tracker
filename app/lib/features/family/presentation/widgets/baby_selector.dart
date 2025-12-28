import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/route_names.dart';
import '../providers/family_provider.dart';

class BabySelector extends ConsumerWidget {
  const BabySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedChild = ref.watch(selectedChildProvider);
    final childrenAsync = ref.watch(childrenProvider);

    return childrenAsync.when(
      loading: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (children) {
        if (children.isEmpty || selectedChild == null) {
          return const SizedBox.shrink();
        }

        // If only one child, just show the name
        if (children.length == 1) {
          return GestureDetector(
            onTap: () => context.push(RouteNames.babyList),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.child_care,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedChild.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        }

        // Multiple children - show dropdown
        return PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'manage') {
              context.push(RouteNames.babyList);
            } else {
              ref.read(familyControllerProvider.notifier).selectChild(value);
            }
          },
          offset: const Offset(0, 40),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: selectedChild.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          selectedChild.photoURL!,
                          width: 28,
                          height: 28,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.child_care,
                        size: 16,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
              ),
              const SizedBox(width: 8),
              Text(
                selectedChild.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          itemBuilder: (context) => [
            ...children.map((child) => PopupMenuItem<String>(
                  value: child.id,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: child.id == selectedChild.id
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.child_care,
                          size: 14,
                          color: child.id == selectedChild.id
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(child.name)),
                      if (child.id == selectedChild.id)
                        Icon(
                          Icons.check,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                )),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'manage',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined),
                  SizedBox(width: 12),
                  Text('Manage Babies'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
