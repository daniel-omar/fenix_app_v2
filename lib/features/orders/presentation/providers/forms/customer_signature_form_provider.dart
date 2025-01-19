import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/inputs/inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final customerSignatureFormProvider = StateNotifierProvider.autoDispose<
    CustomerSignatureFormNotifier,
    CustomerSignatureFormState>((ref) {
  return CustomerSignatureFormNotifier();
});

class CustomerSignatureFormNotifier
    extends StateNotifier<CustomerSignatureFormState> {
  CustomerSignatureFormNotifier() : super(CustomerSignatureFormState());

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    return true;
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        // Title.dirty(state.firma.value),
        Title.dirty(state.observacion.value),
      ]),
    );
  }

  void onSignatureChanged(String value) {
    state = state.copyWith(firma: Title.dirty(value));
    _touchedEverything();
  }

  void onObservacionChanged(String value) {
    state = state.copyWith(observacion: Title.dirty(value));
    _touchedEverything();
  }
}

class CustomerSignatureFormState {
  final bool isFormValid;
  final Title firma;
  final Title observacion;

  CustomerSignatureFormState({
    this.isFormValid = false,
    this.firma = const Title.dirty(''),
    this.observacion = const Title.dirty(''),
  });

  CustomerSignatureFormState copyWith(
          {bool? isFormValid, Title? firma, Title? observacion}) =>
      CustomerSignatureFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        firma: firma ?? this.firma,
        observacion: observacion ?? this.observacion,
      );
}
