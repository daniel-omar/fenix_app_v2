import 'package:fenix_app_v2/features/orders/domain/entities/order.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/customer.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/document_type.dart';
import 'package:fenix_app_v2/features/orders/domain/entities/order_customer.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/customer_order_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/document_types_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/forms/customer_form_provider.dart';
import 'package:fenix_app_v2/features/orders/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fenix_app_v2/features/shared/shared.dart';
import 'package:go_router/go_router.dart';

class CustomerOrderScreen extends ConsumerStatefulWidget {
  final int idOrder;
  const CustomerOrderScreen({super.key, required this.idOrder});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerOrderScreen createState() => _CustomerOrderScreen();
}

class _CustomerOrderScreen extends ConsumerState<CustomerOrderScreen> {
  // void showSnackbar(BuildContext context) {
  //   ScaffoldMessenger.of(context).clearSnackBars();
  //   ScaffoldMessenger.of(context)
  //       .showSnackBar(const SnackBar(content: Text('Orden Actualizado')));
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Todo fino')));
  }

  @override
  Widget build(BuildContext context) {
    final customerState = ref.watch(customerOrderProvider(widget.idOrder));
    final documentTypes = ref.watch(documentTypesProvider);

    nextPage() {
      final customerForm =
          ref.watch(customerFormProvider(customerState.customer!));

      final customerOrder = CustomerOrder(
        idOrden: widget.idOrder,
        idTipoDocumento: customerForm.idTipoDocumento,
        numeroDocumento: customerForm.numeroDocumento.value,
        nombre: customerForm.nombre.value,
        apellidos: customerForm.apellidos.value,
        numeroTelefono: customerForm.numeroTelefono.value,
        numeroTelefono2: customerForm.numeroTelefono2.value,
        correo: customerForm.correo.value,
        parenteso: customerForm.parentesco.value,
      );

      ref
          .watch(orderProvider(widget.idOrder).notifier)
          .updateCustomerOrder(customerOrder);

      context.push('/customer_signature/${widget.idOrder}');
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Datos cliente'),
          actions: const [],
        ),
        body: customerState.isLoading
            ? const FullScreenLoader()
            : _CustomerOrderView(
                customer: customerState.customer!,
              ),
        floatingActionButton: customerState.isLoading
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  ref
                      .read(customerFormProvider(customerState.customer!)
                          .notifier)
                      .onFormSubmit()
                      .then((value) {
                    if (!value) return;
                    // ignore: use_build_context_synchronously
                    //showSnackbar(context);
                    nextPage();
                  });
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

class _CustomerOrderView extends ConsumerWidget {
  final Customer customer;

  const _CustomerOrderView({required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        Center(
          child: Text(
            "",
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        _CustomerOrderInformation(
          customer: customer,
        )
      ],
    );
  }
}

class _CustomerOrderInformation extends ConsumerWidget {
  final Customer? customer;
  const _CustomerOrderInformation({required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerForm = ref.watch(customerFormProvider(customer));
    final documentTypes = ref.watch(documentTypesProvider);

    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Nombre',
            initialValue: customerForm.nombre.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onNombreChanged,
            errorMessage: customerForm.nombre.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Apellidos',
            initialValue: customerForm.apellidos.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onApellidosChanged,
            errorMessage: customerForm.apellidos.errorMessage,
          ),
          const SizedBox(height: 10),
          if (!documentTypes.isLoading)
            DropdownTipoDocumento(
                documentTypes: documentTypes.documentTypes!,
                idTipoDocumento: customerForm.idTipoDocumento,
                onSelected: ref
                    .read(customerFormProvider(customer).notifier)
                    .onTipoDocumentoChanged,
                width: width),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Nro Documento',
            keyboardType: TextInputType.number,
            listTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            initialValue: customerForm.numeroDocumento.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onNumeroDocumentoChanged,
            errorMessage: customerForm.numeroDocumento.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Nro contacto',
            keyboardType: TextInputType.number,
            listTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            initialValue: customerForm.numeroTelefono.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onTelefonoChanged,
            errorMessage: customerForm.numeroTelefono.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Nro contacto emergencia',
            keyboardType: TextInputType.number,
            listTextInputFormatter: [FilteringTextInputFormatter.digitsOnly],
            initialValue: customerForm.numeroTelefono2.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onTelefono2Changed,
            //errorMessage: customerForm.numeroTelefono2.errorMessage,
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            isTopField: true,
            label: 'Correo',
            initialValue: customerForm.correo.value,
            onChanged: ref
                .read(customerFormProvider(customer).notifier)
                .onCorreoChanged,
            errorMessage: customerForm.correo.errorMessage,
          ),
          const SizedBox(height: 10),
          DropdownParentesco(
              onSelected: ref
                  .read(customerFormProvider(customer).notifier)
                  .onParentescoChanged,
              width: width,
              errorMessage: customerForm.parentesco.errorMessage),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DropdownTipoDocumento extends ConsumerWidget {
  void Function(int idTipoDocumento) onSelected;
  List<DocumentType> documentTypes;
  double? width;
  int? idTipoDocumento;
  String? errorMessage;

  DropdownTipoDocumento(
      {super.key,
      required this.documentTypes,
      required this.onSelected,
      required this.idTipoDocumento,
      this.width,
      this.errorMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownMenu<String>(
      label: const Text("Tipo Documento"),
      initialSelection: idTipoDocumento.toString(),
      width: width,
      onSelected: (String? value) {
        //print(value);
        onSelected(int.parse(value!));
      },
      dropdownMenuEntries: documentTypes
          .map<DropdownMenuEntry<String>>((DocumentType documentType) {
        return DropdownMenuEntry<String>(
            value: documentType.idTipoDocumento.toString(),
            label: documentType.nombreTipoDocumento);
      }).toList(),
      errorText: errorMessage,
    );
  }
}

// ignore: must_be_immutable
class DropdownParentesco extends ConsumerWidget {
  List<String> parentescos = [
    "Titular",
    "Esposo(a)",
    "Hermano(a)",
    "Padre/Madre",
    "Hijo(a)",
    "Otro"
  ];
  void Function(String parentesco) onSelected;
  double? width;
  String? errorMessage;

  DropdownParentesco(
      {super.key, required this.onSelected, this.width, this.errorMessage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownMenu<String>(
      label: const Text("Parentesco"),
      initialSelection: 0.toString(),
      width: width,
      onSelected: (String? value) {
        //print(value);
        onSelected(value!);
      },
      dropdownMenuEntries:
          parentescos.map<DropdownMenuEntry<String>>((String valor) {
        return DropdownMenuEntry<String>(value: valor, label: valor);
      }).toList(),
      errorText: errorMessage,
    );
  }
}
