import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/entities/order_material.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/orders/presentation/screens/order_material_non_serial_screen.dart';
import 'package:fenix_app_v2/features/orders/presentation/screens/order_material_serial_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:go_router/go_router.dart';

class OrderMaterialScreen extends ConsumerStatefulWidget {
  final int idOrder;

  const OrderMaterialScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialScreen createState() => _OrderMaterialScreen();
}

class _OrderMaterialScreen extends ConsumerState<OrderMaterialScreen>
    with TickerProviderStateMixin {
  void showSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   ref
    //       .read(orderMaterialsNotSerialProvider.notifier)
    //       .getOrderMaterialsGroup();
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider(widget.idOrder));

    final orderMaterialsSerialState = ref.watch(orderMaterialsSerialProvider);
    final orderMaterialsNotSerialState =
        ref.watch(orderMaterialsNotSerialProvider);

    nextPage() {
      List<OrderMaterial> orderMaterialsSerial =
          orderMaterialsSerialState.orderMaterialsSerial!;
      if (orderMaterialsSerial.isEmpty) {
        showSnackbar(context,
            "Debe agregar al menos 1 mataerial seriado para liquidación.");
        return;
      }

      List<OrderMaterial> orderMaterialsNotSerial = [];
      for (var orderMaterialGroupNotSerial
          in orderMaterialsNotSerialState.orderMaterialsGroupNotSerial!) {
        for (var orderMaterialNotSerial
            in orderMaterialGroupNotSerial.materials!) {
          if (orderMaterialNotSerial.esSeleccionado!) {
            orderMaterialsNotSerial.add(orderMaterialNotSerial);
          }
        }
      }
      if (orderMaterialsNotSerial.isEmpty) {
        showSnackbar(context,
            "Debe seleccionar al menos 1 material no seriado para liquidación.");
        return;
      }

      ref
          .watch(orderProvider(widget.idOrder).notifier)
          .addOrderMaterials(orderMaterialsSerial, orderMaterialsNotSerial);

      context.push('/order_customer/${orderState.idOrden}');
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle Orden'),
          bottom: TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            tabs: const <Widget>[
              Tab(
                text: 'Seriados',
                icon: Icon(Icons.flight),
              ),
              Tab(
                text: 'No seriados',
                icon: Icon(Icons.luggage),
              )
            ],
          ),
        ),
        body: orderState.isLoading
            ? const SizedBox(
                width: double.infinity, height: 60, child: FullScreenLoader())
            : TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  OrderMaterialSeriadoView(),
                  OrderMaterialNoSeriadoView()
                ],
              ),
        floatingActionButton: orderState.isLoading
            ? null
            : (orderState.order!.estadoOrden.idEstadoOrden != 2
                ? null
                : FloatingActionButton.extended(
                    onPressed: () {
                      nextPage();
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
