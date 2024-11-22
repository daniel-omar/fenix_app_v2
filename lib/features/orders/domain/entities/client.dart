class Client {
  int idCliente;
  String nombreCliente;
  String apellidoPaterno;
  String apellidoMaterno;

  Client({
    required this.idCliente,
    required this.nombreCliente,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
  });

  Map<String, dynamic> toJson() => {
        "id_cliente": idCliente,
        "nombre_cliente": nombreCliente,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
      };
}
