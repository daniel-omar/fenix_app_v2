import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:fenix_app_v2/config/constants/environment.dart';
import 'package:fenix_app_v2/features/products/domain/domain.dart';
import 'package:fenix_app_v2/features/products/presentation/providers/providers.dart';
import 'package:fenix_app_v2/features/shared/shared.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>((ref, product) {
  // final createUpdateCallback = ref.watch( productsRepositoryProvider ).createUpdateProduct;
  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(
    product: product,
    onSubmitCallback: createUpdateCallback,
  );
});

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product,
  }) : super(ProductFormState(
            idMaterial: product.idMaterial,
            nombreMaterial: Title.dirty(product.nombreMaterial),
            codigoMaterial: Slug.dirty(product.codigoMaterial),
            precio: Price.dirty(product.precio),
            esSeriado: product.esSeriado,
            longitudSerie: product.longitudSerie,
            idCategoria: product.idCategoria));

  Future<bool> onFormSubmit() async {
    _touchedEverything();
    if (!state.isFormValid) return false;

    // TODO: regresar
    if (onSubmitCallback == null) return false;

    final productLike = {
      'nombre_material': state.nombreMaterial.value,
      'precio': state.precio.value,
      'codigo_material': state.codigoMaterial.value,
      'es_seriado': state.esSeriado,
      'longitud_serie': state.longitudSerie,
      'id_categoria_material': state.idCategoria,
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.nombreMaterial.value),
        Slug.dirty(state.codigoMaterial.value),
        Price.dirty(state.precio.value)
      ]),
    );
  }

  void onTitleChanged(String value) {
    state = state.copyWith(
        nombreMaterial: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.codigoMaterial.value),
          Price.dirty(state.precio.value)
        ]));
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(
        nombreMaterial: Title.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.codigoMaterial.value),
          Price.dirty(state.precio.value)
        ]));
  }

  void onSlugChanged(String value) {
    state = state.copyWith(
        codigoMaterial: Slug.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombreMaterial.value),
          Slug.dirty(value),
          Price.dirty(state.precio.value)
        ]));
  }

  void onPriceChanged(double value) {
    state = state.copyWith(
        precio: Price.dirty(value),
        isFormValid: Formz.validate([
          Title.dirty(state.nombreMaterial.value),
          Slug.dirty(state.codigoMaterial.value),
          Price.dirty(value)
        ]));
  }
}

class ProductFormState {
  final bool isFormValid;
  final int? idMaterial;
  final Title nombreMaterial;
  final Slug codigoMaterial;
  final Price precio;
  final bool esSeriado;
  int? longitudSerie;
  int? idCategoria;

  ProductFormState(
      {this.isFormValid = false,
      this.idMaterial,
      this.nombreMaterial = const Title.dirty(''),
      this.codigoMaterial = const Slug.dirty(''),
      this.precio = const Price.dirty(0),
      this.esSeriado = false,
      this.longitudSerie,
      this.idCategoria});

  ProductFormState copyWith(
          {bool? isFormValid,
          int? idMaterial,
          Title? nombreMaterial,
          Slug? codigoMaterial,
          Price? precio,
          bool? esSeriado,
          int? longitudSerie,
          int? idCategoria}) =>
      ProductFormState(
          isFormValid: isFormValid ?? this.isFormValid,
          idMaterial: idMaterial ?? this.idMaterial,
          nombreMaterial: nombreMaterial ?? this.nombreMaterial,
          codigoMaterial: codigoMaterial ?? this.codigoMaterial,
          precio: precio ?? this.precio,
          esSeriado: esSeriado ?? this.esSeriado,
          longitudSerie: longitudSerie ?? this.longitudSerie,
          idCategoria: idCategoria ?? this.idCategoria);
}
