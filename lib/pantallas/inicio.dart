import 'package:flutter/material.dart';

import 'acerca_de.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'diccionario.dart';
import 'favoritos.dart';

/// Pantalla principal con las cuatro secciones en la barra inferior.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _seccion = 0;

  static const _titulos = ['Diccionario', 'Leyes', 'Buscar', 'Favoritos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_seccion]),
        actions: [
          IconButton(
            tooltip: 'Acerca de',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const PantallaAcercaDe())),
          ),
        ],
      ),
      body: IndexedStack(
        index: _seccion,
        children: const [
          PantallaDiccionario(),
          PantallaBiblioteca(),
          PantallaBuscar(),
          PantallaFavoritos(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seccion,
        onDestinationSelected: (i) => setState(() => _seccion = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Diccionario',
          ),
          NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel),
            label: 'Leyes',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
