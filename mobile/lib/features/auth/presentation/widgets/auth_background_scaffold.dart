import 'dart:math' as math;
import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkNavyTop = Color(0xFF1F3541);
  static const Color darkNavyBottom = Color(0xFF0B192C);
  static const Color primaryButtonNavy = Color(0xFF0D1322);
  static const Color goldAccent = Color(0xFFC59B6D);
  static const Color cyanGlow = Color(0xFF38BDF8);
  static const Color orangeAction = Color(0xFFB85D19);
  static const Color labelGrey = Color(0xFF8C9BAE);
  static const Color inputBorderGrey = Color(0xFFE2E8F0);
}

/// Widget Reusable sesuai dengan Template UI/UX yang dilampirkan,
/// dengan Animasi 3D Interaktif tepat di BELAKANG kalimat "WELCOME BACK / HELLO SIGN IN".
class AuthBackgroundScaffold extends StatelessWidget {
  final String subtitle;
  final String title;
  final Widget child;

  const AuthBackgroundScaffold({
    super.key,
    required this.subtitle,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.darkNavyBottom,
      body: Stack(
        children: [
          // 1. Background Gradient di bagian atas
          Container(
            height: screenHeight * 0.44,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2C444E),
                  AppTheme.darkNavyTop,
                  AppTheme.darkNavyBottom,
                ],
              ),
            ),
          ),

