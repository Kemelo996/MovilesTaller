import 'dart:math';

/// Servicio simulado que imita una consulta a una API remota.
/// Usa [Future.delayed] para simular latencia de red (2–3 segundos).
class DataService {
  final Random _random = Random();

  /// Consulta simulada de datos de usuario.
  ///
  /// Retorna un [Map] con información si tiene éxito,
  /// o lanza una [Exception] aleatoriamente para demostrar manejo de errores.
  Future<Map<String, dynamic>> fetchUserData() async {
    print('[DataService] ▶ Iniciando consulta al servidor...');

    // Simula latencia de red entre 2 y 3 segundos
    final delay = Duration(seconds: 2 + _random.nextInt(2));
    print('[DataService] ⏳ Esperando ${delay.inSeconds}s (simulando red)...');

    await Future.delayed(delay);

    // Simula un 30% de probabilidad de error
    if (_random.nextDouble() < 0.3) {
      print('[DataService] ✗ Error: el servidor no respondió correctamente.');
      throw Exception('Error 503: Servicio no disponible. Intenta de nuevo.');
    }

    final result = {
      'id': _random.nextInt(9000) + 1000,
      'nombre': 'Estudiante Flutter',
      'asignatura': 'Programación Móvil',
      'nota': (3.0 + _random.nextDouble() * 2.0).toStringAsFixed(1),
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('[DataService] ✓ Datos recibidos: $result');
    return result;
  }
}