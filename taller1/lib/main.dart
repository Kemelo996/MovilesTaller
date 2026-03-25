import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String titulo = "Hola, Flutter";
  bool _isTitleChanged = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  static const Color kPrimary = Color(0xFF6C63FF);
  static const Color kAccent  = Color(0xFFFF6584);
  static const Color kSurface = Color(0xFF1E1E2E);
  static const Color kCard    = Color(0xFF2A2A3E);
  static const Color kText    = Color(0xFFE0E0F0);
  static const Color kSubtext = Color(0xFF9090B0);

  // Ambas imágenes vienen de la red — sin assets locales
  static const String _imgNetwork =
      "https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png";
  static const String _imgAsset =
      "https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png";

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void cambiarTitulo() async {
    await _animController.forward();
    await _animController.reverse();
    setState(() {
      _isTitleChanged = !_isTitleChanged;
      titulo = _isTitleChanged ? "¡Título cambiado!" : "Hola, Flutter";
    });
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: kPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                "Título actualizado",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 20),
              _buildImagesRow(),
              const SizedBox(height: 20),
              _buildActionButton(),
              const SizedBox(height: 20),
              _buildInfoContainer(),
              const SizedBox(height: 20),
              _buildListSection(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kCard,
      elevation: 0,
      centerTitle: false,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0, 0.3), end: Offset.zero)
                .animate(anim),
            child: child,
          ),
        ),
        child: Text(
          titulo,
          key: ValueKey(titulo),
          style: const TextStyle(
            color: kText,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.4,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: kPrimary.withOpacity(0.18),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.flutter_dash, color: kPrimary, size: 22),
        ),
      ],
    );
  }

  // ─── Tarjeta de perfil ────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF48BBFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 26),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kevin Andres Montes Camelo",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Taller 1 · Flutter",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Fila de imágenes (ambas desde red) ───────────────────────────────────
  Widget _buildImagesRow() {
    return Row(
      children: [
        Expanded(child: _buildImageCard(url: _imgNetwork, label: "Image.network", color: kPrimary)),
        const SizedBox(width: 14),
        Expanded(child: _buildImageCard(url: _imgAsset,   label: "Image.asset",   color: kAccent)),
      ],
    );
  }

  Widget _buildImageCard({
    required String url,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 72,
                  height: 72,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: color,
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (_, _, _) => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.broken_image_rounded, color: color, size: 32),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Botón principal ──────────────────────────────────────────────────────
  Widget _buildActionButton() {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: cambiarTitulo,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isTitleChanged
                  ? [kAccent, const Color(0xFFFF8C69)]
                  : [kPrimary, const Color(0xFF8B85FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isTitleChanged ? kAccent : kPrimary).withOpacity(0.4),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isTitleChanged ? Icons.refresh_rounded : Icons.edit_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              const Text(
                "Cambiar título",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Container informativo ────────────────────────────────────────────────
  Widget _buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPrimary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline_rounded, color: kPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Widget Container",
                  style: TextStyle(
                    color: kText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Márgenes, colores y bordes personalizados.",
                  style: TextStyle(color: kSubtext, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Sección lista ────────────────────────────────────────────────────────
  Widget _buildListSection() {
    final items = [
      {"icon": Icons.rocket_launch_rounded, "title": "Elemento 1", "sub": "Flutter es multiplataforma",  "color": kPrimary},
      {"icon": Icons.palette_rounded,       "title": "Elemento 2", "sub": "Diseño personalizable",       "color": kAccent},
      {"icon": Icons.bolt_rounded,          "title": "Elemento 3", "sub": "Rendimiento nativo",          "color": const Color(0xFF43E8A0)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Lista de elementos",
            style: TextStyle(
              color: kText,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.3,
            ),
          ),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item  = items[index];
            final color = item["color"] as Color;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(item["icon"] as IconData, color: color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["title"] as String,
                            style: const TextStyle(color: kText, fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text(item["sub"] as String,
                            style: const TextStyle(color: kSubtext, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: kSubtext, size: 14),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}