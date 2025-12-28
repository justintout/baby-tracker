import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';

class EmailSentView extends ConsumerWidget {
  const EmailSentView({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Icon(
          Icons.mark_email_read_outlined,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          "We've sent a magic link to",
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                'Click the link in your email to sign in. '
                'The link will expire in 1 hour.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () {
            ref.read(authControllerProvider.notifier).reset();
          },
          child: const Text('Use a different email'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            ref.read(authControllerProvider.notifier).sendSignInLink(email);
          },
          child: const Text('Resend email'),
        ),
        const SizedBox(height: 24),
        // Debug: Paste link for simulator testing
        TextButton.icon(
          onPressed: () async {
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            final link = data?.text;
            if (link != null && link.isNotEmpty) {
              ref.read(authControllerProvider.notifier).signInWithEmailLink(link);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No link in clipboard')),
                );
              }
            }
          },
          icon: const Icon(Icons.content_paste),
          label: const Text('Paste link from clipboard'),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
