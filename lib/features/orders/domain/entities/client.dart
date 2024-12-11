class Client {
  int idCliente;
  int idTipoDocumento;
  String numeroDocumento;
  String nombreCliente;
  String apellidoPaterno;
  String apellidoMaterno;
  String numeroTelefono;
  String correo;

  Client({
    required this.idCliente,
    required this.idTipoDocumento,
    required this.numeroDocumento,
    required this.nombreCliente,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.numeroTelefono,
    required this.correo,
  });

  Map<String, dynamic> toJson() => {
        "id_cliente": idCliente,
        "id_tipo_documento": idTipoDocumento,
        "numero_documento": numeroDocumento,
        "nombre_cliente": nombreCliente,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "numero_telefono": numeroTelefono,
        "correo": correo,
      };
}
