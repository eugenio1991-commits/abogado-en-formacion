import 'package:flutter/material.dart';

import '../app.dart';
import '../datos/contenido.dart';
import 'biblioteca.dart' show abrirLey;
import 'diccionario.dart' show FilaTermino;

/// Búsqueda en todo el contenido: términos y artículos de leyes.
class PantallaBuscar extends StatefulWidget {
  const PantallaBuscar({super.key});

  @override
  State<PantallaBuscar> createState() => _PantallaBuscarState();
}

class _PantallaBuscarState extends State<PantallaBuscar> {
  String _consulta = '';

  @override
  Widget build(BuildContext context) {
    final resultados = DatosApp.de(context).contenido.buscar(_consulta);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            autofocus: false,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar en el diccionario y las leyes',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _consulta = v),
          ),
        ),
        Expanded(child: _lista(context, resultados)),
      ],
    );
  }

  Widget _lista(BuildContext context, List<ResultadoBusqueda> resultados) {
    if (_consulta.trim().length < 2) {
      return const Center(child: Text('Escribe al menos 2 letras.'));
    }
    if (resultados.isEmpty) {
      return const Center(child: Text('Sin resultados.'));
    }
    return ListView.separated(
      itemCount: resultados.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final r = resultados[i];
        if (r.termino != null) return FilaTermino(r.termino!);
        return ListTile(
          leading: const Icon(Icons.gavel_outlined),
          title: Text('${r.ley!.nombre}, artículo ${r.articulo!.numero}'),
          subtitle: Text(
            r.articulo!.texto,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => abrirLey(context, r.ley!, articulo: r.articulo!.numero),
        );
      },
    );
  }
}
