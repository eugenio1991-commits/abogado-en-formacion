import 'package:flutter/material.dart';

import 'datos/contenido.dart';
import 'datos/favoritos.dart';
import 'pantallas/inicio.dart';

/// Hace que el contenido y los favoritos estén disponibles en todas las
/// pantallas con `DatosApp.de(context)`.
class DatosApp extends InheritedWidget {
  const DatosApp({
    super.key,
    required this.contenido,
    required this.favoritos,
    required super.child,
  });

  final Contenido contenido;
  final Favoritos favoritos;

  static DatosApp de(BuildContext context) {
    final datos = context.dependOnInheritedWidgetOfExactType<DatosApp>();
    assert(datos != null, 'Falta DatosApp encima de este widget');
    return datos!;
  }

  @override
  bool updateShouldNotify(DatosApp oldWidget) =>
      contenido != oldWidget.contenido || favoritos != oldWidget.favoritos;
}

class AppAbogado extends StatelessWidget {
  const AppAbogado({
    super.key,
    required this.contenido,
    required this.favoritos,
  });

  final Contenido contenido;
  final Favoritos favoritos;

  // Azul marino, color clásico del mundo jurídico.
  static const _colorBase = Color(0xFF1F3A5F);

  @override
  Widget build(BuildContext context) {
    return DatosApp(
      contenido: contenido,
      favoritos: favoritos,
      child: MaterialApp(
        title: 'Abogado en Formación',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _colorBase),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: _colorBase,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        // Sigue el modo claro u oscuro del teléfono.
        themeMode: ThemeMode.system,
        home: const PantallaInicio(),
      ),
    );
  }
}
