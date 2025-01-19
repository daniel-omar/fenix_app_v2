import 'dart:io';
import 'package:fenix_app_v2/features/home/home.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart' as domain;
import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:go_router/go_router.dart';

class OrderLiquidationScreen extends ConsumerStatefulWidget {
  final int idOrder;
  const OrderLiquidationScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _OrderLiquidationScreen createState() => _OrderLiquidationScreen();
}

class _OrderLiquidationScreen extends ConsumerState<OrderLiquidationScreen> {
  void showSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
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

    liquidateOrder() async {
      await ref.watch(orderProvider.notifier).liquidateOrder();

      if (!orderState.isSaving) {
        showSnackbar(context,
            "Ocurrio un problema al liquidar, comunicarse con el administrador");
        return false;
      }

      await ref.watch(orderProvider.notifier).clearData();
      await ref.watch(orderMaterialsSerialProvider.notifier).clearData();
      await ref.watch(orderMaterialsNotSerialProvider.notifier).clearData();

      showSnackbar(context, "Orden Liquidada");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    }

    Future<void> _dialogConfirmation(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Liquidar'),
            content: const Text('¿Estás seguro del liquidar la orden?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () =>
                    {Navigator.of(context).pop(), liquidateOrder()},
                child: const Text('Sí'),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle Liquidación'),
          actions: const [],
        ),
        body: orderState.isLoading
            ? const FullScreenLoader()
            : _OrderView(
                order: orderState.order!,
              ),
        floatingActionButton: orderState.isLoading
            ? null
            :  FloatingActionButton.extended(
                    onPressed: () async => {_dialogConfirmation(context)},
                    label: const Text(
                      "Liquidar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
      ),
    );
  }
}

class _OrderView extends ConsumerWidget {
  final Order order;

  const _OrderView({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    final textStyles = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Generales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              _OrderInformation(order: order),
              const SizedBox(height: 10),
              const Text(
                'Materiales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  //scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                            label: Text(
                              "Material",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            tooltip: "Descripción"),
                        DataColumn(
                            label: Text(
                              "Cantidad",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            tooltip: "Cantidad")
                      ],
                      rows: orderState.orderMaterials!
                          .map((orderMaterial) => DataRow(cells: [
                                DataCell(
                                  Text(orderMaterial.material!.nombreMaterial),
                                ),
                                DataCell(
                                  Text(orderMaterial.cantidad.toString()),
                                )
                              ]))
                          .toList()),
                ),
              ),
            ],
          ),
        ),
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
          CustomTextFormField(
            readOnly: true,
            isTopField: true,
            label: 'Cliente',
            initialValue:
                "${order.cliente.nombreCliente} ${order.cliente.apellidoPaterno} ${order.cliente.apellidoMaterno}",
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            readOnly: true,
            isTopField: true,
            label: 'Dirección',
            initialValue: order.direccion,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            readOnly: true,
            isTopField: true,
            label: 'Telefono',
            initialValue: order.cliente.numeroTelefono,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            readOnly: true,
            isTopField: true,
            label: 'Actividad',
            initialValue: order.actividad.nombreActividad,
          ),
          // const SizedBox(height: 10),
          // CustomTextFormField(
          //   readOnly: true,
          //   isTopField: true,
          //   keyboardType: TextInputType.datetime,
          //   label: 'Fecha programacion',
          //   initialValue: order.fechaProgramacion,
          // ),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final void Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final void Function(String selectedGender) onGenderChanged;

  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          onGenderChanged(newSelection.first);
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((image) {
        late ImageProvider imageProvider;
        if (image.startsWith('http')) {
          imageProvider = NetworkImage(image);
        } else {
          imageProvider = FileImage(File(image));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: imageProvider,
                placeholder:
                    const AssetImage('assets/loaders/bottle-loader.gif'),
              )),
        );
      }).toList(),
    );
  }
}

class _OrderMaterialItem extends ConsumerWidget {
  final domain.OrderMaterial orderMaterial;

  const _OrderMaterialItem({required this.orderMaterial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // ignore: unused_local_variable
    const TextStyle styleFieldValue = TextStyle(fontSize: 16);

    return Material(
      // color: Colors.amber,
      child: InkWell(
        onTap: () {
          //Navigator.of(context).pop(true);
          //Navigator.of(context).pushNamed(menu.rutaMenu);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
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
              CustomTextFormField(
                readOnly: true,
                isTopField: true,
                initialValue: orderMaterial.material?.nombreMaterial,
                width: 250,
              ),
              CustomTextFormField(
                readOnly: true,
                isTopField: true,
                initialValue: orderMaterial.cantidad.toString(),
                width: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
