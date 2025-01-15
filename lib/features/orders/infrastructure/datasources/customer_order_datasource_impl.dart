import 'package:dio/dio.dart';
import 'package:fenix_app_v2/features/orders/domain/datasources/customer_order_datasource.dart';
import 'package:fenix_app_v2/features/orders/domain/domain.dart';
import 'package:fenix_app_v2/features/orders/infrastructure/infrastructure.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/entities/response_main.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/mappers/response_main_mapper.dart';
import 'package:fenix_app_v2/features/shared/infrastructure/providers/dio_client.dart';

class CustomerOrderDatasourceImpl extends CustomerOrderDatasource {
  late final dioClient = DioClient();

  CustomerOrderDatasourceImpl();

  @override
  Future<Customer> getCustomerByIdOrder(int idOrden) async {
    try {
      final response = await dioClient.dio
          .get('/orders/customer_order/getCustomerByIdOrder/$idOrden');

      ResponseMain responseMain =
          ResponseMainMapper.responseJsonToEntity(response.data);

      final customerResponse = responseMain.data[0];
      final customer =
          CustomerMapper.customerJsonToEntity(customerResponse["customer"]);
      return customer;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw OrderNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
