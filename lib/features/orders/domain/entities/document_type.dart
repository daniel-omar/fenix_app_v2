class DocumentType {
  int idTipoDocumento;
  String nombreTipoDocumento;

  DocumentType({
    required this.idTipoDocumento,
    required this.nombreTipoDocumento,
  });

  Map<String, dynamic> toJson() => {
        "id_tipo_documento": idTipoDocumento,
        "nombre_tipo_documento": nombreTipoDocumento,
      };
}
