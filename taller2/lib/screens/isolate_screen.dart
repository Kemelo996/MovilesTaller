import 'dart:async';
import 'package:flutter/foundation.dart'; // compute()
import 'package:flutter/material.dart';

// ──────────────────────────────────────────
// Función CPU-bound (top-level, requerido por compute)
// ──────────────────────────────────────────

/// Función de nivel superior requerida por [compute].
/// En móvil/desktop corre en un Isolate real.
/// En web corre de forma asíncrona sin bloquear la UI.
Map<String, dynamic> _heavyComputation(int n) {
  print('[Isolate/compute] ★ Iniciando cálculo pesado con n=$n...');
  final stopwatch = Stopwatch()..start();

  int suma = 0;
  for (int i = 1; i <= n; i++) {
    suma += i;
  }

  stopwatch.stop();
  final elapsedMs = stopwatch.elapsedMilliseconds;
  print('[Isolate/compute] ★ Resultado: $suma en ${elapsedMs}ms');

  return {
    'resultado': suma,
    'n': n,
    'tiempoMs': elapsedMs,
  };
}

// ──────────────────────────────────────────
// Pantalla
// ──────────────────────────────────────────

/// Pantalla que demuestra tarea CPU-bound usando [compute].
///
/// [compute] es el wrapper oficial de Flutter sobre [Isolate.spawn].
/// - En **móvil / desktop**: ejecuta en un Isolate separado (hilo real).
/// - En **web**: ejecuta de forma asíncrona (Isolate no disponible en dart2js).
class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

enum _IsolateState { idle, running, done, error }

class _IsolateScreenState extends State<IsolateScreen> {
  _IsolateState _state = _IsolateState.idle;

  int? _resultado;
  int? _n;
  int? _tiempoMs;
  String? _error;

  final Stopwatch _uiStopwatch = Stopwatch();
  Timer? _uiTimer;
  int _uiElapsedMs = 0;

  static const int _nWeb    = 50000000;   // 50M en web
  static const int _nNative = 500000000;  // 500M en nativo

  int get _selectedN => kIsWeb ? _nWeb : _nNative;

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  Future<void> _runCompute() async {
    setState(() {
      _state = _IsolateState.running;
      _resultado = null;
      _tiempoMs = null;
      _error = null;
      _uiElapsedMs = 0;
    });

    _uiStopwatch.reset();
    _uiStopwatch.start();
    _uiTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() => _uiElapsedMs = _uiStopwatch.elapsedMilliseconds);
    });

    print('[IsolateScreen] → Lanzando compute() con n=$_selectedN...');
    print('[IsolateScreen] → Plataforma: ${kIsWeb ? "Web" : "Nativo"}');

    try {
      final result = await compute(_heavyComputation, _selectedN);

      _uiStopwatch.stop();
      _uiTimer?.cancel();

      print('[IsolateScreen] → Resultado recibido: $result');

      if (mounted) {
        setState(() {
          _resultado = result['resultado'] as int;
          _n = result['n'] as int;
          _tiempoMs = result['tiempoMs'] as int;
          _state = _IsolateState.done;
          _uiElapsedMs = _uiStopwatch.elapsedMilliseconds;
        });
      }
    } catch (e) {
      _uiStopwatch.stop();
      _uiTimer?.cancel();
      print('[IsolateScreen] → Error: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _state = _IsolateState.error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF58A6FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Isolate – Tarea Pesada',
          style: TextStyle(color: Color(0xFFD2A8FF), fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF30363D), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            Expanded(child: _buildResultCard()),
            const SizedBox(height: 20),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD2A8FF).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2A8FF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFD2A8FF), size: 16),
              SizedBox(width: 8),
              Text('¿Qué hace esta tarea?',
                  style: TextStyle(
                      color: Color(0xFFD2A8FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Suma los primeros ${_formatN(_selectedN)} números enteros usando compute().\n'
            '${kIsWeb ? "Web: corre async en el mismo hilo." : "Nativo: corre en un Isolate separado (hilo real)."}',
            style: const TextStyle(
                color: Color(0xFF8B949E), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: kIsWeb
                  ? const Color(0xFF1A73E8).withOpacity(0.2)
                  : const Color(0xFF3FB950).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              kIsWeb
                  ? '🌐  Flutter Web — compute() async'
                  : '📱  Nativo — Isolate.spawn real',
              style: TextStyle(
                color: kIsWeb
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF3FB950),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor()),
      ),
      child: _buildContent(),
    );
  }

  Color _borderColor() {
    switch (_state) {
      case _IsolateState.idle:    return const Color(0xFF30363D);
      case _IsolateState.running: return const Color(0xFFD2A8FF);
      case _IsolateState.done:    return const Color(0xFF3FB950);
      case _IsolateState.error:   return const Color(0xFFF85149);
    }
  }

  Widget _buildContent() {
    switch (_state) {
      case _IsolateState.idle:    return _buildIdle();
      case _IsolateState.running: return _buildRunning();
      case _IsolateState.done:    return _buildDone();
      case _IsolateState.error:   return _buildError();
    }
  }

  Widget _buildIdle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.memory_outlined, size: 64, color: Colors.white.withOpacity(0.15)),
        const SizedBox(height: 16),
        const Text('compute() inactivo',
            style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        const Text(
          'Presiona el botón para lanzar\nuna tarea de cálculo pesado.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6E7681), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRunning() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFD2A8FF)),
                backgroundColor: const Color(0xFFD2A8FF).withOpacity(0.1),
              ),
            ),
            const Icon(Icons.memory, color: Color(0xFFD2A8FF), size: 32),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Calculando…',
            style: TextStyle(
                color: Color(0xFFD2A8FF),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD2A8FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'UI activa: ${(_uiElapsedMs / 1000).toStringAsFixed(1)}s',
            style: const TextStyle(
              color: Color(0xFFD2A8FF),
              fontSize: 28,
              fontWeight: FontWeight.w300,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tiempo desde la perspectiva de la UI\n(hilo principal libre)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6E7681), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDone() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF3FB950), size: 22),
              SizedBox(width: 8),
              Text('Cálculo completado',
                  style: TextStyle(
                      color: Color(0xFF3FB950),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          _ResultRow(label: 'N', value: _formatN(_n!)),
          _ResultRow(
            label: 'Resultado',
            value: _resultado.toString().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]},',
            ),
          ),
          _ResultRow(label: 'Tiempo cálculo', value: '${_tiempoMs}ms'),
          _ResultRow(label: 'Tiempo UI total', value: '${_uiElapsedMs}ms'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3FB950).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: const Color(0xFF3FB950).withOpacity(0.3)),
            ),
            child: Text(
              '✓ La UI respondió durante todo el cálculo.\n'
              '✓ compute() usado (compatible web + nativo).\n'
              '✓ ${kIsWeb ? "Web: async en event loop." : "Nativo: Isolate separado (hilo real)."}',
              style: const TextStyle(
                  color: Color(0xFF3FB950), fontSize: 13, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFF85149), size: 56),
        const SizedBox(height: 12),
        const Text('Error',
            style: TextStyle(
                color: Color(0xFFF85149),
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(_error ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
      ],
    );
  }

  Widget _buildButton() {
    final bool isRunning = _state == _IsolateState.running;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isRunning ? null : _runCompute,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6E40C9),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF6E40C9).withOpacity(0.4),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: isRunning
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.memory_outlined),
        label: Text(
          isRunning ? 'Calculando…' : 'Lanzar tarea pesada',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  String _formatN(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style:
                    const TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFE6EDF3),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}