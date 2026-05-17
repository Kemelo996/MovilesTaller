import 'package:flutter/material.dart';
import '../models/universidad.dart';
import '../services/universidad_service.dart';
import 'university_form_screen.dart';

class UniversityListScreen extends StatelessWidget {
  const UniversityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = UniversidadService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universidades'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Universidad>>(
        stream: service.listar(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final universidades = snapshot.data ?? [];
          if (universidades.isEmpty) {
            return const Center(
              child: Text('No hay universidades registradas.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: universidades.length,
            itemBuilder: (context, index) {
              final u = universidades[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.school, color: Colors.indigo),
                  title: Text(u.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIT: ${u.nit}'),
                      Text('Dirección: ${u.direccion}'),
                      Text('Teléfono: ${u.telefono}'),
                      Text('Web: ${u.paginaWeb}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UniversityFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}