class JamoPart {
  final String jamo;
  final String romaji;
  final String jamoName; // Nama resmi huruf Jamo Korea (misal: "Giyeok", "Ieung", "A")
  final String soundDetail; // Penjelasan detail cara bunyi & posisi lidah/mulut
  final String role; // Contoh: "Konsonan Awal", "Vokal Vertikal", "Batchim"

  const JamoPart({
    required this.jamo,
    required this.romaji,
    required this.jamoName,
    required this.soundDetail,
    required this.role,
  });
}

class SyllableBreakdown {
  final String syllable; // Contoh: "한"
  final String romaji; // Contoh: "han"
  final String soundExplanation; // Contoh: "Bunyi 'h' + 'a' + ditutup 'n' = han"
  final List<JamoPart> parts; // Contoh: [ㅎ, ㅏ, ㄴ]

  const SyllableBreakdown({
    required this.syllable,
    required this.romaji,
    required this.soundExplanation,
    required this.parts,
  });

  String get formula => parts.map((p) => p.jamo).join(' + ');
}

class HangeulLessonItem {
  final String hangeul; // Karakter / Kata Utama Besar (misal: "일", "하나", "아", "사랑")
  final String romaji; // Cara baca (misal: "il", "ha-na", "a", "sa-rang")
  final String ipaPhonetic; // Simbol fonetik internasional (misal: "[il]", "[ha.na]")
  final String audioGuide; // Panduan detail cara pengucapan lidah, bibir, dan napas
  final String meaning; // Arti Bahasa Indonesia
  final String categoryTag; // Label kategori
  final String tip; // Panduan urutan goresan / cara tulis
  final List<SyllableBreakdown> syllables; // Pemecahan blok suku kata menjadi Jamo penyusunnya

  const HangeulLessonItem({
    required this.hangeul,
    required this.romaji,
    required this.ipaPhonetic,
    required this.audioGuide,
    required this.meaning,
    required this.categoryTag,
    required this.tip,
    required this.syllables,
  });
}

