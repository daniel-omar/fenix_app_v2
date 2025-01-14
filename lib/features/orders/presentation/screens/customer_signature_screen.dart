import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

class CustomerSignatureScreen extends ConsumerStatefulWidget {
  final int idOrder;
  const CustomerSignatureScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerSignatureScreen createState() => _CustomerSignatureScreen();
}

class _CustomerSignatureScreen extends ConsumerState<CustomerSignatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(orderProvider.notifier).loadOrder(widget.idOrder);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Datos cliente'),
          actions: const [],
        ),
        body: const _SignatureView(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push('/order_materials/${1}');
          },
          label: const Text(
            "Siguiente",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _SignatureView extends ConsumerWidget {
  const _SignatureView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        Center(
          child: Text(
            "d",
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
