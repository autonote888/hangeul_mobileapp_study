import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/auth_background_scaffold.dart';
import '../../data/hangeul_repository.dart';
import '../../services/hangeul_audio_service.dart';
import '../widgets/korean_dictionary_view.dart';
import '../widgets/topik1_section_view.dart';

class HangeulHomePage extends StatefulWidget {
  final String userEmail;

  const HangeulHomePage({
    super.key,
    required this.userEmail,
  });

  @override
  State<HangeulHomePage> createState() => _HangeulHomePageState();
}

class _HangeulHomePageState extends State<HangeulHomePage> {
  int _selectedCategoryIndex = 0;
  int _selectedItemIndex = 0;
  bool _isSpeaking = false;

  List<HangeulLessonItem> get _currentList {
    switch (_selectedCategoryIndex) {
      case 0:
        return HangeulRepository.angkaLessons;
      case 1:
        return HangeulRepository.vokalLessons;
      default:
        return HangeulRepository.latihanLessons;
    }
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _selectedItemIndex = 0;
    });
    if (index < 3) {
      final firstItem = _currentList.first;
      HangeulAudioService.speak(firstItem.hangeul);
    }
  }

  Future<void> _playAudio(String text, {bool slow = false}) async {
    setState(() => _isSpeaking = true);
    await HangeulAudioService.speak(text, slow: slow);
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _playSpellStepByStep(HangeulLessonItem item) async {
    setState(() => _isSpeaking = true);
    final allJamos = <String>[];
    for (final s in item.syllables) {
      for (final p in s.parts) {
        allJamos.add(p.jamo);
      }
    }
    await HangeulAudioService.speakStepByStep(
      jamoParts: allJamos,
      fullWord: item.hangeul,
    );
    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _currentList;
    final activeItem = items[_selectedItemIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. Header Gelap (Dark Navy) + Menu Kategori
          Container(
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris Atas: Judul Aplikasi Saturnus & Tombol Keluar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SATURNUS • KOREA AUDIO',
                              style: TextStyle(
                                color: AppTheme.goldAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Belajar Tulis & Suara Hangeul',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          tooltip: 'Keluar / Logout',
                          onPressed: () => context.read<AuthCubit>().signOut(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                          ),
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Menu Pilihan Horizontal Scrollable (Anti-Overflow):
                    // 1. Angka | 2. Vokal | 3. Latihan | 4. TOPIK I | 5. Kamus Lengkap Bahasa Korea
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CategoryTabButton(
                            title: 'Hangeul Angka',
                            subtitle: '일, 이, 삼...',
                            icon: Icons.pin_outlined,
                            isSelected: _selectedCategoryIndex == 0,
                            onTap: () => _selectCategory(0),
                          ),
                          const SizedBox(width: 8),
                          _CategoryTabButton(
                            title: 'Hangeul Vokal',
                            subtitle: '아, 야, 어...',
                            icon: Icons.record_voice_over_outlined,
                            isSelected: _selectedCategoryIndex == 1,
                            onTap: () => _selectCategory(1),
                          ),
                          const SizedBox(width: 8),
                          _CategoryTabButton(
                            title: 'Latihan Hangeul',
                            subtitle: '한글, 사랑...',
                            icon: Icons.auto_stories_outlined,
                            isSelected: _selectedCategoryIndex == 2,
                            onTap: () => _selectCategory(2),
                          ),
                          const SizedBox(width: 8),
                          _CategoryTabButton(
                            title: 'TOPIK I',
                            subtitle: '문법 & 어휘',
                            icon: Icons.school_outlined,
                            isSelected: _selectedCategoryIndex == 3,
                            onTap: () => _selectCategory(3),
                          ),
                          const SizedBox(width: 8),
                          _CategoryTabButton(
                            title: 'Kamus Lengkap Bahasa Korea',
                            subtitle: '한국어 사전',
                            icon: Icons.menu_book_rounded,
                            isSelected: _selectedCategoryIndex == 4,
                            onTap: () => _selectCategory(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Konten Utama sesuai Menu yang Dipilih (dengan Smooth Transition)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _selectedCategoryIndex == 3
                    ? const Topik1SectionView(key: ValueKey('tab_topik1'))
                    : _selectedCategoryIndex == 4
                        ? const KoreanDictionaryView(key: ValueKey('tab_dict'))
                        : Column(
                            key: ValueKey(
                                'tab_hangeul_${_selectedCategoryIndex}_$_selectedItemIndex'),
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Kartu Utama 3D Penulisan & Suara Hangeul Ukuran Sangat Besar
                              Interactive3DTiltCard(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 22,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: AppTheme.goldAccent
                                          .withOpacity(0.35),
                                      width: 1.4,
                                    ),
                                    boxShadow: [
                                      const BoxShadow(
                                        color: Color(0xFFCBD5E1),
                                        blurRadius: 0,
                                        offset: Offset(0, 4.5),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 22,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                      children: [
                        // Tag Kategori + Tombol Coretan Tulis (Latihan Tulis)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  activeItem.categoryTag.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF475569),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                _showWritingPadModal(context, activeItem);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.orangeAction,
                                backgroundColor:
                                    AppTheme.orangeAction.withOpacity(0.08),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.draw_outlined, size: 18),
                              label: const Text(
                                'Coba Tulis',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // TULISAN HANGEUL SUPER BESAR (Klik untuk dengar suara)
                        GestureDetector(
                          onTap: () => _playAudio(activeItem.hangeul),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              activeItem.hangeul,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 96,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.primaryButtonNavy,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Cara Baca (Romaji + Simbol Fonetik IPA) Besar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryButtonNavy,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${activeItem.romaji.toUpperCase()}  •  IPA ${activeItem.ipaPhonetic}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppTheme.goldAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Arti dalam Bahasa Indonesia
                        Text(
                          activeItem.meaning,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TOMBOL KONTROL SUARA PELAFALAN (Normal | Lambat | Eja Per Huruf)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _playAudio(activeItem.hangeul, slow: false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryButtonNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(
                                _isSpeaking
                                    ? Icons.graphic_eq
                                    : Icons.volume_up_rounded,
                                size: 18,
                                color: AppTheme.goldAccent,
                              ),
                              label: const Text(
                                'Dengar Suara',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _playAudio(activeItem.hangeul, slow: true),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryButtonNavy,
                                side: const BorderSide(
                                    color: Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(
                                Icons.slow_motion_video_rounded,
                                size: 18,
                                color: AppTheme.orangeAction,
                              ),
                              label: const Text(
                                'Suara Lambat',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _playSpellStepByStep(activeItem),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryButtonNavy,
                                side: const BorderSide(
                                    color: Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(
                                Icons.record_voice_over_outlined,
                                size: 17,
                                color: Color(0xFF0284C7),
                              ),
                              label: const Text(
                                'Eja Per Huruf',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // KOTAK PANDUAN DETAIL ARTIKULASI SUARA (LIDAH, BIBIR & NAPAS)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F9FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFBAE6FD),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.spatial_audio_off_rounded,
                                    color: Color(0xFF0284C7),
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'PANDUAN DETAIL SUARA & ARTIKULASI MULUT:',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF0369A1),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                activeItem.audioGuide,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF0C4A6E),
                                  height: 1.4,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 12),

                        // Judul Bagian Pemecahan Penggabungan Hangeul + Ketuk untuk Bunyi
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.extension_outlined,
                              size: 18,
                              color: AppTheme.orangeAction,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'PEMECAHAN HURUF & DETAIL BUNYI (KETUK KOTAK UNTUK DENGAR)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF475569),
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Daftar Suku Kata yang Dipecah (Misal: 한 = ㅎ + ㅏ + ㄴ) beserta detail suaranya
                        ...activeItem.syllables.map(
                          (syllable) => _SyllableBreakdownCard(
                            breakdown: syllable,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tips Cara Penulisan
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFDE68A),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.edit_note_rounded,
                                color: Color(0xFFD97706),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Cara Tulis: ${activeItem.tip}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF92400E),
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Tombol Navigasi Sebelumnya / Selanjutnya
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _selectedItemIndex > 0
                                  ? () {
                                      setState(() {
                                        _selectedItemIndex--;
                                      });
                                      _playAudio(
                                          items[_selectedItemIndex].hangeul);
                                    }
                                  : null,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  size: 14),
                              label: const Text(
                                'Sebelumnya',
                                style: TextStyle(fontSize: 12.5),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '${_selectedItemIndex + 1} / ${items.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _selectedItemIndex < items.length - 1
                                  ? () {
                                      setState(() {
                                        _selectedItemIndex++;
                                      });
                                      _playAudio(
                                          items[_selectedItemIndex].hangeul);
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryButtonNavy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                                icon: const Text(
                                  'Selanjutnya',
                                  style: TextStyle(fontSize: 12.5),
                                ),
                                label: const Icon(Icons.arrow_forward_ios,
                                    size: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // 3. Daftar Pilihan Cepat Semua Huruf di Kategori Ini (Grid Besar)
                  const Text(
                    'PILIH HURUF LAINNYA (OTOMATIS BERSUARA SAAT DIKLIK):',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = index == _selectedItemIndex;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedItemIndex = index;
                          });
                          _playAudio(item.hangeul);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryButtonNavy
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.goldAccent
                                  : const Color(0xFFE2E8F0),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                item.hangeul,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primaryButtonNavy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.volume_up_rounded,
                                    size: 12,
                                    color: isSelected
                                        ? AppTheme.goldAccent
                                        : const Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  Flexible(
                                    child: Text(
                                      item.romaji,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? AppTheme.goldAccent
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Modal Kanvas Latihan Menulis Hangeul dengan Jari
  void _showWritingPadModal(BuildContext context, HangeulLessonItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HangeulWritingPadSheet(item: item),
    );
  }
}

class _CategoryTabButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTabButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minWidth: 102),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppTheme.goldAccent
                : Colors.white.withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppTheme.primaryButtonNavy
                  : AppTheme.goldAccent,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? AppTheme.primaryButtonNavy
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF64748B)
                    : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget Visualisasi Pemecahan Suku Kata Hangeul (Contoh: 한 = ㅎ + ㅏ + ㄴ)
/// dilengkapi dengan Tombol Suara pada setiap pecahan Jamo dan penjelasan detail bunyi.
class _SyllableBreakdownCard extends StatelessWidget {
  final SyllableBreakdown breakdown;

  const _SyllableBreakdownCard({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Baris Rumus Visual Besar: [ㅎ] + [ㅏ] + [ㄴ] = [한]
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < breakdown.parts.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.orangeAction,
                        ),
                      ),
                    ),
                  _JamoBox(part: breakdown.parts[i]),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '=',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryButtonNavy,
                    ),
                  ),
                ),
                // Hasil Gabungan Suku Kata (Klik untuk dengar bunyi suku kata)
                GestureDetector(
                  onTap: () => HangeulAudioService.speak(breakdown.syllable),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButtonNavy,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          breakdown.syllable,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.volume_up_rounded,
                              size: 13,
                              color: AppTheme.goldAccent,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              breakdown.romaji,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.goldAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Ringkasan Rumus Bunyi Suku Kata
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              '🔊 Rumus Bunyi: ${breakdown.soundExplanation}',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryButtonNavy,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 3. Rincian Detail Suara Setiap Huruf Penyusun (Jamo)
          ...breakdown.parts.map(
            (part) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: InkWell(
                onTap: () => HangeulAudioService.speakJamo(part.jamo),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryButtonNavy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          part.jamo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '${part.jamoName}  •  Bunyi [${part.romaji}]',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.volume_up_rounded,
                                  size: 14,
                                  color: AppTheme.orangeAction,
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              part.soundDetail,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JamoBox extends StatelessWidget {
  final JamoPart part;

  const _JamoBox({required this.part});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HangeulAudioService.speakJamo(part.jamo),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              part.jamo,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryButtonNavy,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.volume_up_rounded,
                    size: 12,
                    color: AppTheme.orangeAction,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    part.romaji,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.orangeAction,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              part.jamoName,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            Text(
              part.role,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Modal Kanvas Latihan Menulis Hangeul secara Langsung di Atas Bayangan Huruf Besar
class _HangeulWritingPadSheet extends StatefulWidget {
  final HangeulLessonItem item;

  const _HangeulWritingPadSheet({required this.item});

  @override
  State<_HangeulWritingPadSheet> createState() =>
      _HangeulWritingPadSheetState();
}

class _HangeulWritingPadSheetState extends State<_HangeulWritingPadSheet> {
  final List<List<Offset>> _strokes = [];

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LATIHAN GORESAN TANGAN & SUARA',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.orangeAction,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Ikuti bayangan huruf: ${widget.item.hangeul} (${widget.item.romaji})',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryButtonNavy,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Dengar Suara',
                onPressed: () => HangeulAudioService.speak(widget.item.hangeul),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppTheme.orangeAction,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Kanvas Gambar dengan Watermark Huruf Hangeul Sangat Besar di Tengah
          Container(
            height: 280,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Watermark Bayangan Huruf Besar
                  IgnorePointer(
                    child: Text(
                      widget.item.hangeul,
                      style: TextStyle(
                        fontSize: 150,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.withOpacity(0.20),
                      ),
                    ),
                  ),
                  // Area Sentuh Goresan Jari
                  GestureDetector(
                    onPanStart: (details) {
                      setState(() {
                        _strokes.add([details.localPosition]);
                      });
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _strokes.last.add(details.localPosition);
                      });
                    },
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _StrokePainter(strokes: _strokes),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearCanvas,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Hapus Goresan',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButtonNavy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Selesai',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  _StrokePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryButtonNavy
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) => true;
}
