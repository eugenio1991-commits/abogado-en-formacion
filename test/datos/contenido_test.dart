import 'package:abogado_en_formacion/datos/contenido.dart';
import 'package:abogado_en_formacion/datos/favoritos.dart';
import 'package:abogado_en_formacion/modelos/ley.dart';
import 'package:abogado_en_formacion/modelos/termino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ley inventada solo para probar la búsqueda; no es contenido real.
final _leyDePrueba = Ley(
  id: 'ley-prueba',
  nombre: 'Ley de prueba',
  titulo: 'Solo para pruebas',
  categoria: 'Pruebas',
  fuente: 'Ninguna',
  articulos: const [
    Articulo(numero: '1', texto: 'Texto que menciona la idoneidad.'),
    Articulo(numero: '2', texto: 'Otro texto.'),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Contenido real de la app', () {
    late Contenido contenido;

    setUpAll(() async {
      contenido = await Contenido.cargar(rootBundle);
    });

    test('carga el diccionario ordenado y las leyes', () {
      expect(contenido.terminos, isNotEmpty);
      expect(contenido.leyes.map((l) => l.id), contains('ley-350-2022'));
      final nombres = contenido.terminos.map((t) => t.termino).toList();
      expect(nombres.first, 'Abogado');
    });

    test('los términos relacionados existen', () {
      for (final t in contenido.terminos) {
        for (final id in t.relacionados) {
          expect(
            contenido.terminoPorId(id),
            isNotNull,
            reason: '"${t.id}" apunta a "$id", que no existe',
          );
        }
      }
    });

    test('los identificadores no se repiten', () {
      final ids = contenido.terminos.map((t) => t.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });
  });

  group('Búsqueda', () {
    final contenido = Contenido(
      terminos: const [
        Termino(id: 'idoneidad', termino: 'Idoneidad', definicion: 'Permiso.'),
        Termino(
          id: 'abogado',
          termino: 'Abogado',
          definicion: 'Necesita idoneidad.',
        ),
      ],
      leyes: [_leyDePrueba],
    );

    test('no importan las tildes ni las mayúsculas', () {
      expect(contenido.buscar('IDONEIDAD'), isNotEmpty);
      expect(
        Contenido(
          terminos: const [
            Termino(id: 'x', termino: 'Abogacía', definicion: '.'),
          ],
          leyes: const [],
        ).buscar('abogacia'),
        hasLength(1),
      );
    });

    test('ordena: nombre, luego definición, luego artículos', () {
      final r = contenido.buscar('idoneidad');
      expect(r, hasLength(3));
      expect(r[0].termino?.id, 'idoneidad');
      expect(r[1].termino?.id, 'abogado');
      expect(r[2].articulo?.numero, '1');
    });

    test('menos de 2 letras no busca', () {
      expect(contenido.buscar('i'), isEmpty);
    });
  });

  test('los favoritos se guardan en el teléfono', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final favoritos = Favoritos(prefs);
    final clave = Favoritos.claveTermino('amparo');

    await favoritos.alternar(clave);
    expect(Favoritos(prefs).contiene(clave), isTrue);

    await favoritos.alternar(clave);
    expect(Favoritos(prefs).contiene(clave), isFalse);
  });
}
