class OrderStatus {
  int idEstadoOrden;
  String nombreEstado;
  String? descripcionEstado;
  bool esActivo;

  OrderStatus({
    required this.idEstadoOrden,
    required this.nombreEstado,
    this.descripcionEstado,
    required this.esActivo,
  });

  Map<String, dynamic> toJson() => {
        "id_estado_orden": idEstadoOrden,
        "nombre_estado_orden": nombreEstado,
      };
}
