import 'package:flutter/material.dart';
import '../../../auth/presentation/widgets/auth_background_scaffold.dart';
import '../../data/korean_dictionary_repository.dart';
import '../../services/hangeul_audio_service.dart';

/// Widget Menu "Kamus Lengkap Bahasa Korea" (한국어 사전):
/// - Fitur Pencarian Instan (Hangeul, Romaji, maupun Bahasa Indonesia)
/// - Filter Kategori Kelas Kata (Semua, Ungkapan, Kata Kerja, Kata Sifat, Kata Benda, Kata Tanya & Keterangan)
/// - Pemecahan Huruf Jamo, Bentuk Sopan (-아/어요), Contoh Kalimat, dan Suara Pelafalan Korea (Normal & Lambat)
class KoreanDictionaryView extends StatefulWidget {
  const KoreanDictionaryView({super.key});

  @override
  State<KoreanDictionaryView> createState() => _KoreanDictionaryViewState();
}

class _KoreanDictionaryViewState extends State<KoreanDictionaryView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  List<KoreanDictionaryEntry> get _filteredEntries {
    return KoreanDictionaryRepository.entries.where((entry) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          entry.wordClass == _selectedCategory;

      if (!matchesCategory) return false;
      if (_searchQuery.trim().isEmpty) return true;

      final q = _searchQuery.trim().toLowerCase();
      return entry.hangeul.toLowerCase().contains(q) ||
          entry.romaji.toLowerCase().contains(q) ||
          entry.indonesian.toLowerCase().contains(q) ||
          entry.politeForm.toLowerCase().contains(q);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredEntries;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Kotak Pencarian Kamus (Hangeul / Romaji / Indonesia)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'KAMUS LENGKAP BAHASA KOREA (한국어 사전)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryButtonNavy,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButtonNavy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${results.length} Kosakata',
                      style: const TextStyle(
                        color: AppTheme.goldAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Input Search Bar
              TextField(
                controller: _searchController,
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Cari Hangeul, Romaji, atau Arti Indonesia...',
                  hintStyle: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.primaryButtonNavy,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.clear, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryButtonNavy,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Filter Chips Kategori Kelas Kata
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: KoreanDictionaryRepository.categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _selectedCategory = cat);
                        },
                        selectedColor: AppTheme.primaryButtonNavy,
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF475569),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Daftar Hasil Kamus
        if (results.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 48,
                  color: Color(0xFF94A3B8),
                ),
                SizedBox(height: 12),
                Text(
                  'Kosakata tidak ditemukan.\nCoba kata kunci lain (misal: makan, halo, 가다, 사랑).',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          )
        else
          ...results.map((entry) => _DictionaryCard(entry: entry)),
      ],
    );
  }
}

class _DictionaryCard extends StatelessWidget {
  final KoreanDictionaryEntry entry;

  const _DictionaryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Badge Kelas Kata + Tombol Suara Normal & Lambat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.wordClass.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Suara Normal',
                    onPressed: () =>
                        HangeulAudioService.speak(entry.hangeul, slow: false),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.primaryButtonNavy,
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.volume_up_rounded,
                      color: AppTheme.goldAccent,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    tooltip: 'Suara Lambat',
                    onPressed: () =>
                        HangeulAudioService.speak(entry.hangeul, slow: true),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      minimumSize: const Size(36, 36),
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(
                      Icons.slow_motion_video_rounded,
                      color: AppTheme.orangeAction,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Kata Hangeul Ukuran Besar + Romaji + Arti Indonesia
          GestureDetector(
            onTap: () => HangeulAudioService.speak(entry.hangeul),
            child: Text(
              entry.hangeul,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryButtonNavy,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '[${entry.romaji}]',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppTheme.orangeAction,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.indonesian,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          // Pemecahan Jamo & Bentuk Sopan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🧩 Pecahan Jamo: ${entry.jamoBreakdown}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                if (entry.politeForm != '-') ...[
                  const SizedBox(height: 4),
                  Text(
                    '✨ Bentuk Percakapan / Padanan: ${entry.politeForm}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Contoh Kalimat (Klik untuk dengar kalimat)
          InkWell(
            onTap: () => HangeulAudioService.speak(entry.exampleKorean),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      size: 18,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.exampleKorean,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryButtonNavy,
                          ),
                        ),
                        Text(
                          entry.exampleIndonesian,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

