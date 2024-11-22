import 'package:fenix_app_v2/config/config.dart';
import 'package:fenix_app_v2/features/auth/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/products/domain/domain.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Product(
      idMaterial: json["id_material"],
      codigoMaterial: json["codigo_material"],
      nombreMaterial: json["nombre_material"],
      precio: json["precio"],
      esSeriado: json["es_seriado"],
      // images: List<String>.from(
      //   json['images'].map(
      //     (image) => image.startsWith('http')
      //       ? image
      //       : '${ Environment.apiUrl }/files/product/$image',
      //   )
      // ),
      user: UserMapper.userJsonToEntity(json['user']));
}
