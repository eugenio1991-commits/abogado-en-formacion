# Abogado en Formación

App móvil (Android y iPhone) con diccionario jurídico y leyes de Panamá para estudiantes de Derecho. Hecha con [Flutter](https://flutter.dev).

## Qué hace la versión 1

- **Diccionario:** términos jurídicos con definición, ejemplo y términos relacionados.
- **Leyes:** biblioteca agrupada por categoría, con la fuente oficial y la Gaceta de cada norma.
- **Buscar:** busca en el diccionario y en el texto de las leyes, sin importar tildes ni mayúsculas.
- **Favoritos:** guarda términos y artículos con la estrella (solo en el teléfono).
- Funciona sin internet, sigue el modo oscuro del teléfono y no recoge datos personales.

## Cómo está organizado

```
assets/datos/
  diccionario.json        términos del diccionario
  leyes/indice.json       lista de archivos de leyes que carga la app
  leyes/*.json            una ley por archivo (datos de origen + artículos)
lib/
  main.dart               arranque de la app
  app.dart                tema, colores y datos compartidos
  modelos/                cómo es un término, una ley y un artículo
  datos/                  carga del contenido, búsqueda, favoritos y separador de artículos
  pantallas/              cada pantalla de la app
tool/importar_ley.dart    convierte el texto de una ley en artículos
test/                     pruebas automáticas
```

## Primeros pasos en tu Mac

1. Instala Flutter siguiendo la [guía oficial para macOS](https://docs.flutter.dev/get-started/install/macos), incluyendo Android Studio y Xcode.
2. Abre una terminal en esta carpeta y ejecuta:
   ```
   flutter pub get
   flutter test
   ```
   Si todas las pruebas pasan, tu equipo está listo.
3. **Probar en tu Samsung:** activa las *Opciones de desarrollador* y la *Depuración USB* en el teléfono, conéctalo por cable y ejecuta `flutter run`.
4. **Probar como iPhone:** abre el simulador (`open -a Simulator`) y ejecuta `flutter run`.

## Cómo cargar el texto de una ley

Las leyes ya tienen su ficha (nombre, fuente, Gaceta), pero falta el texto. Para cargarlo:

1. Abre la fuente oficial indicada en `urlFuente` del archivo de la ley y copia el texto completo.
2. Pégalo en un archivo de texto, por ejemplo `textos/ley-350-2022.txt`.
3. Ejecuta:
   ```
   dart run tool/importar_ley.dart textos/ley-350-2022.txt assets/datos/leyes/ley-350-2022.json
   ```
4. Abre la app y compara varios artículos con el original. Si la ley tiene reformas, carga el texto con las reformas ya aplicadas y escribe la fecha en `vigenteAl` (formato AAAA-MM-DD).

Para agregar una ley nueva, copia uno de los archivos de `assets/datos/leyes/`, cambia sus datos y añade el nombre del archivo a `indice.json`.

## Reglas del contenido

- Leyes solo desde fuentes oficiales (Gaceta Oficial, Legispan, Órgano Judicial), sin alterar el texto y citando la fuente (artículo 13 de la Ley 64 de 2012).
- Las definiciones del diccionario son redacción propia. No copies definiciones de diccionarios o libros publicados.
- Antes de publicar, un abogado debe revisar las definiciones marcadas como "pendiente de revisión".

## Seguridad

- No guardes contraseñas ni claves dentro del código.
- La versión de publicación se compila con ofuscación:
  ```
  flutter build appbundle --obfuscate --split-debug-info=build/simbolos
  ```
- Guarda la llave de firma de Android (keystore) fuera de este repositorio y en dos lugares seguros.
