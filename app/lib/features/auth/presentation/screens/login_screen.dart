import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/email_input_form.dart';
import '../widgets/email_sent_view.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (authState) {
            AuthInitial() => const EmailInputForm(),
            AuthLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            AuthEmailSent(email: final email) => EmailSentView(email: email),
            AuthSuccess() => const Center(
                child: Text('Signed in! Redirecting...'),
              ),
            AuthError(message: final message) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(authControllerProvider.notifier).reset();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
