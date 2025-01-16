import 'dart:typed_data';

import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';

class CustomerSignatureScreen extends ConsumerStatefulWidget {
  final int idOrder;
  const CustomerSignatureScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerSignatureScreen createState() => _CustomerSignatureScreen();
}

class _CustomerSignatureScreen extends ConsumerState<CustomerSignatureScreen> {
  bool esHabilitado = false;

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

  _changeHabilitado(bool esSeleccionado) {
    setState(() {
      esHabilitado = esSeleccionado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Firma cliente'),
          actions: const [],
        ),
        body: _SignatureView(
          onChanged: _changeHabilitado,
          esHabilitado: esHabilitado,
        ),
        floatingActionButton: FloatingActionButton.extended(
          enableFeedback: true,
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
  final void Function(bool value) onChanged;
  final bool esHabilitado;

  const _SignatureView({required this.onChanged, this.esHabilitado = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    Uint8List? exportedImage;

    SignatureController controller = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.red,
      exportBackgroundColor: Colors.yellowAccent,
    );

    return ListView(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Center(child: Text('Conformidad del cliente')),
                checkColor: Colors.white,
                value: esHabilitado,
                onChanged: (bool? value) {
                  _dialogBuilder(context);
                },
                controlAffinity: ListTileControlAffinity.leading,
                //contentPadding: const EdgeInsets.all(0),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        AbsorbPointer(
          absorbing: false,
          child: Signature(
            controller: controller,
            width: 350,
            height: 200,
            backgroundColor: Colors.lightBlue[100]!,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: CustomFilledButton(
                text: "Limpiar",
                buttonColor: Colors.red,
                onPressed: () async => {controller.clear()},
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(5),
            //   child: CustomFilledButton(
            //     text: "Retroceder",
            //     buttonColor: const Color.fromARGB(255, 189, 177, 68),
            //     onPressed: () async => {controller.undo()},
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(5),
            //   child: CustomFilledButton(
            //     text: "Restaurar",
            //     buttonColor: Colors.blue,
            //     onPressed: () async => {controller.redo()},
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conformidad del cliente'),
          content: const Text(
              'Con la firma del presente documento el cliente manifiesta su conformidad\n'
              'de la atención requerida a Telefónica.\n'
              'En el caso de averías: Con la conformidad de la atención, el cliente\n'
              'manifiesta su conformidad con la solución anticipada del problema de\n'
              'calidad de su servicio y desiste de continuar el procedimiento de reclamo.'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () => {onChanged(false), Navigator.of(context).pop()},
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Conforme'),
              onPressed: () => {onChanged(true), Navigator.of(context).pop()},
            ),
          ],
        );
      },
    );
  }
}
