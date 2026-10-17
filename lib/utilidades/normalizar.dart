const _sinTilde = {
  'á': 'a',
  'é': 'e',
  'í': 'i',
  'ó': 'o',
  'ú': 'u',
  'ü': 'u',
  'ñ': 'n',
};

/// Pasa a minúsculas y quita tildes, para que "abogacia" encuentre "Abogacía".
String normalizar(String texto) {
  final minusculas = texto.toLowerCase();
  final buffer = StringBuffer();
  for (final letra in minusculas.split('')) {
    buffer.write(_sinTilde[letra] ?? letra);
  }
  return buffer.toString();
}
