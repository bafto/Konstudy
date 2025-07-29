import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:konstudy/provider/auth_provider.dart';

class VerificationCallBackPage extends ConsumerWidget {
  const VerificationCallBackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(authControllerProvider.notifier);

    Future.microtask(
      () => {
        if (context.mounted)
          {controller.handleVerificationCallBackAndRedirect(context)},
      },
    );

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
