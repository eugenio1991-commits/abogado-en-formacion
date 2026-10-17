import 'package:flutter/material.dart';

import '../app.dart';
import '../datos/favoritos.dart';
import '../modelos/termino.dart';
import '../utilidades/normalizar.dart';

/// Lista de términos con un filtro rápido arriba.
class PantallaDiccionario extends StatefulWidget {
  const PantallaDiccionario({super.key});

  @override
  State<PantallaDiccionario> createState() => _PantallaDiccionarioState();
}

class _PantallaDiccionarioState extends State<PantallaDiccionario> {
  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    final terminos = DatosApp.de(context).contenido.terminos;
    final q = normalizar(_filtro.trim());
    final visibles = q.isEmpty
        ? terminos
        : terminos.where((t) => normalizar(t.termino).contains(q)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.filter_list),
              hintText: 'Filtrar términos',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _filtro = v),
          ),
        ),
        Expanded(
          child: visibles.isEmpty
              ? const Center(child: Text('Ningún término coincide.'))
              : ListView.separated(
                  itemCount: visibles.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) => FilaTermino(visibles[i]),
                ),
        ),
      ],
    );
  }
}

/// Una fila de término reutilizable en el diccionario, la búsqueda y favoritos.
class FilaTermino extends StatelessWidget {
  const FilaTermino(this.termino, {super.key});

  final Termino termino;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(termino.termino),
      subtitle: Text(
        termino.definicion,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => abrirTermino(context, termino),
    );
  }
}

void abrirTermino(BuildContext context, Termino termino) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => PantallaTermino(termino: termino)));
}

/// Detalle de un término: definición, ejemplo, términos relacionados y fuente.
class PantallaTermino extends StatelessWidget {
  const PantallaTermino({super.key, required this.termino});

  final Termino termino;

  @override
  Widget build(BuildContext context) {
    final datos = DatosApp.de(context);
    final estilos = Theme.of(context).textTheme;
    final clave = Favoritos.claveTermino(termino.id);
    final relacionados = termino.relacionados
        .map(datos.contenido.terminoPorId)
        .whereType<Termino>()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(termino.termino),
        actions: [BotonFavorito(clave: clave)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SelectableText(termino.definicion, style: estilos.bodyLarge),
          if (termino.ejemplo != null) ...[
            const SizedBox(height: 16),
            Text('Ejemplo', style: estilos.titleSmall),
            const SizedBox(height: 4),
            SelectableText(
              termino.ejemplo!,
              style: estilos.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          if (relacionados.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Ver también', style: estilos.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in relacionados)
                  ActionChip(
                    label: Text(r.termino),
                    onPressed: () => abrirTermino(context, r),
                  ),
              ],
            ),
          ],
          if (termino.fuente != null) ...[
            const SizedBox(height: 24),
            Text('Fuente: ${termino.fuente}', style: estilos.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Estrella para marcar o desmarcar un favorito.
class BotonFavorito extends StatelessWidget {
  const BotonFavorito({super.key, required this.clave});

  final String clave;

  @override
  Widget build(BuildContext context) {
    final favoritos = DatosApp.de(context).favoritos;
    return ListenableBuilder(
      listenable: favoritos,
      builder: (context, _) {
        final marcado = favoritos.contiene(clave);
        return IconButton(
          tooltip: marcado ? 'Quitar de favoritos' : 'Agregar a favoritos',
          icon: Icon(marcado ? Icons.star : Icons.star_border),
          onPressed: () => favoritos.alternar(clave),
        );
      },
    );
  }
}
