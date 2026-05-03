import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Distribución v1.0.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
        '/detail': (context) => const DetailPage(),
      },
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA 1 – Home
// ─────────────────────────────────────────────
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.rocket_launch, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Hola!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ejemplo para distribucion de Apps con Firebase',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Botón → Detalle
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/detail'),
              icon: const Icon(Icons.list_alt),
              label: const Text('Ver Detalle'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),

            // Botón → Acerca de
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/about'),
              icon: const Icon(Icons.info_outline),
              label: const Text('Acerca de'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  static const List<Map<String, dynamic>> _items = [
    {'icon': Icons.looks_one, 'title': 'Paso 1', 'desc': 'flutter build apk'},
    {'icon': Icons.looks_two, 'title': 'Paso 2', 'desc': 'Subir APK a Firebase'},
    {'icon': Icons.looks_3, 'title': 'Paso 3', 'desc': 'Agregar testers al grupo QA_Clase'},
    {'icon': Icons.looks_4, 'title': 'Paso 4', 'desc': 'Distribuir y copiar enlace'},
    {'icon': Icons.looks_5, 'title': 'Paso 5', 'desc': 'Instalar en dispositivo físico'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasos de distribución'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: Icon(item['icon'] as IconData,
                color: Colors.deepPurple, size: 32),
            title: Text(item['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item['desc'] as String),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Volver'),
      ),
    );
  }
}


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.android, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mi App Flutter',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              const Chip(
                label: Text('Versión 1.0.0'),
                backgroundColor: Colors.deepPurple,
                labelStyle: TextStyle(color: Colors.white),
              ),
              // ────────────────────────────────────────

              const SizedBox(height: 16),
              const Text(
                'Para App distribution',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              _infoRow(Icons.person, 'Autor', 'Kevin Andres Montes Camelo'),
              _infoRow(Icons.school, 'Asignatura', 'ELECTIVA PROFESIONAL I'),
              _infoRow(Icons.calendar_today, 'Fecha', '02/05/2026'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}