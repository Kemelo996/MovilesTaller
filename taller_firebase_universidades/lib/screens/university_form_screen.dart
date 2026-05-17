import 'package:flutter/material.dart';
import '../models/universidad.dart';
import '../services/universidad_service.dart';

class UniversityFormScreen extends StatefulWidget {
  const UniversityFormScreen({super.key});

  @override
  State<UniversityFormScreen> createState() => _UniversityFormScreenState();
}

class _UniversityFormScreenState extends State<UniversityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nitCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nitCtrl.dispose();
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _webCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await UniversidadService().crear(Universidad(
        nit: _nitCtrl.text.trim(),
        nombre: _nombreCtrl.text.trim(),
        direccion: _direccionCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim(),
        paginaWeb: _webCtrl.text.trim(),
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Universidad'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _campo(_nitCtrl, 'NIT', Icons.badge),
              _campo(_nombreCtrl, 'Nombre', Icons.school),
              _campo(_direccionCtrl, 'Dirección', Icons.location_on),
              _campo(_telefonoCtrl, 'Teléfono', Icons.phone),
              _campoWeb(_webCtrl),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _guardar,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_loading ? 'Guardando...' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'El campo $label es requerido' : null,
      ),
    );
  }

  Widget _campoWeb(TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        decoration: const InputDecoration(
          labelText: 'Página Web',
          prefixIcon: Icon(Icons.language),
          border: OutlineInputBorder(),
          hintText: 'https://www.ejemplo.edu.co',
        ),
        validator: (v) {
          if (v == null || v.trim().isEmpty) return 'La página web es requerida';
          final uri = Uri.tryParse(v.trim());
          if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
            return 'Ingresa una URL válida (ej: https://www.uceva.edu.co)';
          }
          return null;
        },
      ),
    );
  }
}