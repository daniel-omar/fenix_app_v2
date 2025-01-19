import 'dart:typed_data';

import 'package:fenix_app_v2/features/orders/presentation/providers/forms/customer_signature_form_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:fenix_app_v2/features/shared/widgets/custom_text_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  bool esFirmado = false;
  Uint8List? exportedImage;
  late XFile file;

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

  void showSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  _changeHabilitado(bool esSeleccionado) {
    setState(() {
      esHabilitado = esSeleccionado;
    });
  }

  _changeFirmado(bool valor) async {
    exportedImage =
        await signatureController.toPngBytes(height: 1000, width: 1000);
    file = XFile.fromData(exportedImage!, name: "firma");

    setState(() {
      esFirmado = valor;
    });
  }

  _changeLimpiado() async {
    signatureController.clear();
    setState(() {
      esFirmado = false;
    });
  }

  void _openIconButtonPressed() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => InfoScreen(
        onChangeObservacion: ref
            .read(customerSignatureFormProvider.notifier)
            .onObservacionChanged,
      ),
    );
  }

  SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.red,
    exportBackgroundColor: Colors.yellowAccent,
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customerFormState = ref.watch(customerSignatureFormProvider);

    nextPage() {
      if (!esHabilitado) {
        showSnackbar(context, "Debe aceptar conformidad de la instalación");
        return false;
      }

      if (!customerFormState.isFormValid) {
        showSnackbar(context, "Debe completar la observación");
        return false;
      }

      if (!esFirmado) {
        showSnackbar(context, "Debe completar la firma del cliente");
        return false;
      }

      //var orderState = ref.watch(orderProvider);
      ref
          .watch(orderProvider.notifier)
          .updateTechnicalObservation(customerFormState.observacion.value);

      ref.watch(orderProvider.notifier).removeEvidences();
      ref.watch(orderProvider.notifier).addEvidence(file);

      context.push('/order_liquidation/${widget.idOrder}');
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Firma cliente'),
          actions: [
            IconButton(
              onPressed: () => {_openIconButtonPressed()},
              icon: const Icon(Icons.message_outlined),
            ),
          ],
        ),
        body: _SignatureView(
          controller: signatureController,
          onChanged: _changeHabilitado,
          onSigned: _changeFirmado,
          onCleaned: _changeLimpiado,
          esHabilitado: esHabilitado,
          esFirmado: esFirmado,
        ),
        floatingActionButton: FloatingActionButton.extended(
          disabledElevation: 10,
          onPressed: !esHabilitado
              ? null
              : () {
                  nextPage();
                },
          label: Text(
            "Siguiente",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: !esHabilitado ? Colors.white : colorScheme.secondary),
          ),
          backgroundColor:
              !esHabilitado ? Colors.grey : colorScheme.primaryFixed,
        ),
      ),
    );
  }
}

class _SignatureView extends ConsumerWidget {
  final void Function(bool value) onChanged;
  final void Function(bool value) onSigned;
  final void Function() onCleaned;

  bool esHabilitado;
  bool esFirmado;
  SignatureController controller;

  _SignatureView(
      {required this.onChanged,
      required this.onSigned,
      required this.onCleaned,
      this.esHabilitado = false,
      this.esFirmado = false,
      required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;

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
          absorbing: (!esHabilitado || esFirmado),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            esFirmado
                ? SizedBox(
                    width: 125,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CustomFilledButton(
                        text: "Nuevo",
                        buttonColor: Colors.red,
                        onPressed: esHabilitado ? onCleaned : null,
                        radius: const Radius.circular(10),
                      ),
                    ),
                  )
                : const SizedBox(),
            esFirmado
                ? const SizedBox()
                : SizedBox(
                    width: 125,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CustomFilledButton(
                        text: "Limpiar",
                        buttonColor: Colors.red,
                        onPressed: esHabilitado
                            ? () async => {controller.clear()}
                            : null,
                        radius: const Radius.circular(10),
                      ),
                    ),
                  ),
            esFirmado
                ? const SizedBox()
                : SizedBox(
                    width: 125,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CustomFilledButton(
                        text: "Ok",
                        buttonColor: Colors.blueAccent,
                        onPressed:
                            esHabilitado ? () async => {onSigned(true)} : null,
                      ),
                    ),
                  ),
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
              'de la atención requerida.\n'
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

class InfoScreen extends StatelessWidget {
  void Function(String value) onChangeObservacion;
  InfoScreen({super.key, required this.onChangeObservacion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Observación',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextArea(
              isTopField: true,
              label: '',
              minLine: 5,
              maxLine: null,
              onChanged: onChangeObservacion,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
