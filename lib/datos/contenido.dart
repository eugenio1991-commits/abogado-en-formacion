import 'dart:convert';

import 'package:flutter/services.dart';

import '../modelos/ley.dart';
import '../modelos/termino.dart';
import '../utilidades/normalizar.dart';

/// Resultado de una búsqueda: puede ser un término o un artículo de una ley.
class ResultadoBusqueda {
  const ResultadoBusqueda.termino(Termino this.termino)
    : ley = null,
      articulo = null;

  const ResultadoBusqueda.articulo(Ley this.ley, Articulo this.articulo)
    : termino = null;

  final Termino? termino;
  final Ley? ley;
  final Articulo? articulo;
}

/// Todo el contenido de la app: diccionario y leyes.
///
/// Se lee de archivos JSON dentro de la app (carpeta assets/datos), así que
/// funciona sin internet y no hay servidor que atacar.
class Contenido {
  Contenido({required this.terminos, required this.leyes});

  final List<Termino> terminos;
  final List<Ley> leyes;

  static const rutaDiccionario = 'assets/datos/diccionario.json';
  static const rutaIndiceLeyes = 'assets/datos/leyes/indice.json';

  /// Carga el contenido desde los archivos de la app.
  static Future<Contenido> cargar([AssetBundle? bundle]) async {
    final origen = bundle ?? rootBundle;

    final diccionario =
        jsonDecode(await origen.loadString(rutaDiccionario)) as List<dynamic>;
    final terminos =
        diccionario
            .map((t) => Termino.desdeJson(t as Map<String, dynamic>))
            .toList()
          ..sort(
            (a, b) => normalizar(a.termino).compareTo(normalizar(b.termino)),
          );

    final indice =
        jsonDecode(await origen.loadString(rutaIndiceLeyes)) as List<dynamic>;
    final leyes = <Ley>[];
    for (final archivo in indice.cast<String>()) {
      final json = jsonDecode(
        await origen.loadString('assets/datos/leyes/$archivo'),
      ) as Map<String, dynamic>;
      leyes.add(Ley.desdeJson(json));
    }

    return Contenido(terminos: terminos, leyes: leyes);
  }

  Termino? terminoPorId(String id) {
    for (final t in terminos) {
      if (t.id == id) return t;
    }
    return null;
  }

  Ley? leyPorId(String id) {
    for (final l in leyes) {
      if (l.id == id) return l;
    }
    return null;
  }

  /// Busca en términos (nombre y definición) y en el texto de los artículos.
  /// Primero salen los términos cuyo nombre coincide.
  List<ResultadoBusqueda> buscar(String consulta, {int limite = 100}) {
    final q = normalizar(consulta.trim());
    if (q.length < 2) return const [];

    final porNombre = <ResultadoBusqueda>[];
    final porDefinicion = <ResultadoBusqueda>[];
    for (final t in terminos) {
      if (normalizar(t.termino).contains(q)) {
        porNombre.add(ResultadoBusqueda.termino(t));
      } else if (normalizar(t.definicion).contains(q)) {
        porDefinicion.add(ResultadoBusqueda.termino(t));
      }
    }

    final articulos = <ResultadoBusqueda>[];
    for (final ley in leyes) {
      for (final a in ley.articulos) {
        if (normalizar(a.texto).contains(q)) {
          articulos.add(ResultadoBusqueda.articulo(ley, a));
        }
      }
    }

    return [...porNombre, ...porDefinicion, ...articulos].take(limite).toList();
  }
}
