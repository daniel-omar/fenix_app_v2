import 'dart:io';

import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';

class OrderScreen extends ConsumerWidget {
  final int idOrden;

  const OrderScreen({super.key, required this.idOrden});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Orden Actualizado')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider(idOrden));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle Orden'),
          actions: [
            IconButton(
              onPressed: () async {
                final photoPath =
                    await CameraGalleryServiceImpl().selectPhoto();
                if (photoPath == null) return;

                //codigo;
              },
              icon: const Icon(Icons.photo_library_outlined),
            ),
            IconButton(
              onPressed: () async {
                final photoPath = await CameraGalleryServiceImpl().takePhoto();
                if (photoPath == null) return;

                //codigo
              },
              icon: const Icon(Icons.camera_alt_outlined),
            )
          ],
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
                    },
                    label: const Text(
                      "Iniciar liquidación",
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
    final productDetail = ref.watch(orderProvider(order.idOrden));

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
