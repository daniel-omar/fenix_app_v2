import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final clientFormProvider = StateNotifierProvider.autoDispose
    .family<ClientFormNotifier, ClientFormState, Client>((ref, client) {
  return ClientFormNotifier(
    client: client,
  );
});

class ClientFormNotifier extends StateNotifier<ClientFormState> {
  ClientFormNotifier({
    required Client client,
  }) : super(
          ClientFormState(
              idCliente: client.idCliente,
              idTipoDocumento: client.idTipoDocumento,
              numeroDocumento: Phone.dirty(client.numeroDocumento),
              nombre: Title.dirty(client.nombreCliente),
              apellidos: Title.dirty(client.apellidoPaterno),
              numeroTelefono: Phone.dirty(client.numeroTelefono),
              numeroTelefono2: Phone.dirty(''),
              correo: Email.dirty(client.correo),
              parentesco: ''),
        );

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    return true;
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Phone.dirty(state.numeroDocumento.value),
        Title.dirty(state.nombre.value),
        Title.dirty(state.apellidos.value),
        Phone.dirty(state.numeroTelefono.value),
        Email.dirty(state.correo.value),
      ]),
    );
  }

  void onNombreChanged(String value) {
    state = state.copyWith(
        nombre: Title.dirty(value),
        isFormValid: Formz.validate([
          Phone.dirty(state.numeroDocumento.value),
          Title.dirty(state.apellidos.value),
          Phone.dirty(state.numeroTelefono.value),
          Email.dirty(state.correo.value),
        ]));
  }

  void onApellidosChanged(String value) {
    state = state.copyWith(
        apellidos: Title.dirty(value),
        isFormValid: Formz.validate([
          Phone.dirty(state.numeroDocumento.value),
          Title.dirty(state.nombre.value),
          Phone.dirty(state.numeroTelefono.value),
          Email.dirty(state.correo.value),
        ]));
  }

  void onNumeroDocumentoChanged(String value) {
    state = state.copyWith(
        numeroDocumento: Phone.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombre.value),
          Title.dirty(state.apellidos.value),
          Phone.dirty(state.numeroTelefono.value),
          Email.dirty(state.correo.value),
        ]));
  }

  void onTelefonoChanged(String value) {
    state = state.copyWith(
        numeroTelefono: Phone.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombre.value),
          Title.dirty(state.apellidos.value),
          Phone.dirty(state.numeroDocumento.value),
          Email.dirty(state.correo.value),
        ]));
  }

  void onTelefono2Changed(String value) {
    state = state.copyWith(
        numeroTelefono2: Phone.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombre.value),
          Title.dirty(state.apellidos.value),
          Phone.dirty(state.numeroDocumento.value),
          Phone.dirty(state.numeroTelefono.value),
          Email.dirty(state.correo.value),
        ]));
  }

  void onCorreoChanged(String value) {
    state = state.copyWith(
        correo: Email.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombre.value),
          Title.dirty(state.apellidos.value),
          Phone.dirty(state.numeroDocumento.value),
          Phone.dirty(state.numeroTelefono.value),
        ]));
  }

  void onTipoDocumentoChanged(int idTipoDocumento) {
    state = state.copyWith(idTipoDocumento: idTipoDocumento);
  }

  void onParentescoChanged(String parenteso) {
    state = state.copyWith(parentesco: parenteso);
  }
}

class ClientFormState {
  final bool isFormValid;
  final int? idCliente;
  final int idTipoDocumento;
  final Phone numeroDocumento;
  final Title nombre;
  final Title apellidos;
  final Phone numeroTelefono;
  final Phone numeroTelefono2;
  final Email correo;
  final String parentesco;

  ClientFormState(
      {this.isFormValid = false,
      this.idCliente,
      this.idTipoDocumento = 0,
      this.numeroDocumento = const Phone.dirty(''),
      this.nombre = const Title.dirty(''),
      this.apellidos = const Title.dirty(''),
      this.numeroTelefono = const Phone.dirty(''),
      this.numeroTelefono2 = const Phone.dirty(''),
      this.correo = const Email.dirty(''),
      this.parentesco = ''});

  ClientFormState copyWith({
    bool? isFormValid,
    int? idCliente,
    int? idTipoDocumento,
    Phone? numeroDocumento,
    Title? nombre,
    Title? apellidos,
    Phone? numeroTelefono,
    Phone? numeroTelefono2,
    Email? correo,
    String? parentesco,
  }) =>
      ClientFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        idCliente: idCliente ?? this.idCliente,
        idTipoDocumento: idTipoDocumento ?? this.idTipoDocumento,
        numeroDocumento: numeroDocumento ?? this.numeroDocumento,
        nombre: nombre ?? this.nombre,
        apellidos: apellidos ?? this.apellidos,
        numeroTelefono: numeroTelefono ?? this.numeroTelefono,
        numeroTelefono2: numeroTelefono2 ?? this.numeroTelefono2,
        correo: correo ?? this.correo,
        parentesco: parentesco ?? this.parentesco,
      );
}
