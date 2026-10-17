import 'package:flutter/material.dart';

import '../app.dart';
import '../datos/favoritos.dart';
import '../modelos/ley.dart';
import 'diccionario.dart' show BotonFavorito;

/// Biblioteca de leyes agrupadas por categoría.
class PantallaBiblioteca extends StatelessWidget {
  const PantallaBiblioteca({super.key});

  @override
  Widget build(BuildContext context) {
    final leyes = DatosApp.de(context).contenido.leyes;
    final porCategoria = <String, List<Ley>>{};
    for (final ley in leyes) {
      porCategoria.putIfAbsent(ley.categoria, () => []).add(ley);
    }

    return ListView(
      children: [
        for (final entrada in porCategoria.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              entrada.key,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          for (final ley in entrada.value)
            ListTile(
              title: Text(ley.nombre),
              subtitle: Text(ley.titulo),
              trailing: ley.tieneTexto
                  ? Text('${ley.articulos.length} art.')
                  : const Text('Sin texto'),
              onTap: () => abrirLey(context, ley),
            ),
        ],
      ],
    );
  }
}

void abrirLey(BuildContext context, Ley ley, {String? articulo}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PantallaLey(ley: ley, articuloInicial: articulo),
    ),
  );
}

/// Una ley: datos de origen arriba y sus artículos debajo.
class PantallaLey extends StatefulWidget {
  const PantallaLey({super.key, required this.ley, this.articuloInicial});

  final Ley ley;

  /// Número de artículo al que saltar al abrir (desde búsqueda o favoritos).
  final String? articuloInicial;

  @override
  State<PantallaLey> createState() => _PantallaLeyState();
}

class _PantallaLeyState extends State<PantallaLey> {
  final _claves = <String, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    for (final a in widget.ley.articulos) {
      _claves[a.numero] = GlobalKey();
    }
    final destino = widget.articuloInicial;
    if (destino != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _claves[destino]?.currentContext;
        if (ctx != null) Scrollable.ensureVisible(ctx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ley = widget.ley;
    // Column dentro de un scroll (no ListView) para poder saltar a cualquier
    // artículo con ensureVisible.
    return Scaffold(
      appBar: AppBar(title: Text(ley.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _FichaLey(ley: ley),
            if (!ley.tieneTexto)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'El texto de esta norma todavía no se ha cargado en la app. '
                  'Consúltalo en la fuente oficial indicada arriba.',
                ),
              ),
            for (final a in ley.articulos)
              TarjetaArticulo(
                key: _claves[a.numero],
                ley: ley,
                articulo: a,
                resaltado: a.numero == widget.articuloInicial,
              ),
          ],
        ),
      ),
    );
  }
}

class _FichaLey extends StatelessWidget {
  const _FichaLey({required this.ley});

  final Ley ley;

  @override
  Widget build(BuildContext context) {
    final estilos = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ley.titulo, style: estilos.titleMedium),
            const SizedBox(height: 8),
            Text('Fuente: ${ley.fuente}', style: estilos.bodySmall),
            if (ley.gaceta != null) Text(ley.gaceta!, style: estilos.bodySmall),
            if (ley.vigenteAl != null)
              Text(
                'Texto vigente al ${ley.vigenteAl}',
                style: estilos.bodySmall,
              ),
            if (ley.urlFuente != null) ...[
              const SizedBox(height: 4),
              SelectableText(ley.urlFuente!, style: estilos.bodySmall),
            ],
            if (ley.nota != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ley.nota!, style: estilos.bodyMedium)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Un artículo con su número, sección y estrella de favorito.
class TarjetaArticulo extends StatelessWidget {
  const TarjetaArticulo({
    super.key,
    required this.ley,
    required this.articulo,
    this.resaltado = false,
  });

  final Ley ley;
  final Articulo articulo;
  final bool resaltado;

  @override
  Widget build(BuildContext context) {
    final estilos = Theme.of(context).textTheme;
    final colores = Theme.of(context).colorScheme;
    return Container(
      color: resaltado ? colores.primaryContainer.withValues(alpha: 0.4) : null,
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (articulo.seccion != null)
            Text(articulo.seccion!, style: estilos.labelSmall),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Artículo ${articulo.numero}',
                  style: estilos.titleSmall,
                ),
              ),
              BotonFavorito(
                clave: Favoritos.claveArticulo(ley.id, articulo.numero),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SelectableText(articulo.texto, style: estilos.bodyLarge),
          ),
        ],
      ),
    );
  }
}
