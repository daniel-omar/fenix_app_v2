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
  final int idOrden;

  const OrderMaterialScreen({super.key, required this.idOrden});

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
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
            "Debe seleccionar al menos 1 mataerial no seriado para liquidación.");
        return;
      }

      ref
          .watch(orderProvider.notifier)
          .addOrderMaterials(orderMaterialsSerial, orderMaterialsNotSerial);

      context.push('/order_client/${orderState.idOrden}');
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
            ? const FullScreenLoader()
            : TabBarView(
                controller: _tabController,
                children: <Widget>[
                  OrderMaterialSeriadoView(order: orderState.order!),
                  OrderMaterialNoSeriadoView(order: orderState.order!)
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

// class DropdownMenuCategoria extends ConsumerStatefulWidget {
//   final int? idCategoriaInitial;
//   final List<Domain.MaterialCategory> materialCategorys;
//   final void Function(int index, OrderMaterial orderMaterial) onSelected;
//   final double? width;
//   final int? index;

//   const DropdownMenuCategoria({
//     super.key,
//     required this.materialCategorys,
//     required this.onSelected,
//     this.idCategoriaInitial,
//     this.width,
//     this.index,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _DropdownMenuCategoriaState createState() => _DropdownMenuCategoriaState();
// }

// class _DropdownMenuCategoriaState extends ConsumerState<DropdownMenuCategoria> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       width: widget.width,
//       initialSelection: widget.idCategoriaInitial!.toString(),
//       onSelected: (String? value) {
//         //print(value);
//         widget.onSelected(
//             widget.index!,
//             OrderMaterial(
//                 idMaterial: 0, idCategoria: int.parse(value!), cantidad: 1));
//       },
//       dropdownMenuEntries: widget.materialCategorys
//           .map<DropdownMenuEntry<String>>(
//               (Domain.MaterialCategory materialCategory) {
//         return DropdownMenuEntry<String>(
//             value: materialCategory.idCategoria.toString(),
//             label: materialCategory.nombreCategoria);
//       }).toList(),
//     );
//   }
// }

// class DropdownMenuMaterial extends ConsumerStatefulWidget {
//   final int? idMaterialInitial;
//   final int idMaterialCategory;
//   final List<Domain.Material> materials;
//   final void Function(int index, OrderMaterial orderMaterial) onSelected;
//   final double? width;
//   final int? index;

//   const DropdownMenuMaterial({
//     super.key,
//     required this.materials,
//     this.idMaterialInitial,
//     required this.idMaterialCategory,
//     this.width,
//     required this.onSelected,
//     this.index,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _DropdownMenuMaterialState createState() => _DropdownMenuMaterialState();
// }

// class _DropdownMenuMaterialState extends ConsumerState<DropdownMenuMaterial> {
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   ref.read(materialCategoryProvider.notifier).loadMaterialCategorys();
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final materialCategoryState = ref.watch(materialCategoryProvider);

//     return DropdownMenu<String>(
//       initialSelection: widget.idMaterialInitial!.toString(),
//       width: widget.width,
//       onSelected: (String? value) {
//         //print(value);
//         widget.onSelected(
//             widget.index!,
//             OrderMaterial(
//                 idMaterial: int.parse(value!),
//                 idCategoria: widget.idMaterialCategory,
//                 cantidad: 1));
//       },
//       dropdownMenuEntries: widget.materials
//           .map<DropdownMenuEntry<String>>((Domain.Material material) {
//         return DropdownMenuEntry<String>(
//             value: material.idMaterial.toString(),
//             label: material.nombreMaterial);
//       }).toList(),
//     );
//   }
// }
