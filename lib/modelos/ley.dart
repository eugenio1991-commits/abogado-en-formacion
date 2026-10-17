/// Un artículo dentro de una ley.
class Articulo {
  const Articulo({required this.numero, required this.texto, this.seccion});

  /// Número tal como aparece en la ley: "1", "15-A", etc.
  final String numero;
  final String texto;

  /// Título o capítulo al que pertenece, si se conoce.
  final String? seccion;

  factory Articulo.desdeJson(Map<String, dynamic> json) {
    return Articulo(
      numero: json['numero'].toString(),
      texto: json['texto'] as String,
      seccion: json['seccion'] as String?,
    );
  }

  Map<String, dynamic> aJson() => {
    'numero': numero,
    if (seccion != null) 'seccion': seccion,
    'texto': texto,
  };
}

/// Una ley, código o reglamento con su información de origen.
class Ley {
  const Ley({
    required this.id,
    required this.nombre,
    required this.titulo,
    required this.categoria,
    required this.fuente,
    this.urlFuente,
    this.gaceta,
    this.vigenteAl,
    this.nota,
    this.articulos = const [],
  });

  final String id;

  /// Nombre corto: "Ley 350 de 2022".
  final String nombre;

  /// Título oficial: "Que regula el ejercicio de la abogacía en Panamá".
  final String titulo;

  /// Agrupa en la biblioteca: "Ejercicio de la abogacía", "Constitución", etc.
  final String categoria;

  /// Nombre de la fuente oficial (Gaceta Oficial, Legispan, Órgano Judicial).
  final String fuente;
  final String? urlFuente;

  /// Número y fecha de la Gaceta Oficial donde se publicó.
  final String? gaceta;

  /// Fecha hasta la que el texto incluye reformas (AAAA-MM-DD).
  final String? vigenteAl;

  /// Aviso importante: reformas, derogaciones, revisiones pendientes.
  final String? nota;
  final List<Articulo> articulos;

  bool get tieneTexto => articulos.isNotEmpty;

  factory Ley.desdeJson(Map<String, dynamic> json) {
    return Ley(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      titulo: json['titulo'] as String,
      categoria: json['categoria'] as String,
      fuente: json['fuente'] as String,
      urlFuente: json['urlFuente'] as String?,
      gaceta: json['gaceta'] as String?,
      vigenteAl: json['vigenteAl'] as String?,
      nota: json['nota'] as String?,
      articulos: (json['articulos'] as List<dynamic>? ?? [])
          .map((a) => Articulo.desdeJson(a as Map<String, dynamic>))
          .toList(),
    );
  }
}
