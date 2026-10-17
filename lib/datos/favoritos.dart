import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guarda en el teléfono los términos y artículos marcados como favoritos.
///
/// Solo se guardan identificadores (por ejemplo "termino:amparo" o
/// "articulo:ley-350-2022#5"), nunca datos personales.
class Favoritos extends ChangeNotifier {
  Favoritos(this._prefs) : _ids = (_prefs.getStringList(_clave) ?? []).toSet();

  static const _clave = 'favoritos';

  final SharedPreferences _prefs;
  final Set<String> _ids;

  static String claveTermino(String id) => 'termino:$id';
  static String claveArticulo(String leyId, String numero) =>
      'articulo:$leyId#$numero';

  Set<String> get ids => Set.unmodifiable(_ids);

  bool contiene(String clave) => _ids.contains(clave);

  Future<void> alternar(String clave) async {
    if (!_ids.remove(clave)) _ids.add(clave);
    notifyListeners();
    await _prefs.setStringList(_clave, _ids.toList());
  }
}
