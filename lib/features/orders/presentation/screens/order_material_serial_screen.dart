import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/domain.dart' as Domain;
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_elevated_icon_button.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orderMaterialsState = ref.watch(orderMaterialsSerialProvider);
    final materialCategorys = ref.watch(materialCategorysProvider);
    final materialCategory = ref.watch(materialCategoryProvider);
    final materials =
        ref.watch(materialsProvider(materialCategory.idMaterialCategory));
    final material = ref.watch(materialProvider);
    final double width = MediaQuery.of(context).size.width;
    //final textStyles = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      if (!materialCategorys.isLoading)
                        DropdownMenuCategoria(
                          width: width / 2,
                          idCategoriaInitial:
                              materialCategory.idMaterialCategory,
                          materialCategorys:
                              materialCategorys.materialCategorys!,
                          onSelected: ref
                              .read(materialCategoryProvider.notifier)
                              .onCategoryChanged,
                        ),
                      const SizedBox(height: 10),
                      if (!materials.isLoading)
                        DropdownMenuMaterial(
                          width: width / 2,
                          idMaterialInitial: material.idMaterial,
                          materials: materials.materials!,
                          onSelected: ref
                              .read(materialProvider.notifier)
                              .onMaterialChanged,
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomElevatedIconButton(
                        icon: Icons.add_box,
                        onPressed: () {
                          ref
                              .watch(orderMaterialsSerialProvider.notifier)
                              .addOrderMaterialSeriado(material.material!,
                                  materialCategory.idMaterialCategory);
                        },
                        text: "Agregar",
                        buttonColor: colorScheme.primary,
                        textStyle: const TextStyle(color: Colors.white),
                        colorIcon: Colors.white,
                      ),
                      CustomElevatedIconButton(
                        icon: Icons.remove,
                        onPressed: () {
                          ref
                              .watch(orderMaterialsSerialProvider.notifier)
                              .clearOrderMaterials(true);
                        },
                        text: "Limpiar",
                        buttonColor: Colors.redAccent,
                        textStyle: const TextStyle(color: Colors.white),
                        colorIcon: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: orderMaterialsState.orderMaterialsSerial?.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final orderMaterial =
                        orderMaterialsState.orderMaterialsSerial![index];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: OrderMaterialSeriado(
                          key: ValueKey(
                              '${orderMaterial.idMaterial}-${orderMaterial.idCategoria}'),
                          orderMaterial: orderMaterial,
                          index: index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     CustomElevatedIconButton(
              //       icon: Icons.add_box,
              //       onPressed: () {
              //         ref
              //             .watch(orderMaterialsSerialProvider.notifier)
              //             .addOrderMaterialSeriado(material.material!,
              //                 materialCategory.idMaterialCategory);
              //       },
              //       text: "Agregar",
              //       buttonColor: colorScheme.primary,
              //       textStyle: const TextStyle(color: Colors.white),
              //       colorIcon: Colors.white,
              //     ),
              //     CustomElevatedIconButton(
              //       icon: Icons.remove,
              //       onPressed: () {
              //         ref
              //             .watch(orderMaterialsSerialProvider.notifier)
              //             .clearOrderMaterials(true);
              //       },
              //       text: "Limpiar",
              //       buttonColor: Colors.redAccent,
              //       textStyle: const TextStyle(color: Colors.white),
              //       colorIcon: Colors.white,
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class OrderMaterialSeriado extends ConsumerStatefulWidget {
  final Domain.OrderMaterial orderMaterial;
  final int index;
  const OrderMaterialSeriado(
      {super.key, required this.orderMaterial, required this.index});

  @override
  // ignore: library_private_types_in_public_api
  _OrderMaterialSeriado createState() => _OrderMaterialSeriado();
}

class _OrderMaterialSeriado extends ConsumerState<OrderMaterialSeriado> {
  TextEditingController textEditingController = TextEditingController();
  String serie = '';

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.orderMaterial.serie!;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _orderMaterial = widget.orderMaterial;
    final index = widget.index;
    // ignore: unused_local_variable
    const TextStyle styleFieldValue = TextStyle(fontSize: 16);

    // ignore: no_leading_underscores_for_local_identifiers
    void _changeSerie(String serie) {
      setState(() {
        textEditingController.text = serie;
        ref
            .watch(orderMaterialsSerialProvider.notifier)
            .updateOrderMaterialAnItem(index, serie);
      });
    }

    return Material(
      // color: Colors.amber,
      child: InkWell(
        onTap: () {
          //Navigator.of(context).pop(true);
          //Navigator.of(context).pushNamed(menu.rutaMenu);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(100),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x000005cc),
                    blurRadius: 20,
                    offset: Offset(10, 10))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      CustomTextFormField(
                        readOnly: true,
                        isTopField: true,
                        label: 'Material',
                        initialValue: _orderMaterial.material?.nombreMaterial,
                        width: 220,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Número de serie",
                    width: 220,
                    textEditingController: textEditingController,
                    onChanged: _changeSerie,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      onPressed: () async {
                        String? res = await SimpleBarcodeScanner.scanBarcode(
                          context,
                          barcodeAppBar: const BarcodeAppBar(
                            appBarTitle: 'Test',
                            centerTitle: false,
                            enableBackButton: true,
                            backButtonIcon: Icon(Icons.arrow_back_ios),
                          ),
                          isShowFlashIcon: true,
                          delayMillis: 100,
                          cameraFace: CameraFace.back,
                          scanFormat: ScanFormat.ONLY_BARCODE,
                        );
                        serie = res as String;
                        _changeSerie(serie);
                      },
                      child: const Text('Escanear'),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: CustomElevatedIconButton(
                      icon: Icons.remove_circle_rounded,
                      onPressed: () {
                        ref
                            .watch(orderMaterialsSerialProvider.notifier)
                            .removeOrderMaterialAnItem(index);
                      },
                      text: "Remover",
                      buttonColor: Colors.red.shade200,
                      radius: const Radius.circular(30),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
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
      label: const Text("Categoria"),
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
      label: const Text("Material"),
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