          // 2. Konten Utama (Header dengan 3D tepat di belakang teks + White Card)
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Menu Icon (...)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Area Header Teks dengan Animasi 3D tepat DI BELAKANG kalimat WELCOME BACK / HELLO SIGN IN
                SizedBox(
                  height: 165,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Layer Belakang: Animasi 3D Berputar tepat di pusat teks
                      const Positioned.fill(
                        child: Interactive3DHeaderScene(),
                      ),

                      // Layer Depan: Kalimat WELCOME BACK & HELLO SIGN IN
                      IgnorePointer(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              subtitle.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppTheme.goldAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.4,
                                shadows: [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              child: Text(
                                title.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.6,
                                  height: 1.25,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 16,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // White Rounded Card Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(38),
                        topRight: Radius.circular(38),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 24,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(32, 38, 32, 24),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Scene 3D Real-time (60 FPS) yang berpusat tepat di belakang tulisan WELCOME BACK / HELLO SIGN IN.
/// Dapat diputar dengan menggeser jari (swipe/drag) pada area sekitar tulisan.
class Interactive3DHeaderScene extends StatefulWidget {
  const Interactive3DHeaderScene({super.key});

  @override
  State<Interactive3DHeaderScene> createState() =>
      _Interactive3DHeaderSceneState();
}

class _Interactive3DHeaderSceneState extends State<Interactive3DHeaderScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _userRotX = 0.25;
  double _userRotY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanUpdate: (details) {
        setState(() {
          _userRotY += details.delta.dx * 0.012;
          _userRotX =
              (_userRotX - details.delta.dy * 0.012).clamp(-1.2, 1.2);
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _Cyber3DPainter(
              progress: _controller.value,
              userRotX: _userRotX,
              userRotY: _userRotY,
            ),
          );
        },
      ),
    );
  }
}

class _Vec3 {
  final double x;
  final double y;
  final double z;

  const _Vec3(this.x, this.y, this.z);

  _Vec3 rotateX(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return _Vec3(x, y * c - z * s, y * s + z * c);
  }

  _Vec3 rotateY(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return _Vec3(x * c + z * s, y, -x * s + z * c);
  }

  _Vec3 rotateZ(double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return _Vec3(x * c - y * s, x * s + y * c, z);
  }
}

class _Cyber3DPainter extends CustomPainter {
  final double progress;
  final double userRotX;
  final double userRotY;

  _Cyber3DPainter({
    required this.progress,
    required this.userRotX,
    required this.userRotY,
  });

  static const double _phi = 1.61803398875;
  static final List<_Vec3> _icosahedronVertices = [
    const _Vec3(-1, _phi, 0),
    const _Vec3(1, _phi, 0),
    const _Vec3(-1, -_phi, 0),
    const _Vec3(1, -_phi, 0),
    const _Vec3(0, -1, _phi),
    const _Vec3(0, 1, _phi),
    const _Vec3(0, -1, -_phi),
    const _Vec3(0, 1, -_phi),
    const _Vec3(_phi, 0, -1),
    const _Vec3(_phi, 0, 1),
    const _Vec3(-_phi, 0, -1),
    const _Vec3(-_phi, 0, 1),
  ];

  static const List<List<int>> _icosahedronEdges = [
    [0, 11], [0, 5], [0, 1], [0, 7], [0, 10],
    [1, 5], [5, 11], [11, 10], [10, 7], [7, 1],
    [3, 9], [3, 4], [3, 2], [3, 6], [3, 8],
    [4, 9], [2, 4], [6, 2], [8, 6], [9, 8],
    [4, 5], [9, 5], [9, 1], [8, 1], [8, 7],
    [6, 7], [6, 10], [2, 10], [2, 11], [4, 11],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * math.pi;

    // Titik pusat objek 3D berada tepat di belakang kalimat WELCOME BACK & HELLO SIGN IN
    final center = Offset(
      size.width * 0.5,
      size.height * 0.48 + math.sin(t * 2) * 4.0,
    );

    // 1. Ambient Halo Glow di belakang teks
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.goldAccent.withOpacity(0.22),
          AppTheme.cyanGlow.withOpacity(0.10),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 130));
    canvas.drawCircle(center, 130, glowPaint);

    // 2. Cincin Orbit 3D Lebar yang mengelilingi kalimat WELCOME BACK / HELLO SIGN IN
    _drawOrbitalRing(
      canvas: canvas,
      center: center,
      radiusX: 135,
      radiusY: 62,
      rotX: 0.95 + userRotX * 0.4 + math.sin(t) * 0.12,
      rotY: t + userRotY * 0.5,
      rotZ: 0.18,
      color: AppTheme.goldAccent,
      satelliteAngle: t * 3,
    );

    _drawOrbitalRing(
      canvas: canvas,
      center: center,
      radiusX: 110,
      radiusY: 54,
      rotX: -0.80 + userRotX * 0.4,
      rotY: -t * 1.4 + userRotY * 0.5,
      rotZ: -0.25,
      color: AppTheme.cyanGlow,
      satelliteAngle: -t * 4,
    );

    // 3. Proyeksi 3D Icosahedron (Wireframe Geometri 3D di belakang teks)
    const double scale = 36.0;
    const double fov = 4.5;
    final rotX = t * 1.1 + userRotX;
    final rotY = t * 1.6 + userRotY;
    final rotZ = t * 0.6;

    final List<Offset> projected = [];
    final List<double> depths = [];

    for (final v in _icosahedronVertices) {
      final r = v.rotateX(rotX).rotateY(rotY).rotateZ(rotZ);
      final perspective = fov / (fov - r.z * 0.45);
      final px = center.dx + r.x * scale * perspective;
      final py = center.dy + r.y * scale * perspective;
      projected.add(Offset(px, py));
      depths.add(r.z);
    }

    // Gambar rusuk (edges) dengan opasitas lembut agar teks WELCOME BACK tetap tajam terbaca
    for (final edge in _icosahedronEdges) {
      final i = edge[0];
      final j = edge[1];
      final avgZ = (depths[i] + depths[j]) * 0.5;
      final alpha = ((avgZ + 2.0) / 4.0).clamp(0.10, 0.55);

      final edgePaint = Paint()
        ..color = Color.lerp(
          AppTheme.cyanGlow,
          AppTheme.goldAccent,
          ((avgZ + 1.8) / 3.6).clamp(0.0, 1.0),
        )!
            .withOpacity(alpha)
        ..strokeWidth = 0.7 + alpha * 1.1
        ..style = PaintingStyle.stroke;

      canvas.drawLine(projected[i], projected[j], edgePaint);
    }

    // Gambar titik simpul (nodes) bercahaya di setiap sudut 3D
    for (int i = 0; i < projected.length; i++) {
      final normZ = ((depths[i] + 2.0) / 4.0).clamp(0.15, 0.75);
      final nodeRadius = 1.4 + normZ * 1.8;

      final nodePaint = Paint()
        ..color = Colors.white.withOpacity(normZ)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(projected[i], nodeRadius, nodePaint);
    }

    // 4. Partikel 3D Melayang di sekitar teks
    _drawFloatingParticles(canvas, size, t);
  }

