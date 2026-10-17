import 'package:abogado_en_formacion/datos/separador_articulos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('separa artículos y asigna capítulos', () {
    const texto = '''
LEY N.º 1
(De 1 de enero de 2030)
Que es solo un ejemplo para las pruebas

Capítulo I
DISPOSICIONES GENERALES

Artículo 1. Primer artículo de prueba.

Artículo 2. Segundo artículo,
que ocupa dos líneas.

Capítulo II
De las sanciones

ARTÍCULO 3-A: Tercer artículo.
''';

    final articulos = separarArticulos(texto);

    expect(articulos.map((a) => a.numero), ['1', '2', '3-A']);
    expect(articulos[0].texto, 'Primer artículo de prueba.');
    expect(articulos[1].texto, 'Segundo artículo,\nque ocupa dos líneas.');
    expect(articulos[0].seccion, 'Capítulo I. DISPOSICIONES GENERALES');
    expect(articulos[1].seccion, 'Capítulo I. DISPOSICIONES GENERALES');
    expect(articulos[2].seccion, 'Capítulo II. De las sanciones');
  });

  test('una mención a "artículo" dentro del texto no corta el artículo', () {
    const texto =
        'Artículo 1. Se aplicará lo dispuesto en el artículo 5 de esta Ley.';
    final articulos = separarArticulos(texto);
    expect(articulos, hasLength(1));
    expect(articulos.single.texto, contains('artículo 5'));
  });

  test('texto sin artículos devuelve una lista vacía', () {
    expect(separarArticulos('Texto sin artículos'), isEmpty);
  });
}
