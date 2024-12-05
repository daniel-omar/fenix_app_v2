import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:go_router/go_router.dart';

class OrderClientScreen extends ConsumerStatefulWidget {
  final int idOrder;
  const OrderClientScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _OrderClientScreen createState() => _OrderClientScreen();
}

class _OrderClientScreen extends ConsumerState<OrderClientScreen> {
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Orden Actualizado')));
  }

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
    final orderState = ref.watch(orderProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cliente'),
          actions: const [],
        ),
        body: orderState.isLoading
            ? const FullScreenLoader()
            : _OrderView(
                order: orderState.order!,
              ),
        floatingActionButton: orderState.isLoading
            ? null
            : (orderState.order!.estadoOrden.idEstadoOrden != 2
                ? null
                : FloatingActionButton.extended(
                    onPressed: () {
                      if (orderState.order == null) return;
                      context.push('/order_materials/${orderState.idOrden}');
                    },
                    label: const Text(
                      "Siguiente",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
      ),
    );
  }
}

class _OrderView extends ConsumerWidget {
  final Order order;

  const _OrderView({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetail = ref.watch(orderProvider);

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        Center(
          child: Text(
            productDetail.order!.numeroOrden,
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _OrderInformation(order: order),
      ],
    );
  }
}

class _OrderInformation extends ConsumerWidget {
  final Order order;
  const _OrderInformation({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 10),
          CustomProductField(
            readOnly: true,
            isTopField: true,
            label: 'Cliente',
            initialValue:
                "${order.cliente.nombreCliente} ${order.cliente.apellidoPaterno} ${order.cliente.apellidoMaterno}",
          ),
          const SizedBox(height: 10),
          CustomProductField(
            readOnly: true,
            isTopField: true,
            label: 'Actividad',
            initialValue: order.actividad.nombreActividad,
          ),
          const SizedBox(height: 10),
          CustomProductField(
            readOnly: true,
            isTopField: true,
            label: 'Estado',
            initialValue: order.estadoOrden.nombreEstado,
          )
        ],
      ),
    );
  }
}
