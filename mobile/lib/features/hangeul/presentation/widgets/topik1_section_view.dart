import 'package:flutter/material.dart';
import '../../../auth/presentation/widgets/auth_background_scaffold.dart';
import '../../data/topik1_repository.dart';
import '../../services/hangeul_audio_service.dart';

/// Widget tampilan lengkap Modul Pembelajaran Khusus TOPIK I:
/// Terdiri dari 2 Sub-Tab:
/// 1. Tata Bahasa Dasar (문법 / Grammar): Partikel, Akhiran Kalimat, Konjungsi, Honorifik
/// 2. Kosa Kata & Tema Sehari-hari (어휘 / Vocabulary): 6 Tema Inti TOPIK I (1.500-2.000 kata)
class Topik1SectionView extends StatefulWidget {
  const Topik1SectionView({super.key});

  @override
  State<Topik1SectionView> createState() => _Topik1SectionViewState();
}

class _Topik1SectionViewState extends State<Topik1SectionView> {
  int _subTabIndex = 0; // 0 = Tata Bahasa (문법), 1 = Kosa Kata (어휘)

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Banner Info TOPIK I + Sub-Tab Selector
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButtonNavy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'KURIKULUM RESMI TOPIK I',
                      style: TextStyle(
                        color: AppTheme.goldAccent,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Level 1–2 (Target 1.500–2.000 Kata)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Switcher: 1. Tata Bahasa (문법) | 2. Kosa Kata (어휘)
              Row(
                children: [
                  Expanded(
                    child: _SubTabPill(
                      label: '1. Tata Bahasa (문법)',
                      subtitle: 'Partikel, Akhiran, Konjungsi, Honorifik',
                      isActive: _subTabIndex == 0,
                      onTap: () => setState(() => _subTabIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SubTabPill(
                      label: '2. Kosa Kata (어휘)',
                      subtitle: '6 Tema Utama Sehari-hari',
                      isActive: _subTabIndex == 1,
                      onTap: () => setState(() => _subTabIndex = 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        if (_subTabIndex == 0)
          ...Topik1Repository.grammarGroups.map(
            (group) => _GrammarGroupWidget(group: group),
          )
        else
          ...Topik1Repository.vocabThemes.map(
            (theme) => _VocabThemeWidget(theme: theme),
          ),
      ],
    );
  }
}

class _SubTabPill extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const _SubTabPill({
    required this.label,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryButtonNavy : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppTheme.goldAccent : const Color(0xFFE2E8F0),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.white : AppTheme.primaryButtonNavy,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: isActive ? AppTheme.goldAccent : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GrammarGroupWidget extends StatelessWidget {
  final TopikGrammarGroup group;

  const _GrammarGroupWidget({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kelompok Grammar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            decoration: const BoxDecoration(
              color: AppTheme.primaryButtonNavy,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  group.groupSubtitle,
                  style: const TextStyle(
                    color: AppTheme.goldAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Daftar Pola Grammar
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: group.items
                  .map((item) => _GrammarItemCard(item: item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrammarItemCard extends StatelessWidget {
  final TopikGrammarItem item;

  const _GrammarItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Pola Hangeul Besar + Tombol Suara
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.pattern,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryButtonNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.title}  •  [${item.romaji}]',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.orangeAction,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Dengar Pelafalan Pola',
                onPressed: () => HangeulAudioService.speak(item.pattern),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryButtonNavy,
                ),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppTheme.goldAccent,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Kotak Rumus Aturan Pemakaian
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Text(
              item.ruleSummary,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF92400E),
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Penjelasan Detail
          Text(
            item.detailedUsage,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF334155),
              height: 1.45,
            ),
          ),

          const SizedBox(height: 12),

          // Contoh Kalimat (Klik untuk dengar kalimat Korea)
          ...item.examples.map(
            (ex) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: InkWell(
                onTap: () => HangeulAudioService.speak(ex.korean),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: 18,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.korean,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryButtonNavy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            ex.romaji,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Arti: "${ex.indonesian}"',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '💡 Pecahan: ${ex.breakdownNote}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.orangeAction,
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
        ],
      ),
    );
  }
}

class _VocabThemeWidget extends StatelessWidget {
  final TopikVocabTheme theme;

  const _VocabThemeWidget({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Tema Kosa Kata
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            decoration: const BoxDecoration(
              color: AppTheme.primaryButtonNavy,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        theme.themeTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        theme.themeKorean,
                        style: const TextStyle(
                          color: AppTheme.goldAccent,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  theme.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Daftar Kosa Kata dalam Tema Ini
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: theme.words
                  .map((word) => _VocabWordCard(entry: word))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabWordCard extends StatelessWidget {
  final TopikVocabEntry entry;

  const _VocabWordCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.hangeul,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryButtonNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '[${entry.romaji}]  —  ${entry.indonesian}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.orangeAction,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Dengar Suara Kosa Kata',
                onPressed: () => HangeulAudioService.speak(entry.hangeul),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.primaryButtonNavy,
                ),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppTheme.goldAccent,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              '🧩 Pemecahan Jamo: ${entry.syllableBreakdown}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => HangeulAudioService.speak(entry.exampleSentence),
            child: Row(
              children: [
                const Icon(
                  Icons.play_circle_outline_rounded,
                  size: 18,
                  color: Color(0xFF0284C7),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${entry.exampleSentence}  (${entry.exampleMeaning})',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0C4A6E),
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

