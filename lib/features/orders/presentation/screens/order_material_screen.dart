import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/domain.dart' as Domain;
import 'package:fenix_app_v2/features/orders/domain/entities/order_material.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_category_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_categorys_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/material_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/materials_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_elevated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';

class OrderMaterialScreen extends ConsumerStatefulWidget {
  final int idOrden;

  const OrderMaterialScreen({super.key, required this.idOrden});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialScreen createState() => _OrderMaterialScreen();
}

class _OrderMaterialScreen extends ConsumerState<OrderMaterialScreen>
    with TickerProviderStateMixin {
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Orden Actualizado')));
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
                      if (orderState.order == null) return;
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

class OrderMaterialSeriadoView extends ConsumerStatefulWidget {
  final Domain.Order order;

  const OrderMaterialSeriadoView({required this.order});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialSeriadoView createState() => _OrderMaterialSeriadoView();
}

class _OrderMaterialSeriadoView
    extends ConsumerState<OrderMaterialSeriadoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(materialCategoryProvider.notifier).loadMaterialCategorys();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final materialCategorys = ref.watch(materialCategorysProvider);
    final materialCategory = ref.watch(materialCategoryProvider);
    final materials =
        ref.watch(materialsProvider(materialCategory.idMaterialCategory));
    final double width = MediaQuery.of(context).size.width;
    //final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(height: 10),
            if (!materialCategorys.isLoading)
              DropdownMenuCategoria(
                width: width / 2,
                idCategoriaInitial: 0,
                materialCategorys: materialCategorys.materialCategorys!,
                onSelected: ref
                    .read(materialCategoryProvider.notifier)
                    .onCategoryChanged,
              ),
            if (!materials.isLoading)
              DropdownMenuMaterial(
                width: width / 2,
                idMaterialInitial: 0,
                materials: materials.materials!,
                onSelected:
                    ref.read(materialProvider.notifier).onMaterialChanged,
              ),
            const SizedBox(height: 10),
            ...orderState.orderMaterials!.map((e) {
              return OrderMaterialSeriado(
                  orderMaterial: e,
                  index: orderState.orderMaterials!.indexOf(e));
            }),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomElevatedIconButton(
              icon: Icons.add_box,
              onPressed: () {
                ref.watch(orderProvider.notifier).addOrderMaterialSeriado();
              },
              text: "Agregar",
              buttonColor: Colors.greenAccent,
            ),
            CustomElevatedIconButton(
              icon: Icons.remove,
              onPressed: () {
                ref.watch(orderProvider.notifier).clearOrderMaterials(true);
              },
              text: "Limpiar",
              buttonColor: Colors.redAccent,
            ),
          ],
        )
      ],
    );
  }
}

class OrderMaterialSeriado extends ConsumerStatefulWidget {
  final OrderMaterial orderMaterial;
  final int index;
  const OrderMaterialSeriado(
      {required this.orderMaterial, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialSeriado createState() => _OrderMaterialSeriado();
}

class _OrderMaterialSeriado extends ConsumerState<OrderMaterialSeriado> {
  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final _orderMaterial = widget.orderMaterial;
    final _index = widget.index;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            // if (!materialCategorys.isLoading)
            //   DropdownMenuCategoria(
            //     width: width / 2,
            //     idCategoriaInitial: _orderMaterial.idCategoria,
            //     materialCategorys: materialCategorys.materialCategorys!,
            //     onSelected: ref.read(orderProvider.notifier).onChangedAnItem,
            //     index: _index,
            //   ),
            // if (!materials.isLoading)
            //   DropdownMenuMaterial(
            //     width: width / 2,
            //     idMaterialInitial: _orderMaterial.idMaterial,
            //     idMaterialCategory: _orderMaterial.idCategoria,
            //     materials: materials.materials!,
            //     onSelected: ref.read(orderProvider.notifier).onChangedAnItem,
            //     index: _index,
            //   )

            CustomTextFormField(
              label: "GG",
            )
          ],
        ),
        CustomElevatedIconButton(
          icon: Icons.remove_circle_rounded,
          onPressed: () {
            ref.watch(orderProvider.notifier).removeOrderMaterialAnItem(_index);
          },
          text: "",
          buttonColor: Colors.greenAccent,
        )
      ],
    );
  }
}

class OrderMaterialNoSeriadoView extends ConsumerStatefulWidget {
  final Domain.Order order;

  const OrderMaterialNoSeriadoView({required this.order});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialNoSeriadoView createState() => _OrderMaterialNoSeriadoView();
}

class _OrderMaterialNoSeriadoView
    extends ConsumerState<OrderMaterialNoSeriadoView> {
  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 10)
      ],
    );
  }
}

class DropdownMenuCategoria extends ConsumerStatefulWidget {
  final int? idCategoriaInitial;
  final List<Domain.MaterialCategory> materialCategorys;
  final void Function(int idMaterialCategory) onSelected;
  final double? width;

  const DropdownMenuCategoria(
      {super.key,
      required this.materialCategorys,
      required this.onSelected,
      this.idCategoriaInitial,
      this.width});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownMenuCategoriaState createState() => _DropdownMenuCategoriaState();
}

class _DropdownMenuCategoriaState extends ConsumerState<DropdownMenuCategoria> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: widget.width,
      initialSelection: widget.idCategoriaInitial!.toString(),
      onSelected: (String? value) {
        //print(value);
        widget.onSelected(int.parse(value!));
      },
      dropdownMenuEntries: widget.materialCategorys
          .map<DropdownMenuEntry<String>>(
              (Domain.MaterialCategory materialCategory) {
        return DropdownMenuEntry<String>(
            value: materialCategory.idCategoria.toString(),
            label: materialCategory.nombreCategoria);
      }).toList(),
    );
  }
}

class DropdownMenuMaterial extends ConsumerStatefulWidget {
  final int? idMaterialInitial;
  final List<Domain.Material> materials;
  final void Function(int idMaterial) onSelected;
  final double? width;

  const DropdownMenuMaterial({
    super.key,
    this.idMaterialInitial,
    required this.materials,
    this.width,
    required this.onSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DropdownMenuMaterialState createState() => _DropdownMenuMaterialState();
}

class _DropdownMenuMaterialState extends ConsumerState<DropdownMenuMaterial> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   ref.read(materialCategoryProvider.notifier).loadMaterialCategorys();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final materialCategoryState = ref.watch(materialCategoryProvider);

    return DropdownMenu<String>(
      initialSelection: widget.idMaterialInitial!.toString(),
      width: widget.width,
      onSelected: (String? value) {
        //print(value);
        widget.onSelected(int.parse(value!));
      },
      dropdownMenuEntries: widget.materials
          .map<DropdownMenuEntry<String>>((Domain.Material material) {
        return DropdownMenuEntry<String>(
            value: material.idMaterial.toString(),
            label: material.nombreMaterial);
      }).toList(),
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
