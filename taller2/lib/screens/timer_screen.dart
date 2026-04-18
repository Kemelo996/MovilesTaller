import 'dart:async';
import 'package:flutter/material.dart';

/// Pantalla del cronómetro usando [Timer] de dart:async.
///
/// Características:
/// - Actualiza cada 100 ms para mostrar centésimas de segundo.
/// - Botones: Iniciar / Pausar / Reanudar / Reiniciar.
/// - El [Timer] se **cancela** al pausar y al salir de la pantalla (dispose).
/// - Limpieza de recursos garantizada en [dispose].
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

enum _TimerState { idle, running, paused }

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  _TimerState _timerState = _TimerState.idle;

  // Tiempo acumulado en centésimas de segundo (1 tick = 100 ms)
  int _ticks = 0;

  // Registro de vueltas
  final List<String> _laps = [];

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    // ⚠️ Limpieza de recursos: cancelamos el timer al salir
    _timer?.cancel();
    _pulseController.dispose();
    print('[TimerScreen] Timer cancelado al salir de la pantalla.');
    super.dispose();
  }

  // ──────────────────────────────────────────
  // Control del cronómetro
  // ──────────────────────────────────────────

  void _start() {
    print('[TimerScreen] ▶ Iniciando cronómetro.');
    setState(() => _timerState = _TimerState.running);
    _pulseController.repeat(reverse: true);

    // Timer periódico cada 100 ms
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() => _ticks++);
    });
  }

  void _pause() {
    print('[TimerScreen] ⏸ Pausando cronómetro en ${_formatTime(_ticks)}.');
    _timer?.cancel(); // Cancelamos el timer para liberar recursos
    _timer = null;
    _pulseController.stop();
    setState(() => _timerState = _TimerState.paused);
  }

  void _resume() {
    print('[TimerScreen] ▶ Reanudando cronómetro desde ${_formatTime(_ticks)}.');
    setState(() => _timerState = _TimerState.running);
    _pulseController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() => _ticks++);
    });
  }

  void _reset() {
    print('[TimerScreen] ↺ Reiniciando cronómetro.');
    _timer?.cancel();
    _timer = null;
    _pulseController.stop();
    _pulseController.reset();
    setState(() {
      _ticks = 0;
      _timerState = _TimerState.idle;
      _laps.clear();
    });
  }

  void _addLap() {
    if (_timerState == _TimerState.running) {
      setState(() => _laps.insert(0, '${_laps.length + 1}  →  ${_formatTime(_ticks)}'));
    }
  }

  // ──────────────────────────────────────────
  // Formato de tiempo
  // ──────────────────────────────────────────

  /// Convierte ticks (centésimas) a formato MM:SS.cc
  String _formatTime(int ticks) {
    final int centesimas = ticks % 10;
    final int totalSeconds = ticks ~/ 10;
    final int seconds = totalSeconds % 60;
    final int minutes = totalSeconds ~/ 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}.'
        '$centesimas';
  }

  // ──────────────────────────────────────────
  // UI
  // ──────────────────────────────────────────

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
          'Timer – Cronómetro',
          style: TextStyle(color: Color(0xFFF78166), fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF30363D), height: 1),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 32),
          _buildDisplay(),
          const SizedBox(height: 32),
          _buildButtons(),
          const SizedBox(height: 24),
          _buildLapList(),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    final Color activeColor = _timerState == _TimerState.running
        ? const Color(0xFFF78166)
        : _timerState == _TimerState.paused
            ? const Color(0xFFD29922)
            : const Color(0xFF8B949E);

    return Center(
      child: Container(
        width: 280,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: activeColor.withOpacity(0.4), width: 2),
          color: activeColor.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: activeColor,
                fontSize: 52,
                fontWeight: FontWeight.w200,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
              child: Text(_formatTime(_ticks)),
            ),
            const SizedBox(height: 4),
            Text(
              _stateLabel(),
              style: TextStyle(
                color: activeColor.withOpacity(0.7),
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stateLabel() {
    switch (_timerState) {
      case _TimerState.idle:
        return 'LISTO';
      case _TimerState.running:
        return 'CORRIENDO';
      case _TimerState.paused:
        return 'PAUSADO';
    }
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Botón principal (Iniciar / Pausar / Reanudar)
          Expanded(
            flex: 2,
            child: _buildPrimaryButton(),
          ),
          const SizedBox(width: 12),
          // Botón secundario (Vuelta / Reiniciar)
          Expanded(
            child: _buildSecondaryButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    switch (_timerState) {
      case _TimerState.idle:
        return _ActionButton(
          label: 'Iniciar',
          icon: Icons.play_arrow_rounded,
          color: const Color(0xFF3FB950),
          onTap: _start,
        );
      case _TimerState.running:
        return _ActionButton(
          label: 'Pausar',
          icon: Icons.pause_rounded,
          color: const Color(0xFFD29922),
          onTap: _pause,
        );
      case _TimerState.paused:
        return _ActionButton(
          label: 'Reanudar',
          icon: Icons.play_arrow_rounded,
          color: const Color(0xFF3FB950),
          onTap: _resume,
        );
    }
  }

  Widget _buildSecondaryButton() {
    if (_timerState == _TimerState.running) {
      return _ActionButton(
        label: 'Vuelta',
        icon: Icons.flag_outlined,
        color: const Color(0xFF58A6FF),
        onTap: _addLap,
      );
    }
    return _ActionButton(
      label: 'Reiniciar',
      icon: Icons.replay_rounded,
      color: const Color(0xFFF85149),
      onTap: _reset,
    );
  }

  Widget _buildLapList() {
    if (_laps.isEmpty) return const SizedBox.shrink();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vueltas',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 13,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 14, color: Color(0xFF58A6FF)),
                      const SizedBox(width: 8),
                      Text(
                        _laps[i],
                        style: const TextStyle(
                          color: Color(0xFFE6EDF3),
                          fontSize: 14,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}