import 'package:flutter/material.dart' show AppBar, Border, BorderRadius, BoxDecoration, Brightness, BuildContext, Color, ColorScheme, Column, Container, CrossAxisAlignment, EdgeInsets, Expanded, FontWeight, Icon, IconData, Icons, InkWell, Material, MaterialApp, MaterialPageRoute, Navigator, Padding, PreferredSize, Row, Scaffold, Size, SizedBox, StatelessWidget, Text, TextStyle, ThemeData, VoidCallback, Widget, runApp;
import 'screens/future_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/isolate_screen.dart';

void main() {
  runApp(const TallerApp());
}

class TallerApp extends StatelessWidget {
  const TallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Segundo Plano',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'monospace',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text(
          'Taller: Segundo Plano',
          style: TextStyle(
            color: Color(0xFF58A6FF),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFF30363D), height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Selecciona un módulo:',
              style: TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 14,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 24),
            _ModuleCard(
              icon: Icons.cloud_download_outlined,
              title: 'Future / async / await',
              subtitle: 'Consulta simulada con estados de carga',
              color: const Color(0xFF3FB950),
              tag: '01',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FutureScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _ModuleCard(
              icon: Icons.timer_outlined,
              title: 'Timer – Cronómetro',
              subtitle: 'Iniciar / Pausar / Reanudar / Reiniciar',
              color: const Color(0xFFF78166),
              tag: '02',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TimerScreen()),
              ),
            ),
            const SizedBox(height: 16),
            _ModuleCard(
              icon: Icons.memory_outlined,
              title: 'Isolate – Tarea Pesada',
              subtitle: 'Cálculo CPU-bound en hilo separado',
              color: const Color(0xFFD2A8FF),
              tag: '03',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IsolateScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String tag;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF161B22),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF30363D)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          tag,
                          style: TextStyle(
                            color: color.withOpacity(0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFFE6EDF3),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8B949E),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: const Color(0xFF30363D),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}