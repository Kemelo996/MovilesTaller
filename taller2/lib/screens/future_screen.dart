import 'package:flutter/material.dart';
import '../../services/data_service.dart';

/// Pantalla que demuestra el uso de [Future], [async] y [await].
///
/// Muestra tres estados claramente diferenciados en la UI:
/// - **Inicial**: instrucciones al usuario.
/// - **Cargando**: indicador de progreso mientras espera el Future.
/// - **Éxito**: muestra los datos recibidos.
/// - **Error**: muestra el mensaje de error con opción de reintentar.
class FutureScreen extends StatefulWidget {
  const FutureScreen({super.key});

  @override
  State<FutureScreen> createState() => _FutureScreenState();
}

/// Estados posibles de la consulta
enum _QueryState { idle, loading, success, error }

class _FutureScreenState extends State<FutureScreen> {
  final DataService _service = DataService();

  _QueryState _state = _QueryState.idle;
  Map<String, dynamic>? _data;
  String? _errorMessage;

  /// Inicia la consulta asíncrona usando async/await.
  /// El widget no se bloquea mientras espera: Flutter sigue renderizando.
  Future<void> _fetchData() async {
    setState(() {
      _state = _QueryState.loading;
      _data = null;
      _errorMessage = null;
    });

    print('[FutureScreen] → Antes de await: la UI sigue activa.');

    try {
      // await suspende esta función pero NO bloquea el hilo principal
      final result = await _service.fetchUserData();

      print('[FutureScreen] → Después de await: datos recibidos.');

      if (mounted) {
        setState(() {
          _data = result;
          _state = _QueryState.success;
        });
      }
    } catch (e) {
      print('[FutureScreen] → Después de await: ocurrió un error → $e');

      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _state = _QueryState.error;
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
          'Future / async / await',
          style: TextStyle(color: Color(0xFF3FB950), fontWeight: FontWeight.bold),
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
            _buildStateCard(),
            const SizedBox(height: 28),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStateCard() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor()),
        ),
        child: _buildStateContent(),
      ),
    );
  }

  Color _borderColor() {
    switch (_state) {
      case _QueryState.idle:
        return const Color(0xFF30363D);
      case _QueryState.loading:
        return const Color(0xFF1A73E8);
      case _QueryState.success:
        return const Color(0xFF3FB950);
      case _QueryState.error:
        return const Color(0xFFF85149);
    }
  }

  Widget _buildStateContent() {
    switch (_state) {
      case _QueryState.idle:
        return const _IdleContent();
      case _QueryState.loading:
        return const _LoadingContent();
      case _QueryState.success:
        return _SuccessContent(data: _data!);
      case _QueryState.error:
        return _ErrorContent(message: _errorMessage!);
    }
  }

  Widget _buildActionButton() {
    final bool isLoading = _state == _QueryState.loading;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _fetchData,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF238636),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF238636).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.cloud_download_outlined),
        label: Text(
          isLoading ? 'Consultando...' : (_state == _QueryState.error ? 'Reintentar' : 'Consultar datos'),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// Widgets de estado
// ──────────────────────────────────────────

class _IdleContent extends StatelessWidget {
  const _IdleContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.cloud_outlined, size: 64, color: Colors.white.withOpacity(0.2)),
        const SizedBox(height: 20),
        const Text(
          'Sin datos',
          style: TextStyle(color: Color(0xFF8B949E), fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Presiona el botón para iniciar\nla consulta asíncrona.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6E7681), fontSize: 14),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Cargando…',
          style: TextStyle(
            color: Color(0xFF58A6FF),
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Esperando respuesta del servidor\n(2–3 segundos simulados)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6E7681), fontSize: 13),
        ),
        const SizedBox(height: 16),
        const Text(
          '⚡ La UI sigue respondiendo mientras espera',
          style: TextStyle(
            color: Color(0xFF3FB950),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SuccessContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF3FB950), size: 22),
            const SizedBox(width: 8),
            const Text(
              'Éxito',
              style: TextStyle(
                color: Color(0xFF3FB950),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...data.entries.map((e) => _DataRow(key_: e.key, value: e.value.toString())),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  final String key_;
  final String value;
  const _DataRow({required this.key_, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              key_,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  const _ErrorContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFF85149), size: 64),
        const SizedBox(height: 16),
        const Text(
          'Error',
          style: TextStyle(
            color: Color(0xFFF85149),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF85149).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFFF7B72), fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Presiona "Reintentar" para volver a consultar.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6E7681), fontSize: 12),
        ),
      ],
    );
  }
}