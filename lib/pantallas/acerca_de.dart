import 'package:flutter/material.dart';

/// Aviso legal y origen del contenido. Debe estar visible desde el día uno.
class PantallaAcercaDe extends StatelessWidget {
  const PantallaAcercaDe({super.key});

  @override
  Widget build(BuildContext context) {
    final estilos = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Abogado en Formación', style: estilos.headlineSmall),
          const SizedBox(height: 16),
          Text('Aviso importante', style: estilos.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Esta app es una herramienta de estudio. No es una publicación '
            'oficial ni una app del Gobierno de Panamá, y no sustituye la '
            'asesoría de un abogado. Consulte siempre el texto vigente en la '
            'Gaceta Oficial.',
          ),
          const SizedBox(height: 16),
          Text('Origen del contenido', style: estilos.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Las leyes se toman de fuentes oficiales (Gaceta Oficial Digital, '
            'Legispan de la Asamblea Nacional y Órgano Judicial). Cada ley '
            'indica su fuente y la Gaceta en la que se publicó. Los textos '
            'oficiales no están protegidos por derecho de autor (artículo 13 '
            'de la Ley 64 de 2012), con la obligación de respetarlos y citar '
            'la fuente.',
          ),
          const SizedBox(height: 8),
          const Text(
            'Las definiciones del diccionario son redacción propia de la app.',
          ),
          const SizedBox(height: 16),
          Text('Privacidad', style: estilos.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'La app no pide cuentas ni recoge datos personales. Los favoritos '
            'se guardan solo en este teléfono.',
          ),
        ],
      ),
    );
  }
}
