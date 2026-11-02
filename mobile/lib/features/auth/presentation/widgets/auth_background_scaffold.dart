import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
/// dilengkapi Animasi 3D Interaktif di belakang kalimat "WELCOME BACK / HELLO SIGN IN"
/// serta efek 3D Parallax & Floating 3D Shapes pada bagian kartu isian (form).
class AuthBackgroundScaffold extends StatefulWidget {
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
  State<AuthBackgroundScaffold> createState() => _AuthBackgroundScaffoldState();
}

class _AuthBackgroundScaffoldState extends State<AuthBackgroundScaffold>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient3DController;
  Offset _cardTilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ambient3DController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _ambient3DController.dispose();
    super.dispose();
  }

  void _handlePointerMove(PointerMoveEvent event, Size size) {
    final dx = ((event.localPosition.dx / size.width) - 0.5) * 2.0;
    final dy = ((event.localPosition.dy / size.height) - 0.5) * 2.0;
    setState(() {
      _cardTilt = Offset(
        dy.clamp(-1.0, 1.0) * -0.035,
        dx.clamp(-1.0, 1.0) * 0.035,
      );
    });
  }

  void _resetTilt() {
    if (_cardTilt != Offset.zero) {
      setState(() => _cardTilt = Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

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

          // 2. Konten Utama (Header dengan 3D tepat di belakang teks + White 3D Card)
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
                  height: 160,
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
                              widget.subtitle.toUpperCase(),
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
                                widget.title.toUpperCase(),
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

                const SizedBox(height: 8),

                // White Rounded Card Container dengan Smooth 3D Tilt & Background 3D Shapes
                Expanded(
                  child: Listener(
                    onPointerMove: (e) => _handlePointerMove(e, screenSize),
                    onPointerUp: (_) => _resetTilt(),
                    onPointerCancel: (_) => _resetTilt(),
                    child: TweenAnimationBuilder<Offset>(
                      tween: Tween<Offset>(
                        begin: Offset.zero,
                        end: _cardTilt,
                      ),
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      builder: (context, tilt, childWidget) {
                        final matrix = Matrix4.identity()
                          ..setEntry(3, 2, 0.0009)
                          ..rotateX(tilt.dx)
                          ..rotateY(tilt.dy);

                        return Transform(
                          alignment: Alignment.topCenter,
                          transform: matrix,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(38),
                                topRight: Radius.circular(38),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: AppTheme.goldAccent.withOpacity(0.45),
                                  width: 1.8,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.40),
                                  blurRadius: 28,
                                  offset: Offset(-tilt.dy * 120, -8),
                                ),
                                BoxShadow(
                                  color: AppTheme.cyanGlow.withOpacity(0.12),
                                  blurRadius: 20,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(38),
                                topRight: Radius.circular(38),
                              ),
                              child: Stack(
                                children: [
                                  // Layer Geometri 3D Halus pada Background Area Isian
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: AnimatedBuilder(
                                        animation: _ambient3DController,
                                        builder: (context, _) {
                                          return CustomPaint(
                                            painter:
                                                _Form3DBackgroundShapesPainter(
                                              progress:
                                                  _ambient3DController.value,
                                              tiltX: tilt.dx,
                                              tiltY: tilt.dy,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  // Konten Form Isian
                                  SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(
                                        28, 34, 28, 24),
                                    child: widget.child,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

/// Widget Isian (Input Field) Berbentuk 3D Extruded Prism/Capsule
/// dengan Smooth Perspective Transition saat disentuh, digerakkan (drag), maupun diketik.
class Interactive3DInputField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final double letterSpacing;

  const Interactive3DInputField({
    super.key,
    this.label,
    this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.letterSpacing = 0.2,
  });

  @override
  State<Interactive3DInputField> createState() =>
      _Interactive3DInputFieldState();
}

class _Interactive3DInputFieldState extends State<Interactive3DInputField>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _prismController;
  bool _isFocused = false;
  bool _isHoveredOrPressed = false;
  Offset _localTilt = Offset.zero;
  double _typingBoost = 0.0;

  @override
  void initState() {
    super.initState();
    _prismController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
          if (_isFocused) {
            HapticFeedback.selectionClick();
          } else {
            _localTilt = Offset.zero;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _prismController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event, BoxConstraints constraints) {
    _updateTilt(event.localPosition, constraints.maxWidth);
    setState(() => _isHoveredOrPressed = true);
  }

  void _onPointerMove(PointerMoveEvent event, BoxConstraints constraints) {
    _updateTilt(event.localPosition, constraints.maxWidth);
  }

  void _onPointerEnd() {
    setState(() {
      _isHoveredOrPressed = false;
      _localTilt = Offset.zero;
    });
  }

  void _updateTilt(Offset localPos, double width) {
    final safeWidth = width <= 0 ? 300.0 : width;
    final normX = ((localPos.dx / safeWidth) - 0.5) * 2.0;
    final normY = ((localPos.dy / 64.0) - 0.5) * 2.0;
    setState(() {
      _localTilt = Offset(
        (normY * -0.09).clamp(-0.12, 0.12),
        (normX * 0.09).clamp(-0.12, 0.12),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final active = _isFocused || _isHoveredOrPressed;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          onPointerDown: (e) => _onPointerDown(e, constraints),
          onPointerMove: (e) => _onPointerMove(e, constraints),
          onPointerUp: (_) => _onPointerEnd(),
          onPointerCancel: (_) => _onPointerEnd(),
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: _localTilt,
            ),
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            builder: (context, smoothTilt, _) {
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.0022)
                ..rotateX(smoothTilt.dx)
                ..rotateY(smoothTilt.dy)
                ..translate(
                  smoothTilt.dy * 18.0,
                  active ? -3.5 : 0.0,
                  active ? 10.0 : 0.0,
                );

              return AnimatedScale(
                scale: active ? 1.018 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutBack,
                child: Transform(
                  alignment: Alignment.center,
                  transform: matrix,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.label != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 7),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: active ? 14 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                    colors: active
                                        ? [
                                            AppTheme.goldAccent,
                                            AppTheme.cyanGlow
                                          ]
                                        : [
                                            AppTheme.labelGrey,
                                            AppTheme.inputBorderGrey
                                          ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                widget.label!,
                                style: TextStyle(
                                  color: active
                                      ? AppTheme.primaryButtonNavy
                                      : AppTheme.labelGrey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Kontainer Shape 3D Extruded Prism untuk Input
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: active
                                ? [
                                    const Color(0xFFFFFFFF),
                                    const Color(0xFFF1F5F9),
                                  ]
                                : [
                                    const Color(0xFFF8FAFC),
                                    const Color(0xFFF1F5F9),
                                  ],
                          ),
                          border: Border.all(
                            color: active
                                ? AppTheme.goldAccent
                                : const Color(0xFFCBD5E1),
                            width: active ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            // 1. Solid 3D Extrusion Lip (Bagian Bawah Shape 3D)
                            BoxShadow(
                              color: active
                                  ? AppTheme.primaryButtonNavy
                                  : const Color(0xFFCBD5E1),
                              blurRadius: 0,
                              offset: Offset(
                                -smoothTilt.dy * 18.0,
                                active ? 5.0 : 3.5,
                              ),
                            ),
                            // 2. Ambient 3D Floating Depth Shadow
                            BoxShadow(
                              color: active
                                  ? AppTheme.goldAccent.withOpacity(0.28)
                                  : Colors.black.withOpacity(0.06),
                              blurRadius: active ? 20 : 10,
                              offset: Offset(
                                -smoothTilt.dy * 30.0,
                                active ? 10 : 5,
                              ),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            // Ornamen Shape 3D Kristal/Prisma di sudut kanan dalam isian
                            Positioned(
                              right: widget.suffixIcon != null ? 44 : 14,
                              child: IgnorePointer(
                                child: AnimatedBuilder(
                                  animation: _prismController,
                                  builder: (context, _) {
                                    return SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CustomPaint(
                                        painter: _Mini3DPrismPainter(
                                          progress: _prismController.value +
                                              _typingBoost,
                                          isActive: active,
                                          tiltX: smoothTilt.dx,
                                          tiltY: smoothTilt.dy,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // TextField Utama
                            TextField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              obscureText: widget.obscureText,
                              keyboardType: widget.keyboardType,
                              onChanged: (val) {
                                setState(() {
                                  _typingBoost = (_typingBoost + 0.12) % 1.0;
                                });
                                widget.onChanged?.call(val);
                              },
                              style: TextStyle(
                                color: const Color(0xFF0F172A),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: widget.letterSpacing,
                              ),
                              decoration: InputDecoration(
                                hintText: widget.hintText,
                                hintStyle: const TextStyle(
                                  color: AppTheme.labelGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // Ikon Kiri di dalam Kubus 3D (3D Beveled Cube Badge)
                                prefixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: active
                                            ? [
                                                AppTheme.primaryButtonNavy,
                                                const Color(0xFF1E3A5F),
                                              ]
                                            : [
                                                Colors.white,
                                                const Color(0xFFE2E8F0),
                                              ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: active
                                              ? AppTheme.goldAccent
                                                  .withOpacity(0.45)
                                              : Colors.black.withOpacity(0.08),
                                          blurRadius: active ? 8 : 4,
                                          offset: const Offset(0, 2.5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.prefixIcon,
                                      color: active
                                          ? AppTheme.goldAccent
                                          : const Color(0xFF475569),
                                      size: 19,
                                    ),
                                  ),
                                ),
                                suffixIcon: widget.suffixIcon,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Wrapper Kartu 3D Interaktif dengan Smooth Transition saat digerakkan / disentuh.
/// Dapat digunakan untuk membungkus kartu Hangeul, Kamus, maupun bagian form.
class Interactive3DTiltCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const Interactive3DTiltCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<Interactive3DTiltCard> createState() => _Interactive3DTiltCardState();
}

class _Interactive3DTiltCardState extends State<Interactive3DTiltCard> {
  Offset _tilt = Offset.zero;
  bool _pressed = false;

  void _updatePointer(Offset pos, Size size) {
    final w = size.width <= 0 ? 300.0 : size.width;
    final h = size.height <= 0 ? 200.0 : size.height;
    final nx = ((pos.dx / w) - 0.5) * 2.0;
    final ny = ((pos.dy / h) - 0.5) * 2.0;
    setState(() {
      _pressed = true;
      _tilt = Offset(
        (ny * -0.065).clamp(-0.10, 0.10),
        (nx * 0.065).clamp(-0.10, 0.10),
      );
    });
  }

  void _reset() {
    setState(() {
      _pressed = false;
      _tilt = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, 220);
        return Listener(
          onPointerDown: (e) => _updatePointer(e.localPosition, size),
          onPointerMove: (e) => _updatePointer(e.localPosition, size),
          onPointerUp: (_) => _reset(),
          onPointerCancel: (_) => _reset(),
          child: GestureDetector(
            onTap: widget.onTap,
            child: TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(begin: Offset.zero, end: _tilt),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              builder: (context, smoothTilt, childWidget) {
                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.0016)
                  ..rotateX(smoothTilt.dx)
                  ..rotateY(smoothTilt.dy)
                  ..translate(0.0, _pressed ? -2.5 : 0.0, 0.0);

                return AnimatedScale(
                  scale: _pressed ? 1.012 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: matrix,
                    child: childWidget,
                  ),
                );
              },
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Painter Ornamen Shape 3D Octahedron / Kristal di dalam Kotak Isian
class _Mini3DPrismPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final double tiltX;
  final double tiltY;

  _Mini3DPrismPainter({
    required this.progress,
    required this.isActive,
    required this.tiltX,
    required this.tiltY,
  });

  static const List<_Vec3> _octaVertices = [
    _Vec3(0, -1.2, 0),
    _Vec3(1.0, 0, 0),
    _Vec3(0, 0, 1.0),
    _Vec3(-1.0, 0, 0),
    _Vec3(0, 0, -1.0),
    _Vec3(0, 1.2, 0),
  ];

  static const List<List<int>> _octaEdges = [
    [0, 1], [0, 2], [0, 3], [0, 4],
    [5, 1], [5, 2], [5, 3], [5, 4],
    [1, 2], [2, 3], [3, 4], [4, 1],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final angle = progress * 2 * math.pi;
    final rx = angle * 0.8 + tiltX * 6;
    final ry = angle * 1.3 + tiltY * 6;
    final scale = isActive ? 9.5 : 7.5;

    final pts = <Offset>[];
    for (final v in _octaVertices) {
      final r = v.rotateX(rx).rotateY(ry);
      pts.add(Offset(center.dx + r.x * scale, center.dy + r.y * scale));
    }

    final paint = Paint()
      ..color = isActive
          ? AppTheme.goldAccent.withOpacity(0.55)
          : AppTheme.labelGrey.withOpacity(0.25)
      ..strokeWidth = isActive ? 1.2 : 0.9
      ..style = PaintingStyle.stroke;

    for (final edge in _octaEdges) {
      canvas.drawLine(pts[edge[0]], pts[edge[1]], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Mini3DPrismPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isActive != isActive ||
        oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY;
  }
}

/// Painter Shape 3D Halus Melayang pada Background Area Isian Putih
class _Form3DBackgroundShapesPainter extends CustomPainter {
  final double progress;
  final double tiltX;
  final double tiltY;

  _Form3DBackgroundShapesPainter({
    required this.progress,
    required this.tiltX,
    required this.tiltY,
  });

  static const List<_Vec3> _cubeVertices = [
    _Vec3(-1, -1, -1),
    _Vec3(1, -1, -1),
    _Vec3(1, 1, -1),
    _Vec3(-1, 1, -1),
    _Vec3(-1, -1, 1),
    _Vec3(1, -1, 1),
    _Vec3(1, 1, 1),
    _Vec3(-1, 1, 1),
  ];

  static const List<List<int>> _cubeEdges = [
    [0, 1], [1, 2], [2, 3], [3, 0],
    [4, 5], [5, 6], [6, 7], [7, 4],
    [0, 4], [1, 5], [2, 6], [3, 7],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * math.pi;

    // Gambar 3 buah Kubus 3D Wireframe lembut di sudut kartu form
    _drawWireframeCube(
      canvas: canvas,
      center: Offset(
        size.width * 0.88 + tiltY * 180,
        size.height * 0.16 + math.sin(t) * 8 + tiltX * 180,
      ),
      scale: 22,
      rotX: t + tiltX * 4,
      rotY: t * 1.4 + tiltY * 4,
      color: AppTheme.goldAccent.withOpacity(0.14),
    );

    _drawWireframeCube(
      canvas: canvas,
      center: Offset(
        size.width * 0.10 - tiltY * 150,
        size.height * 0.52 + math.cos(t * 1.2) * 10 - tiltX * 150,
      ),
      scale: 18,
      rotX: -t * 1.1,
      rotY: t * 0.9,
      color: AppTheme.cyanGlow.withOpacity(0.14),
    );

    _drawWireframeCube(
      canvas: canvas,
      center: Offset(
        size.width * 0.85 + tiltY * 120,
        size.height * 0.82 + math.sin(t * 1.5) * 7,
      ),
      scale: 25,
      rotX: t * 0.7,
      rotY: -t * 1.2,
      color: AppTheme.primaryButtonNavy.withOpacity(0.06),
    );
  }

  void _drawWireframeCube({
    required Canvas canvas,
    required Offset center,
    required double scale,
    required double rotX,
    required double rotY,
    required Color color,
  }) {
    final pts = <Offset>[];
    for (final v in _cubeVertices) {
      final r = v.rotateX(rotX).rotateY(rotY);
      final persp = 4.0 / (4.0 - r.z * 0.35);
      pts.add(Offset(
        center.dx + r.x * scale * persp,
        center.dy + r.y * scale * persp,
      ));
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    for (final edge in _cubeEdges) {
      canvas.drawLine(pts[edge[0]], pts[edge[1]], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Form3DBackgroundShapesPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY;
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

    for (int i = 0; i < projected.length; i++) {
      final normZ = ((depths[i] + 2.0) / 4.0).clamp(0.15, 0.75);
      final nodeRadius = 1.4 + normZ * 1.8;

      final nodePaint = Paint()
        ..color = Colors.white.withOpacity(normZ)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(projected[i], nodeRadius, nodePaint);
    }

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

/// Tombol Primary Pill 3D Dark Navy dengan panah emas dan Smooth 3D Press/Tilt Transition
class PrimaryAuthButton extends StatefulWidget {
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
  State<PrimaryAuthButton> createState() => _PrimaryAuthButtonState();
}

class _PrimaryAuthButtonState extends State<PrimaryAuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        height: 54,
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 3.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            // 3D Bottom Lip
            BoxShadow(
              color: const Color(0xFF050811),
              blurRadius: 0,
              offset: Offset(0, _isPressed ? 1.5 : 4.5),
            ),
            BoxShadow(
              color: AppTheme.primaryButtonNavy.withOpacity(0.32),
              blurRadius: _isPressed ? 8 : 18,
              offset: Offset(0, _isPressed ? 4 : 9),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryButtonNavy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: AppTheme.goldAccent.withOpacity(0.40),
                width: 1.0,
              ),
            ),
            elevation: 0,
          ),
          child: widget.isLoading
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
                      widget.label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 19,
                      color: AppTheme.goldAccent,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
