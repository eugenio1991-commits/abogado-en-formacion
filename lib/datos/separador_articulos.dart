import '../modelos/ley.dart';

/// Reconoce el inicio de un artículo: "Artículo 1.", "ARTÍCULO 15-A:",
/// "Artículo 3 (transitorio)." al comienzo de una línea.
final _inicioArticulo = RegExp(
  r'^[ \t]*art[íi]culo[ \t]+(\d+(?:[ \t]*-[ \t]*[A-Z])?)[ \t]*[.:\-–]?[ \t]*',
  caseSensitive: false,
  multiLine: true,
);

/// Reconoce títulos y capítulos: "Título I", "Capítulo II", "Sección 1".
final _encabezado = RegExp(
  r'^\s*(t[íi]tulo|cap[íi]tulo|secci[óo]n)\s+[IVXLCDM\d]+\b.*$',
  caseSensitive: false,
);

/// Busca un encabezado en un bloque de texto y devuelve el último que aparezca,
/// junto con la línea siguiente si es su nombre ("Capítulo I. De la idoneidad").
/// También devuelve el texto sin esas líneas.
({String? seccion, String resto}) _extraerEncabezado(String bloque) {
  final lineas = bloque.split('\n');
  final resto = <String>[];
  String? seccion;
  var esperandoNombre = false;

  for (final linea in lineas) {
    final limpia = linea.trim();
    if (_encabezado.hasMatch(limpia)) {
      seccion = limpia;
      esperandoNombre = true;
      continue;
    }
    if (esperandoNombre && limpia.isNotEmpty) {
      // La línea que sigue al encabezado es su nombre, si está en mayúsculas
      // o empieza con "De" / "Del" (estilo habitual de las leyes).
      if (limpia == limpia.toUpperCase() ||
          RegExp(r'^(De|Del)\s', caseSensitive: true).hasMatch(limpia)) {
        seccion = '$seccion. $limpia';
        esperandoNombre = false;
        continue;
      }
      esperandoNombre = false;
    }
    if (seccion == null || !esperandoNombre) resto.add(limpia);
  }
  return (seccion: seccion, resto: resto.join('\n'));
}

/// Convierte el texto plano de una ley (copiado de la Gaceta Oficial) en una
/// lista de artículos. El texto antes del primer artículo se ignora, salvo los
/// títulos o capítulos que contenga.
List<Articulo> separarArticulos(String texto) {
  final coincidencias = _inicioArticulo.allMatches(texto).toList();
  if (coincidencias.isEmpty) return const [];

  final articulos = <Articulo>[];
  String? seccionActual = _extraerEncabezado(
    texto.substring(0, coincidencias.first.start),
  ).seccion;

  for (var i = 0; i < coincidencias.length; i++) {
    final m = coincidencias[i];
    final fin = i + 1 < coincidencias.length
        ? coincidencias[i + 1].start
        : texto.length;
    final numero = m.group(1)!.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    // Si al final de este bloque empieza un capítulo nuevo, se separa del
    // texto del artículo y se aplica a los artículos siguientes.
    final bloque = _extraerEncabezado(texto.substring(m.end, fin));
    final cuerpo = bloque.resto.replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();

    articulos.add(
      Articulo(numero: numero, texto: cuerpo, seccion: seccionActual),
    );
    if (bloque.seccion != null) seccionActual = bloque.seccion;
  }

  return articulos;
}