class HangeulRepository {
  /// 1. MENU HANGEUL ANGKA (Sino-Korea & Asli Korea 1-10)
  static const List<HangeulLessonItem> angkaLessons = [
    HangeulLessonItem(
      hangeul: '일',
      romaji: 'il',
      ipaPhonetic: '[il]',
      audioGuide:
          'Ucapkan vokal "i" bersih sambil menarik ujung lidah menyentuh langit-langit depan untuk menutup dengan bunyi "L" lembut.',
      meaning: 'Satu (1)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Lingkaran ㅇ (tanpa bunyi di awal) digabung vokal vertikal ㅣ di kanan, lalu ditutup ㄹ di bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '일',
          romaji: 'il',
          soundExplanation: 'ㅇ (hening) + ㅣ (bunyi "i") + ㄹ (akhiran "l") → dibaca "il"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Tanpa bunyi (hening) saat berada di posisi awal suku kata.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Bunyi "i" terang seperti pada kata "ini" (bibir ditarik sedikit ke samping).',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'l',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Di akhir suku kata (batchim) berbunyi "L" dengan ujung lidah menempel di langit-langit.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '이',
      romaji: 'i',
      ipaPhonetic: '[i]',
      audioGuide:
          'Tarik sudut bibir sedikit ke samping seperti tersenyum dan bunyikan "iii" secara jelas tanpa akhiran konsonan.',
      meaning: 'Dua (2)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Tulis lingkaran ㅇ di sisi kiri, lalu tarik garis lurus vertikal ㅣ dari atas ke bawah di sisi kanan.',
      syllables: [
        SyllableBreakdown(
          syllable: '이',
          romaji: 'i',
          soundExplanation: 'ㅇ (hening) + ㅣ (bunyi "i") → dibaca "i"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga vokal tanpa bunyi di awal suku kata.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Bunyi vokal "i" jernih seperti pada kata "ikan".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '삼',
      romaji: 'sam',
      ipaPhonetic: '[sam]',
      audioGuide:
          'Desiskan bunyi "s" lembut, buka mulut lebar untuk vokal "a", lalu rapatkan kedua bibir untuk menghasilkan dengung "m".',
      meaning: 'Tiga (3)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Tulis konsonan ㅅ di kiri atas, vokal ㅏ di kanan atas, dan kotak ㅁ sebagai penutup di bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '삼',
          romaji: 'sam',
          soundExplanation: 'ㅅ ("s") + ㅏ ("a") + ㅁ ("m") → dibaca "sam"',
          parts: [
            JamoPart(
              jamo: 'ㅅ',
              romaji: 's',
              jamoName: 'Siot (시옷)',
              soundDetail: 'Bunyi desis "s" halus tanpa hembusan udara berlebih.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi "a" terbuka lebar seperti pada kata "apa".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㅁ',
              romaji: 'm',
              jamoName: 'Mieum (미음)',
              soundDetail: 'Bunyi "m" bilabial dengan merapatkan kedua bibir di akhir.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '사',
      romaji: 'sa',
      ipaPhonetic: '[sa]',
      audioGuide:
          'Keluarkan desis "s" ringan di ujung gigi, langsung disambung vokal "a" terbuka pendek.',
      meaning: 'Empat (4)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Gabungan konsonan ㅅ (s) di sebelah kiri dengan vokal ㅏ (a) di sebelah kanan.',
      syllables: [
        SyllableBreakdown(
          syllable: '사',
          romaji: 'sa',
          soundExplanation: 'ㅅ ("s") + ㅏ ("a") → dibaca "sa"',
          parts: [
            JamoPart(
              jamo: 'ㅅ',
              romaji: 's',
              jamoName: 'Siot (시옷)',
              soundDetail: 'Bunyi "s" lembut di depan.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi "a" jelas dengan rahang terbuka.',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '오',
      romaji: 'o',
      ipaPhonetic: '[o]',
      audioGuide:
          'Bulatkan kedua bibir ke depan seperti hendak meniup dan keluarkan bunyi "o" bulat (seperti kata "obat").',
      meaning: 'Lima (5)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Karena ㅗ adalah vokal horizontal, lingkaran ㅇ diletakkan di ATAS vokal ㅗ.',
      syllables: [
        SyllableBreakdown(
          syllable: '오',
          romaji: 'o',
          soundExplanation: 'ㅇ (hening) + ㅗ (vokal bulat "o") → dibaca "o"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Tidak berbunyi di posisi atas.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅗ',
              romaji: 'o',
              jamoName: 'O (오)',
              soundDetail: 'Vokal "o" dengan bibir membulat sempurna.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '육',
      romaji: 'yuk',
      ipaPhonetic: '[juk̚]',
      audioGuide:
          'Mulai dari bunyi luncuran "yu" dengan bibir membulat, lalu tahan pangkal lidah di langit-langit belakang untuk bunyi "k" tertahan.',
      meaning: 'Enam (6)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Lingkaran ㅇ di atas, vokal ㅠ (yu) di tengah, dan konsonan ㄱ (k) di paling bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '육',
          romaji: 'yuk',
          soundExplanation: 'ㅇ (hening) + ㅠ ("yu") + ㄱ (akhiran "k") → dibaca "yuk"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga awal tanpa suara.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅠ',
              romaji: 'yu',
              jamoName: 'Yu (유)',
              soundDetail: 'Bunyi rangkap "yu" dengan bibir maju.',
              role: 'Vokal Horizontal',
            ),
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'k',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Di posisi bawah (batchim) terdengar sebagai "k" pendek tanpa letupan udara.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '칠',
      romaji: 'chil',
      ipaPhonetic: '[tɕʰil]',
      audioGuide:
          'Ucapkan "ch" disertai hembusan napas kuat (aspirated), disambung "i", lalu tutup dengan ujung lidah menyentuh gusi atas ("l").',
      meaning: 'Tujuh (7)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Konsonan ㅊ (ch) di kiri atas, vokal ㅣ (i) di kanan atas, dan ㄹ (l) di bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '칠',
          romaji: 'chil',
          soundExplanation: 'ㅊ ("ch" berhembus) + ㅣ ("i") + ㄹ ("l") → dibaca "chil"',
          parts: [
            JamoPart(
              jamo: 'ㅊ',
              romaji: 'ch',
              jamoName: 'Chieut (치읓)',
              soundDetail: 'Bunyi "ch" dengan hembusan udara kuat dari mulut.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Bunyi vokal "i" tinggi.',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'l',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Bunyi penutup "l" di akhir suku kata.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '팔',
      romaji: 'pal',
      ipaPhonetic: '[pʰal]',
      audioGuide:
          'Letupkan kedua bibir dengan hembusan udara kuat untuk bunyi "pʰ", buka mulut untuk "a", dan akhiri dengan lidah di atas ("l").',
      meaning: 'Delapan (8)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Konsonan ㅍ (p) di kiri atas, vokal ㅏ (a) di kanan atas, dan ㄹ (l) di bagian bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '팔',
          romaji: 'pal',
          soundExplanation: 'ㅍ ("p" berhembus) + ㅏ ("a") + ㄹ ("l") → dibaca "pal"',
          parts: [
            JamoPart(
              jamo: 'ㅍ',
              romaji: 'p',
              jamoName: 'Pieup (피읖)',
              soundDetail: 'Bunyi "p" dengan letupan napas kuat.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi "a" terbuka.',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'l',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Bunyi akhir "l".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '구',
      romaji: 'gu',
      ipaPhonetic: '[ku]',
      audioGuide:
          'Bunyikan konsonan lembut antara "g" dan "k" di pangkal lidah, lalu majukan bibir membentuk vokal "u".',
      meaning: 'Sembilan (9)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Konsonan ㄱ (g) diletakkan di atas vokal horizontal ㅜ (u).',
      syllables: [
        SyllableBreakdown(
          syllable: '구',
          romaji: 'gu',
          soundExplanation: 'ㄱ ("g/k") + ㅜ ("u") → dibaca "gu"',
          parts: [
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'g',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Di awal kata berbunyi lembut di antara "g" dan "k".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅜ',
              romaji: 'u',
              jamoName: 'U (우)',
              soundDetail: 'Bunyi "u" dengan bibir maju membulat.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '십',
      romaji: 'sip',
      ipaPhonetic: '[ɕip̚]',
      audioGuide:
          'Ketika ㅅ bertemu vokal ㅣ (i), bunyinya menjadi "sh" halus (seperti "syarat"), lalu katupkan bibir rapat-rapat untuk akhiran "p".',
      meaning: 'Sepuluh (10)',
      categoryTag: 'Angka Sino-Korea',
      tip: 'Konsonan ㅅ (s) + vokal ㅣ (i) di atas, ditutup konsonan ㅂ (p) di bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '십',
          romaji: 'sip',
          soundExplanation: 'ㅅ ("sh/s") + ㅣ ("i") + ㅂ (akhiran "p") → dibaca "ship / sip"',
          parts: [
            JamoPart(
              jamo: 'ㅅ',
              romaji: 's/sh',
              jamoName: 'Siot (시옷)',
              soundDetail: 'Di depan vokal ㅣ terdengar lembut mendekati "sh".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Bunyi vokal "i".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㅂ',
              romaji: 'p',
              jamoName: 'Bieup (비읍)',
              soundDetail: 'Di akhir suku kata (batchim), bibir ditutup rapat menghasilkan bunyi "p" tertahan.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '하나',
      romaji: 'ha-na',
      ipaPhonetic: '[ha.na]',
      audioGuide:
          'Suku kata pertama "ha" dihembuskan ringan dari tenggorokan, diikuti "na" dengan ujung lidah menyentuh gusi atas.',
      meaning: 'Satu (1) - Hitungan Benda',
      categoryTag: 'Angka Asli Korea',
      tip: 'Terdiri dari 2 suku kata: 하 (ㅎ + ㅏ) dan 나 (ㄴ + ㅏ).',
      syllables: [
        SyllableBreakdown(
          syllable: '하',
          romaji: 'ha',
          soundExplanation: 'ㅎ ("h") + ㅏ ("a") → dibaca "ha"',
          parts: [
            JamoPart(
              jamo: 'ㅎ',
              romaji: 'h',
              jamoName: 'Hieut (히읗)',
              soundDetail: 'Bunyi hembusan "h" bersih seperti pada kata "hari".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi vokal "a".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '나',
          romaji: 'na',
          soundExplanation: 'ㄴ ("n") + ㅏ ("a") → dibaca "na"',
          parts: [
            JamoPart(
              jamo: 'ㄴ',
              romaji: 'n',
              jamoName: 'Nieun (니은)',
              soundDetail: 'Bunyi sengau "n" seperti pada kata "nasi".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi vokal "a".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '둘',
      romaji: 'dul',
      ipaPhonetic: '[tul]',
      audioGuide:
          'Sentuhkan ujung lidah ke belakang gigi atas untuk bunyi "d/t", bulatkan bibir untuk "u", dan akhiri dengan lidah terangkat ("l").',
      meaning: 'Dua (2) - Hitungan Benda',
      categoryTag: 'Angka Asli Korea',
      tip: 'Susunan vertikal 3 tingkat: ㄷ (d) di atas, ㅜ (u) di tengah, dan ㄹ (l) di bawah.',
      syllables: [
        SyllableBreakdown(
          syllable: '둘',
          romaji: 'dul',
          soundExplanation: 'ㄷ ("d") + ㅜ ("u") + ㄹ ("l") → dibaca "dul"',
          parts: [
            JamoPart(
              jamo: 'ㄷ',
              romaji: 'd',
              jamoName: 'Digeut (디귿)',
              soundDetail: 'Bunyi konsonan "d" lembut.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅜ',
              romaji: 'u',
              jamoName: 'U (우)',
              soundDetail: 'Bunyi vokal "u" membulat.',
              role: 'Vokal Horizontal',
            ),
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'l',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Bunyi penutup "l".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
  ];

  /// 2. MENU HANGEUL VOKAL (Vokal Dasar & Vokal Gabungan)
  static const List<HangeulLessonItem> vokalLessons = [
    HangeulLessonItem(
      hangeul: '아',
      romaji: 'a',
      ipaPhonetic: '[a]',
      audioGuide:
          'Buka mulut secara natural dan keluarkan suara "aaa" dari tengah mulut (sama seperti huruf "A" dalam Bahasa Indonesia).',
      meaning: 'Vokal "A"',
      categoryTag: 'Vokal Dasar',
      tip: 'Vokal tidak boleh berdiri sendiri. Tambahkan ㅇ (tanpa bunyi) di kiri, lalu vokal ㅏ di kanan.',
      syllables: [
        SyllableBreakdown(
          syllable: '아',
          romaji: 'a',
          soundExplanation: 'ㅇ (hening) + ㅏ (bunyi "a") → dibaca "a"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Huruf penyangga tanpa suara di awal.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Bunyi vokal terang "a".',
              role: 'Vokal Dasar',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '야',
      romaji: 'ya',
      ipaPhonetic: '[ja]',
      audioGuide:
          'Mulai dari posisi lidah "i" yang meluncur cepat ke vokal terbuka "a" sehingga terdengar menyatu sebagai "ya".',
      meaning: 'Vokal "YA"',
      categoryTag: 'Vokal Dasar',
      tip: 'Menambahkan satu garis pendek ekstra pada ㅏ mengubah bunyi "a" menjadi "ya" (ㅑ).',
      syllables: [
        SyllableBreakdown(
          syllable: '야',
          romaji: 'ya',
          soundExplanation: 'ㅇ (hening) + ㅑ (bunyi "ya") → dibaca "ya"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅑ',
              romaji: 'ya',
              jamoName: 'Ya (야)',
              soundDetail: 'Gabungan luncuran "y" + "a" karena ada 2 garis pendek.',
              role: 'Vokal Y-Glide',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '어',
      romaji: 'eo',
      ipaPhonetic: '[ʌ]',
      audioGuide:
          'Buka rahang seperti akan mengucapkan "a", tetapi tarik pangkal lidah sedikit ke belakang tanpa membulatkan bibir (mirip "o" pada kata Jawa "توكو / soto").',
      meaning: 'Vokal "EO" (O Terbuka)',
      categoryTag: 'Vokal Dasar',
      tip: 'Garis pendek menghadap ke KIRI menuju lingkaran ㅇ, diikuti garis vertikal panjang.',
      syllables: [
        SyllableBreakdown(
          syllable: '어',
          romaji: 'eo',
          soundExplanation: 'ㅇ (hening) + ㅓ (bunyi "eo / o terbuka") → dibaca "eo"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅓ',
              romaji: 'eo',
              jamoName: 'Eo (어)',
              soundDetail: 'Bunyi "o" terbuka dengan bibir rileks (tidak membulat).',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '여',
      romaji: 'yeo',
      ipaPhonetic: '[jʌ]',
      audioGuide:
          'Luncurkan bunyi "y" cepat ke vokal "eo" (mulut agak terbuka rileks tanpa membulatkan bibir).',
      meaning: 'Vokal "YEO"',
      categoryTag: 'Vokal Dasar',
      tip: 'Dua garis pendek menghadap ke kiri (ㅕ) di samping kanan lingkaran ㅇ.',
      syllables: [
        SyllableBreakdown(
          syllable: '여',
          romaji: 'yeo',
          soundExplanation: 'ㅇ (hening) + ㅕ (bunyi "yeo") → dibaca "yeo"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅕ',
              romaji: 'yeo',
              jamoName: 'Yeo (여)',
              soundDetail: 'Bunyi "y" + "eo" terbuka.',
              role: 'Vokal Y-Glide',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '오',
      romaji: 'o',
      ipaPhonetic: '[o]',
      audioGuide:
          'Berbeda dengan "어", untuk "오" Anda WAJIB membulatkan bibir ke depan hingga menghasilkan bunyi "o" bulat.',
      meaning: 'Vokal "O" (Bibir Membulat)',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di atas, garis pendek vertikal menunjuk ke atas pada garis mendatar (ㅗ).',
      syllables: [
        SyllableBreakdown(
          syllable: '오',
          romaji: 'o',
          soundExplanation: 'ㅇ (hening) + ㅗ (bunyi "o" bulat) → dibaca "o"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi di atas.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅗ',
              romaji: 'o',
              jamoName: 'O (오)',
              soundDetail: 'Bunyi "o" bulat dengan bibir maju.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '요',
      romaji: 'yo',
      ipaPhonetic: '[jo]',
      audioGuide:
          'Ucapkan "yo" dengan bibir langsung membulat ke depan (sering dipakai di akhir kalimat sopan Korea "-yo").',
      meaning: 'Vokal "YO"',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di atas, diikuti dua garis pendek vertikal di atas garis mendatar (ㅛ).',
      syllables: [
        SyllableBreakdown(
          syllable: '요',
          romaji: 'yo',
          soundExplanation: 'ㅇ (hening) + ㅛ (bunyi "yo") → dibaca "yo"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅛ',
              romaji: 'yo',
              jamoName: 'Yo (요)',
              soundDetail: 'Bunyi "yo" bulat.',
              role: 'Vokal Y-Glide',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '우',
      romaji: 'u',
      ipaPhonetic: '[u]',
      audioGuide:
          'Majukan bibir membentuk lingkaran kecil dan keluarkan bunyi "uuu" seperti pada kata "udara".',
      meaning: 'Vokal "U"',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di atas, garis mendatar dengan garis pendek menunjuk ke bawah (ㅜ).',
      syllables: [
        SyllableBreakdown(
          syllable: '우',
          romaji: 'u',
          soundExplanation: 'ㅇ (hening) + ㅜ (bunyi "u") → dibaca "u"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅜ',
              romaji: 'u',
              jamoName: 'U (우)',
              soundDetail: 'Bunyi "u" jelas.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '유',
      romaji: 'yu',
      ipaPhonetic: '[ju]',
      audioGuide:
          'Luncurkan bunyi "y" menuju vokal "u" dengan bibir membulat (seperti kata bahasa Inggris "you").',
      meaning: 'Vokal "YU"',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di atas, garis mendatar dengan dua garis pendek menunjuk ke bawah (ㅠ).',
      syllables: [
        SyllableBreakdown(
          syllable: '유',
          romaji: 'yu',
          soundExplanation: 'ㅇ (hening) + ㅠ (bunyi "yu") → dibaca "yu"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅠ',
              romaji: 'yu',
              jamoName: 'Yu (유)',
              soundDetail: 'Bunyi "yu" dari tambahan 2 garis bawah.',
              role: 'Vokal Y-Glide',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '으',
      romaji: 'eu',
      ipaPhonetic: '[ɯ]',
      audioGuide:
          'Tarik bibir melebar ke samping seperti garis datar "ㅡ", rapatkan gigi sedikit, lalu ucapkan bunyi "e" pepet (seperti pada kata "enam" atau "emas").',
      meaning: 'Vokal "EU" (E Pepet)',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di atas dan satu garis lurus mendatar ㅡ di bawahnya.',
      syllables: [
        SyllableBreakdown(
          syllable: '으',
          romaji: 'eu',
          soundExplanation: 'ㅇ (hening) + ㅡ (bunyi "eu / e pepet") → dibaca "eu"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅡ',
              romaji: 'eu',
              jamoName: 'Eu (으)',
              soundDetail: 'Bibir ditarik datar menyamping sambil membunyikan "e" pepet.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '이',
      romaji: 'i',
      ipaPhonetic: '[i]',
      audioGuide:
          'Angkat bagian depan lidah mendekati langit-langit mulut dan ucapkan "i" dengan jelas.',
      meaning: 'Vokal "I"',
      categoryTag: 'Vokal Dasar',
      tip: 'Lingkaran ㅇ di kiri dan satu garis lurus vertikal ㅣ di kanan.',
      syllables: [
        SyllableBreakdown(
          syllable: '이',
          romaji: 'i',
          soundExplanation: 'ㅇ (hening) + ㅣ (bunyi "i") → dibaca "i"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga tanpa bunyi.',
              role: 'Penyangga',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Bunyi vokal vertikal "i".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '와',
      romaji: 'wa',
      ipaPhonetic: '[wa]',
      audioGuide:
          'Ucapkan "o" (ㅗ) dan "a" (ㅏ) secara cepat dalam satu hembusan napas: "o-a" → menyatu menjadi "wa".',
      meaning: 'Vokal Gabungan "WA"',
      categoryTag: 'Vokal Rangkap (Diftong)',
      tip: 'Merupakan penggabungan vokal horizontal ㅗ (o) dan vokal vertikal ㅏ (a) menjadi ㅘ (wa).',
      syllables: [
        SyllableBreakdown(
          syllable: '와',
          romaji: 'wa',
          soundExplanation: 'ㅇ (hening) + ㅗ ("o") + ㅏ ("a") → melebur menjadi "wa"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Penyangga awal tanpa suara.',
              role: 'Penyangga Awal',
            ),
            JamoPart(
              jamo: 'ㅗ',
              romaji: 'o',
              jamoName: 'O (오)',
              soundDetail: 'Bibir membulat di awal membentuk luncuran "w".',
              role: 'Vokal Dasar 1',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Mulut langsung membuka ke bunyi "a".',
              role: 'Vokal Dasar 2',
            ),
          ],
        ),
      ],
    ),
  ];

  /// 3. MENU HANGEUL LATIHAN LAINNYA (Kosakata & Sapaan Sehari-hari)
  static const List<HangeulLessonItem> latihanLessons = [
    HangeulLessonItem(
      hangeul: '한글',
      romaji: 'han-geul',
      ipaPhonetic: '[han.ɡɯl]',
      audioGuide:
          'Ucapkan "han" dengan jelas, lalu sambung dengan "geul" (gunakan bunyi "e" pepet seperti kata "gelas" lalu tutup dengan lidah "l").',
      meaning: 'Aksara Korea (Hangeul)',
      categoryTag: 'Kosakata Utama',
      tip: 'Suku kata pertama 한 (ㅎ+ㅏ+ㄴ) diikuti suku kata kedua 글 (ㄱ+ㅡ+ㄹ).',
      syllables: [
        SyllableBreakdown(
          syllable: '한',
          romaji: 'han',
          soundExplanation: 'ㅎ ("h") + ㅏ ("a") + ㄴ ("n") → dibaca "han"',
          parts: [
            JamoPart(
              jamo: 'ㅎ',
              romaji: 'h',
              jamoName: 'Hieut (히읗)',
              soundDetail: 'Hembusan bunyi "h" di awal.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal terbuka "a".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄴ',
              romaji: 'n',
              jamoName: 'Nieun (니은)',
              soundDetail: 'Penutup bunyi "n".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '글',
          romaji: 'geul',
          soundExplanation: 'ㄱ ("g") + ㅡ ("eu") + ㄹ ("l") → dibaca "geul"',
          parts: [
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'g',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Bunyi "g" lembut setelah konsonan "n".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅡ',
              romaji: 'eu',
              jamoName: 'Eu (으)',
              soundDetail: 'Vokal datar "eu" (e pepet).',
              role: 'Vokal Horizontal',
            ),
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'l',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Bunyi akhir "l".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '안녕',
      romaji: 'an-nyeong',
      ipaPhonetic: '[an.njʌŋ]',
      audioGuide:
          'Ucapkan "an", lalu sambung dengan "nyeong" (bunyi "ny" seperti kata "nyanyi" + vokal "eo" terbuka + dengung hidung "ng").',
      meaning: 'Halo / Hai (Sapaan Akrab)',
      categoryTag: 'Sapaan',
      tip: 'Perhatikan perbedaan ㅇ: di awal suku kata (안) tidak berbunyi, tetapi di bawah (녕) berbunyi "ng".',
      syllables: [
        SyllableBreakdown(
          syllable: '안',
          romaji: 'an',
          soundExplanation: 'ㅇ (hening) + ㅏ ("a") + ㄴ ("n") → dibaca "an"',
          parts: [
            JamoPart(
              jamo: 'ㅇ',
              romaji: '-',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Hening di awal suku kata.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄴ',
              romaji: 'n',
              jamoName: 'Nieun (니은)',
              soundDetail: 'Akhiran "n".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '녕',
          romaji: 'nyeong',
          soundExplanation: 'ㄴ ("n") + ㅕ ("yeo") + ㅇ ("ng") → dibaca "nyeong"',
          parts: [
            JamoPart(
              jamo: 'ㄴ',
              romaji: 'n',
              jamoName: 'Nieun (니은)',
              soundDetail: 'Saat bertemu vokal ㅕ, terdengar melebur menjadi "ny".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅕ',
              romaji: 'yeo',
              jamoName: 'Yeo (여)',
              soundDetail: 'Vokal "yeo" terbuka.',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㅇ',
              romaji: 'ng',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Di posisi bawah (batchim), ㅇ berbunyi sengau "ng"!',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '사랑',
      romaji: 'sa-rang',
      ipaPhonetic: '[sa.ɾaŋ]',
      audioGuide:
          'Ucapkan "sa" dengan ringan, lalu ketukkan ujung lidah sekali untuk "ra" dan tutup dengan bunyi sengau "ng" ("sa-rang").',
      meaning: 'Cinta / Kasih Sayang',
      categoryTag: 'Kosakata Populer',
      tip: '사 (ㅅ+ㅏ) digabung dengan 랑 (ㄹ+ㅏ+ㅇ). Konsonan ㄹ di awal suku kata kedua dibaca "r".',
      syllables: [
        SyllableBreakdown(
          syllable: '사',
          romaji: 'sa',
          soundExplanation: 'ㅅ ("s") + ㅏ ("a") → dibaca "sa"',
          parts: [
            JamoPart(
              jamo: 'ㅅ',
              romaji: 's',
              jamoName: 'Siot (시옷)',
              soundDetail: 'Bunyi desis "s" halus.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '랑',
          romaji: 'rang',
          soundExplanation: 'ㄹ ("r") + ㅏ ("a") + ㅇ ("ng") → dibaca "rang"',
          parts: [
            JamoPart(
              jamo: 'ㄹ',
              romaji: 'r',
              jamoName: 'Rieul (리을)',
              soundDetail: 'Di antara dua vokal, ㄹ berbunyi ketukan lidah "r" tunggal.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㅇ',
              romaji: 'ng',
              jamoName: 'Ieung (이응)',
              soundDetail: 'Bunyi penutup "ng".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '감사',
      romaji: 'gam-sa',
      ipaPhonetic: '[kam.sa]',
      audioGuide:
          'Ucapkan "gam" dengan bibir menutup rapat pada huruf "m", lalu langsung disambung desis "sa".',
      meaning: 'Terima Kasih',
      categoryTag: 'Ungkapan',
      tip: '감 disusun dari ㄱ (g) + ㅏ (a) + ㅁ (m), diikuti 사 yang disusun dari ㅅ (s) + ㅏ (a).',
      syllables: [
        SyllableBreakdown(
          syllable: '감',
          romaji: 'gam',
          soundExplanation: 'ㄱ ("g/k") + ㅏ ("a") + ㅁ ("m") → dibaca "gam"',
          parts: [
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'g',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Bunyi awal "g/k".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㅁ',
              romaji: 'm',
              jamoName: 'Mieum (미음)',
              soundDetail: 'Akhiran bibir rapat "m".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '사',
          romaji: 'sa',
          soundExplanation: 'ㅅ ("s") + ㅏ ("a") → dibaca "sa"',
          parts: [
            JamoPart(
              jamo: 'ㅅ',
              romaji: 's',
              jamoName: 'Siot (시옷)',
              soundDetail: 'Bunyi "s".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '친구',
      romaji: 'chin-gu',
      ipaPhonetic: '[tɕʰin.ɡu]',
      audioGuide:
          'Hembuskan "chin" dengan jelas di awal, lalu sambung dengan "gu" yang lembut.',
      meaning: 'Teman / Sahabat',
      categoryTag: 'Kosakata Sehari-hari',
      tip: '친 (ㅊ+ㅣ+ㄴ) menggunakan vokal vertikal, sedangkan 구 (ㄱ+ㅜ) menggunakan vokal horizontal.',
      syllables: [
        SyllableBreakdown(
          syllable: '친',
          romaji: 'chin',
          soundExplanation: 'ㅊ ("ch") + ㅣ ("i") + ㄴ ("n") → dibaca "chin"',
          parts: [
            JamoPart(
              jamo: 'ㅊ',
              romaji: 'ch',
              jamoName: 'Chieut (치읓)',
              soundDetail: 'Bunyi "ch" berhembus.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅣ',
              romaji: 'i',
              jamoName: 'I (이)',
              soundDetail: 'Vokal "i".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄴ',
              romaji: 'n',
              jamoName: 'Nieun (니은)',
              soundDetail: 'Akhiran "n".',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '구',
          romaji: 'gu',
          soundExplanation: 'ㄱ ("g") + ㅜ ("u") → dibaca "gu"',
          parts: [
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'g',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Setelah huruf "n", ㄱ selalu terdengar jelas sebagai "g".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅜ',
              romaji: 'u',
              jamoName: 'U (우)',
              soundDetail: 'Vokal bulat "u".',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
    HangeulLessonItem(
      hangeul: '학교',
      romaji: 'hak-gyo',
      ipaPhonetic: '[hak̚.k͈jo]',
      audioGuide:
          'Saat batchim ㄱ pada "hak" bertemu ㄱ pada "gyo", bunyi "g" kedua menebal menjadi ganda: "hak-kkyo".',
      meaning: 'Sekolah',
      categoryTag: 'Tempat',
      tip: '학 (ㅎ+ㅏ+ㄱ) diikuti 교 (ㄱ+ㅛ).',
      syllables: [
        SyllableBreakdown(
          syllable: '학',
          romaji: 'hak',
          soundExplanation: 'ㅎ ("h") + ㅏ ("a") + ㄱ ("k") → dibaca "hak"',
          parts: [
            JamoPart(
              jamo: 'ㅎ',
              romaji: 'h',
              jamoName: 'Hieut (히읗)',
              soundDetail: 'Bunyi awal "h".',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅏ',
              romaji: 'a',
              jamoName: 'A (아)',
              soundDetail: 'Vokal "a".',
              role: 'Vokal Vertikal',
            ),
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'k',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Akhiran "k" tertahan.',
              role: 'Batchim (Akhir)',
            ),
          ],
        ),
        SyllableBreakdown(
          syllable: '교',
          romaji: 'gyo',
          soundExplanation: 'ㄱ ("g/kk") + ㅛ ("yo") → dibaca "gyo"',
          parts: [
            JamoPart(
              jamo: 'ㄱ',
              romaji: 'g',
              jamoName: 'Giyeok (기역)',
              soundDetail: 'Menebal karena bertemu akhiran ㄱ sebelumnya.',
              role: 'Konsonan Awal',
            ),
            JamoPart(
              jamo: 'ㅛ',
              romaji: 'yo',
              jamoName: 'Yo (요)',
              soundDetail: 'Vokal "yo" membulat.',
              role: 'Vokal Horizontal',
            ),
          ],
        ),
      ],
    ),
  ];
}