  void _drawOrbitalRing({
    required Canvas canvas,
    required Offset center,
    required double radiusX,
    required double radiusY,
    required double rotX,
    required double rotY,
    required double rotZ,
    required Color color,
    required double satelliteAngle,
  }) {
    const int segments = 64;
    const double fov = 4.5;
    final path = Path();

    for (int i = 0; i <= segments; i++) {
      final theta = (i / segments) * 2 * math.pi;
      final point3D = _Vec3(
        math.cos(theta) * (radiusX / 100.0),
        math.sin(theta) * (radiusY / 100.0),
        0,
      ).rotateX(rotX).rotateY(rotY).rotateZ(rotZ);

      final perspective = fov / (fov - point3D.z * 0.35);
      final screenPt = Offset(
        center.dx + point3D.x * 100.0 * perspective,
        center.dy + point3D.y * 100.0 * perspective,
      );

      if (i == 0) {
        path.moveTo(screenPt.dx, screenPt.dy);
      } else {
        path.lineTo(screenPt.dx, screenPt.dy);
      }
    }

    final sat3D = _Vec3(
      math.cos(satelliteAngle) * (radiusX / 100.0),
      math.sin(satelliteAngle) * (radiusY / 100.0),
      0,
    ).rotateX(rotX).rotateY(rotY).rotateZ(rotZ);
    final satPersp = fov / (fov - sat3D.z * 0.35);
    final satellitePos = Offset(
      center.dx + sat3D.x * 100.0 * satPersp,
      center.dy + sat3D.y * 100.0 * satPersp,
    );

    final ringPaint = Paint()
      ..color = color.withOpacity(0.28)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, ringPaint);

    final satScale = ((sat3D.z + 1.5) / 3.0).clamp(0.4, 1.2);
    canvas.drawCircle(
      satellitePos,
      5.5 * satScale,
      Paint()..color = color.withOpacity(0.35),
    );
    canvas.drawCircle(
      satellitePos,
      2.4 * satScale,
      Paint()..color = Colors.white,
    );
  }

  void _drawFloatingParticles(Canvas canvas, Size size, double t) {
    const int count = 14;
    for (int i = 0; i < count; i++) {
      final seed = i * 1.73;
      final px = (size.width * ((math.sin(seed * 3.1) + 1) * 0.45 + 0.05)) +
          math.sin(t + seed) * 12;
      final py = (size.height * ((math.cos(seed * 2.3) + 1) * 0.42 + 0.08)) +
          math.cos(t * 1.5 + seed) * 8;
      final alpha =
          (0.15 + (math.sin(t * 2 + seed) + 1) * 0.20).clamp(0.1, 0.55);
      final radius = 1.0 + (i % 3) * 0.8;

      canvas.drawCircle(
        Offset(px, py),
        radius,
        Paint()
          ..color = (i.isEven ? AppTheme.goldAccent : AppTheme.cyanGlow)
              .withOpacity(alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Cyber3DPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.userRotX != userRotX ||
        oldDelegate.userRotY != userRotY;
  }
}

/// Tombol Primary Pill Dark Navy dengan panah emas sesuai template
class PrimaryAuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryAuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryButtonNavy.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryButtonNavy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: AppTheme.goldAccent,
                  ),
                ],
              ),
      ),
    );
  }
}
