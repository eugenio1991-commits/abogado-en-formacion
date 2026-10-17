/// Un término del diccionario jurídico.
class Termino {
  const Termino({
    required this.id,
    required this.termino,
    required this.definicion,
    this.ejemplo,
    this.relacionados = const [],
    this.fuente,
  });

  final String id;
  final String termino;
  final String definicion;
  final String? ejemplo;
  final List<String> relacionados;

  /// De dónde sale la definición (por ejemplo, "Definición propia").
  final String? fuente;

  factory Termino.desdeJson(Map<String, dynamic> json) {
    return Termino(
      id: json['id'] as String,
      termino: json['termino'] as String,
      definicion: json['definicion'] as String,
      ejemplo: json['ejemplo'] as String?,
      relacionados: (json['relacionados'] as List<dynamic>? ?? [])
          .cast<String>(),
      fuente: json['fuente'] as String?,
    );
  }
}
