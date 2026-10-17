// Carga el texto de una ley en su archivo JSON de la app.
//
// Uso:
//   dart run tool/importar_ley.dart textos/ley-350-2022.txt assets/datos/leyes/ley-350-2022.json
//
// 1. Copia el texto completo de la ley desde la fuente oficial (Gaceta Oficial
//    o Legispan) y pégalo en un archivo .txt.
// 2. Ejecuta este comando: separa el texto en artículos y los guarda en el
//    archivo JSON de la ley, sin tocar el resto de datos (nombre, fuente...).
// 3. Revisa el resultado en la app: compara algunos artículos con el original.

import 'dart:convert';
import 'dart:io';

import 'package:abogado_en_formacion/datos/separador_articulos.dart';

void main(List<String> args) {
  if (args.length != 2) {
    stderr.writeln(
      'Uso: dart run tool/importar_ley.dart <texto.txt> <ley.json>',
    );
    exit(64);
  }

  final texto = File(args[0]).readAsStringSync();
  final archivoLey = File(args[1]);
  final ley = jsonDecode(archivoLey.readAsStringSync()) as Map<String, dynamic>;

  final articulos = separarArticulos(texto);
  if (articulos.isEmpty) {
    stderr.writeln(
      'No encontré ningún "Artículo N." en ${args[0]}. Revisa el texto.',
    );
    exit(1);
  }

  ley['articulos'] = articulos.map((a) => a.aJson()).toList();
  const formato = JsonEncoder.withIndent('  ');
  archivoLey.writeAsStringSync('${formato.convert(ley)}\n');

  stdout.writeln(
    'Listo: ${articulos.length} artículos guardados en ${args[1]} '
    '(del ${articulos.first.numero} al ${articulos.last.numero}).',
  );
}
