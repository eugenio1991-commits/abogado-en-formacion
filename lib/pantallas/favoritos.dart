import 'package:flutter/material.dart';

import '../app.dart';
import 'biblioteca.dart' show abrirLey;
import 'diccionario.dart' show FilaTermino;

/// Términos y artículos marcados con la estrella.
class PantallaFavoritos extends StatelessWidget {
  const PantallaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = DatosApp.de(context);
    return ListenableBuilder(
      listenable: datos.favoritos,
      builder: (context, _) {
        final filas = <Widget>[];
        for (final clave in datos.favoritos.ids.toList()..sort()) {
          if (clave.startsWith('termino:')) {
            final t = datos.contenido.terminoPorId(clave.substring(8));
            if (t != null) filas.add(FilaTermino(t));
          } else if (clave.startsWith('articulo:')) {
            final partes = clave.substring(9).split('#');
            if (partes.length != 2) continue;
            final ley = datos.contenido.leyPorId(partes[0]);
            if (ley == null) continue;
            filas.add(
              ListTile(
                leading: const Icon(Icons.gavel_outlined),
                title: Text('${ley.nombre}, artículo ${partes[1]}'),
                onTap: () => abrirLey(context, ley, articulo: partes[1]),
              ),
            );
          }
        }

        if (filas.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Toca la estrella en un término o artículo para guardarlo aquí.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: filas.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, i) => filas[i],
        );
      },
    );
  }
}
