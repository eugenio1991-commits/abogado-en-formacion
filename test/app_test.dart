import 'package:abogado_en_formacion/app.dart';
import 'package:abogado_en_formacion/datos/contenido.dart';
import 'package:abogado_en_formacion/datos/favoritos.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('recorrido básico: término, favorito y biblioteca', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final contenido = (await tester.runAsync(
      () => Contenido.cargar(rootBundle),
    ))!;
    final favoritos = Favoritos(await SharedPreferences.getInstance());

    await tester.pumpWidget(
      AppAbogado(contenido: contenido, favoritos: favoritos),
    );
    await tester.pumpAndSettle();

    // Abre un término y lo marca como favorito.
    await tester.tap(find.text('Abogado').first);
    await tester.pumpAndSettle();
    expect(find.text('Ver también'), findsOneWidget);
    await tester.tap(find.byTooltip('Agregar a favoritos'));
    await tester.pumpAndSettle();
    expect(favoritos.contiene(Favoritos.claveTermino('abogado')), isTrue);

    // Vuelve y revisa que aparece en Favoritos.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoritos').last);
    await tester.pumpAndSettle();
    expect(find.text('Abogado'), findsWidgets);

    // La biblioteca muestra la Ley 350.
    await tester.tap(find.text('Leyes').last);
    await tester.pumpAndSettle();
    expect(find.text('Ley 350 de 2022'), findsOneWidget);
    await tester.tap(find.text('Ley 350 de 2022'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Reformada por la Ley 500'), findsOneWidget);
  });
}
