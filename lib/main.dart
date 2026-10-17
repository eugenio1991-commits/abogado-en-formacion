import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'datos/contenido.dart';
import 'datos/favoritos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Todo el contenido viene dentro de la app: no se descarga nada de internet.
  final contenido = await Contenido.cargar();
  final favoritos = Favoritos(await SharedPreferences.getInstance());

  runApp(AppAbogado(contenido: contenido, favoritos: favoritos));
}
