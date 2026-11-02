class TopikGrammarExample {
  final String korean;
  final String romaji;
  final String indonesian;
  final String breakdownNote;

  const TopikGrammarExample({
    required this.korean,
    required this.romaji,
    required this.indonesian,
    required this.breakdownNote,
  });
}

class TopikGrammarItem {
  final String pattern; // Contoh: "은 / 는"
  final String romaji; // Contoh: "eun / neun"
  final String title; // Contoh: "Partikel Topik Kalimat"
  final String ruleSummary; // Aturan pemakaian konsonan akhir (batchim) vs vokal
  final String detailedUsage; // Penjelasan detail fungsi tata bahasa
  final List<TopikGrammarExample> examples;

  const TopikGrammarItem({
    required this.pattern,
    required this.romaji,
    required this.title,
    required this.ruleSummary,
    required this.detailedUsage,
    required this.examples,
  });
}

class TopikGrammarGroup {
  final String groupTitle; // Contoh: "A. Partikel Dasar (조사)"
  final String groupSubtitle;
  final List<TopikGrammarItem> items;

  const TopikGrammarGroup({
    required this.groupTitle,
    required this.groupSubtitle,
    required this.items,
  });
}

class TopikVocabEntry {
  final String hangeul;
  final String romaji;
  final String indonesian;
  final String syllableBreakdown; // Contoh: "나 (ㄴ+ㅏ) + 라 (ㄹ+ㅏ)"
  final String exampleSentence;
  final String exampleMeaning;

  const TopikVocabEntry({
    required this.hangeul,
    required this.romaji,
    required this.indonesian,
    required this.syllableBreakdown,
    required this.exampleSentence,
    required this.exampleMeaning,
  });
}

class TopikVocabTheme {
  final String themeTitle;
  final String themeKorean;
  final String description;
  final List<TopikVocabEntry> words;

  const TopikVocabTheme({
    required this.themeTitle,
    required this.themeKorean,
    required this.description,
    required this.words,
  });
}

class Topik1Repository {
  /// ==========================================================================
  /// BAGIAN 1: TATA BAHASA DASAR TOPIK I (문법 / GRAMMAR)
  /// ==========================================================================
  static const List<TopikGrammarGroup> grammarGroups = [
    // 1. PARTIKEL DASAR (조사)
    TopikGrammarGroup(
      groupTitle: '1. Partikel Dasar (조사)',
      groupSubtitle:
          'Partikel penanda subjek, topik, objek, lokasi, waktu, arah, alat, dan batasan',
      items: [
        TopikGrammarItem(
          pattern: '은 / 는 & 이 / 가',
          romaji: 'eun/neun & i/ga',
          title: 'Partikel Subjek & Topik Kalimat',
          ruleSummary:
              '• Akhiran Konsonan (Batchim): gunakan 은 (eun) / 이 (i)\n• Akhiran Vokal: gunakan 는 (neun) / 가 (ga)',
          detailedUsage:
              '은/는 digunakan untuk memperkenalkan topik pembicaraan, fakta umum, atau membandingkan (kontras). Sedangkan 이/가 digunakan untuk menekankan subjek baru atau menjawab pertanyaan "siapa/apa".',
          examples: [
            TopikGrammarExample(
              korean: '저는 인도네시아 사람입니다.',
              romaji: 'Jeo-neun In-do-ne-si-a sa-ram-im-ni-da.',
              indonesian: 'Saya adalah orang Indonesia.',
              breakdownNote: '저 (saya, akhiran vokal) + 는 (partikel topik)',
            ),
            TopikGrammarExample(
              korean: '날씨가 아주 좋습니다.',
              romaji: 'Nal-ssi-ga a-ju jo-seum-ni-da.',
              indonesian: 'Cuacanya sangat bagus.',
              breakdownNote: '날씨 (cuaca, akhiran vokal) + 가 (partikel subjek)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '을 / 를',
          romaji: 'eul / reul',
          title: 'Partikel Objek Kalimat',
          ruleSummary:
              '• Akhiran Konsonan (Batchim): gunakan 을 (eul)\n• Akhiran Vokal: gunakan 를 (reul)',
          detailedUsage:
              'Dilekatkan pada kata benda yang menjadi objek penderita dari kata kerja transitif (seperti makan, minum, membaca, menonton, membeli).',
          examples: [
            TopikGrammarExample(
              korean: '밥을 먹어요.',
              romaji: 'Bab-eul meo-geo-yo.',
              indonesian: 'Makan nasi.',
              breakdownNote: '밥 (nasi, batchim ㅂ) + 을 + 먹어요 (makan)',
            ),
            TopikGrammarExample(
              korean: '한국어를 공부해요.',
              romaji: 'Han-gu-geo-reul gong-bu-hae-yo.',
              indonesian: 'Belajar bahasa Korea.',
              breakdownNote: '한국어 (bahasa Korea, vokal) + 를 + 공부해요 (belajar)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '에 & 에서',
          romaji: 'e & e-seo',
          title: 'Partikel Lokasi & Waktu',
          ruleSummary:
              '• 에 (e): ke / di (keberadaan statis) / pada (waktu)\n• 에서 (e-seo): di (tempat berlangsungnya aksi) / dari (asal)',
          detailedUsage:
              'Gunakan 에 untuk menunjukkan tujuan pergi (가다/오다), keberadaan benda/orang (있다/없다), atau keterangan waktu (jam/hari). Gunakan 에서 jika ada aktivitas aktif yang dilakukan di tempat tersebut (belajar, bekerja, makan).',
          examples: [
            TopikGrammarExample(
              korean: '아침 8시에 학교에 가요.',
              romaji: 'A-chim yeo-deol-si-e hak-gyo-e ga-yo.',
              indonesian: 'Pergi ke sekolah pada jam 8 pagi.',
              breakdownNote: '8시 + 에 (pada waktu) & 학교 + 에 (ke tujuan)',
            ),
            TopikGrammarExample(
              korean: '도서관에서 책을 읽어요.',
              romaji: 'Do-seo-gwan-e-seo chaeg-eul il-geo-yo.',
              indonesian: 'Membaca buku di perpustakaan.',
              breakdownNote: '도서관 + 에서 (lokasi aksi aktif membaca)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '(으)로',
          romaji: '(eu)ro',
          title: 'Partikel Arah & Alat / Metode',
          ruleSummary:
              '• Akhiran Vokal atau Batchim ㄹ: gunakan 로 (ro)\n• Akhiran Konsonan selain ㄹ: gunakan 으로 (euro)',
          detailedUsage:
              'Memiliki 2 fungsi utama dalam TOPIK I:\n1. Menunjukkan arah tujuan ("ke arah / menuju").\n2. Menunjukkan alat, cara, kendaraan, atau bahasa yang digunakan ("dengan / menggunakan / naik").',
          examples: [
            TopikGrammarExample(
              korean: '오른쪽으로 가세요.',
              romaji: 'O-reun-jjo-geu-ro ga-se-yo.',
              indonesian: 'Silakan pergi ke arah kanan.',
              breakdownNote: '오른쪽 (kanan, batchim ㄱ) + 으로 (arah)',
            ),
            TopikGrammarExample(
              korean: '지하철로 회사에 가요.',
              romaji: 'Ji-ha-cheol-lo hoe-sa-e ga-yo.',
              indonesian: 'Pergi ke kantor naik kereta bawah tanah.',
              breakdownNote: '지하철 (batchim ㄹ) + 로 (alat transportasi)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '도 & 의',
          romaji: 'do & ui (e)',
          title: 'Partikel Penambahan (Juga) & Kepemilikan',
          ruleSummary:
              '• 도 (do): juga / pun (menggantikan 은/는, 이/가, 을/를)\n• 의 (ui, dibaca "e"): kepemilikan (-nya)',
          detailedUsage:
              '도 ditempelkan langsung pada kata benda untuk menyatakan "juga". 의 menghubungkan pemilik dengan benda yang dimiliki (저의 → 제 = milik saya).',
          examples: [
            TopikGrammarExample(
              korean: '저도 한국 음식을 좋아해요.',
              romaji: 'Jeo-do han-guk eum-si-geul jo-a-hae-yo.',
              indonesian: 'Saya juga suka makanan Korea.',
              breakdownNote: '저 (saya) + 도 (juga)',
            ),
            TopikGrammarExample(
              korean: '이것은 선생님의 책입니다.',
              romaji: 'I-geo-seun seon-saeng-nim-ui chaeg-im-ni-da.',
              indonesian: 'Ini adalah bukunya guru.',
              breakdownNote: '선생님 (guru) + 의 (kepemilikan) + 책 (buku)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '와/과, (이)랑, 하고',
          romaji: 'wa/gwa, (i)rang, ha-go',
          title: 'Penghubung Kata Benda (Dan / Bersama)',
          ruleSummary:
              '• Vokal: 와 / 랑 / 하고\n• Konsonan (Batchim): 과 / 이랑 / 하고',
          detailedUsage:
              'Menghubungkan dua kata benda ("dan") atau menyatakan melakukan sesuatu "bersama" seseorang. 와/과 lebih sering dipakai dalam tulisan formal, sedangkan (이)랑 dan 하고 sangat sering dipakai dalam percakapan sehari-hari.',
          examples: [
            TopikGrammarExample(
              korean: '빵과 우유를 샀어요.',
              romaji: 'Ppang-gwa u-yu-reul sa-sseo-yo.',
              indonesian: 'Saya membeli roti dan susu.',
              breakdownNote: '빵 (roti, batchim ㅇ) + 과 (dan) + 우유 (susu)',
            ),
            TopikGrammarExample(
              korean: '친구랑 같이 영화를 봐요.',
              romaji: 'Chin-gu-rang ga-chi yeong-hwa-reul bwa-yo.',
              indonesian: 'Menonton film bersama teman.',
              breakdownNote: '친구 (teman, vokal) + 랑 (bersama)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '부터 ~ 까지 & 만',
          romaji: 'bu-teo ~ kka-ji & man',
          title: 'Partikel Batasan (Dari ~ Sampai & Hanya)',
          ruleSummary:
              '• 부터 (bu-teo): dari (biasanya waktu)\n• 까지 (kka-ji): sampai (waktu/tempat)\n• 만 (man): hanya / saja',
          detailedUsage:
              '부터 ~ 까지 digunakan untuk menyatakan rentang waktu (misal: dari jam 9 sampai jam 5). untuk tempat biasanya menggunakan 에서 ~ 까지. 만 berarti "hanya".',
          examples: [
            TopikGrammarExample(
              korean: '9시부터 5시까지 일해요.',
              romaji: 'A-hop-si-bu-teo da-seot-si-kka-ji il-hae-yo.',
              indonesian: 'Bekerja dari jam 9 sampai jam 5.',
              breakdownNote: '9시 + 부터 (dari) ~ 5시 + 까지 (sampai)',
            ),
            TopikGrammarExample(
              korean: '물만 마셔요.',
              romaji: 'Mul-man ma-syeo-yo.',
              indonesian: 'Hanya minum air saja.',
              breakdownNote: '물 (air) + 만 (hanya)',
            ),
          ],
        ),
      ],
    ),

    // 2. AKHIRAN KALIMAT FORMAL & INFORMAL
    TopikGrammarGroup(
      groupTitle: '2. Akhiran Kalimat Formal & Informal',
      groupSubtitle:
          'Perubahan kata kerja/sifat ke bentuk formal, sopan, lampau, masa depan, dan perintah',
      items: [
        TopikGrammarItem(
          pattern: '-ㅂ니다/습니다 & -ㅂ니까/습니까?',
          romaji: '-mnida/seumnida & -mnikka/seumnikka?',
          title: 'Akhiran Kalimat Formal Resmi (하십시오체)',
          ruleSummary:
              '• Akar kata berakhir Vokal: tambahkan -ㅂ니다 / -ㅂ니까?\n• Akar kata berakhir Konsonan: tambahkan -습니다 / -습니까?',
          detailedUsage:
              'Digunakan pada situasi resmi seperti berita, presentasi, wawancara kerja, atau berbicara kepada orang yang jauh lebih dihormati.',
          examples: [
            TopikGrammarExample(
              korean: '학교에 갑니다. / 어디에 갑니까?',
              romaji: 'Hak-gyo-e gam-ni-da. / Eo-di-e gam-ni-kka?',
              indonesian: 'Pergi ke sekolah. / Pergi ke mana?',
              breakdownNote: '가다 (pergi, vokal ㅏ) → 갑니다 / 갑니까?',
            ),
            TopikGrammarExample(
              korean: '한국어를 읽습니다.',
              romaji: 'Han-gu-geo-reul ik-sseum-ni-da.',
              indonesian: 'Membaca bahasa Korea.',
              breakdownNote: '읽다 (membaca, konsonan) → 읽습니다',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-아/어요',
          romaji: '-a/eo-yo',
          title: 'Akhiran Kalimat Informal Sopan (해요체)',
          ruleSummary:
              '• Vokal akhir ㅏ atau ㅗ: + -아요\n• Vokal akhir selain ㅏ/ㅗ: + -어요\n• Kata berakhiran 하다: berubah menjadi 해요',
          detailedUsage:
              'Bentuk paling penting dan paling sering digunakan dalam percakapan sehari-hari di Korea untuk menyatakan kalimat berita maupun kalimat tanya secara sopan.',
          examples: [
            TopikGrammarExample(
              korean: '커피를 마셔요.',
              romaji: 'Keo-pi-reul ma-syeo-yo.',
              indonesian: 'Minum kopi.',
              breakdownNote: '마시다 (ㅣ) + 어요 → 마셔요',
            ),
            TopikGrammarExample(
              korean: '운동을 해요.',
              romaji: 'Un-dong-eul hae-yo.',
              indonesian: 'Berolahraga.',
              breakdownNote: '운동하다 → 운동해요',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-았/었어요',
          romaji: '-at/eot-seo-yo',
          title: 'Akhiran Bentuk Lampau (Past Tense)',
          ruleSummary:
              '• Vokal ㅏ/ㅗ: + -았어요\n• Vokal selain ㅏ/ㅗ: + -었어요\n• 하다: berubah menjadi 했어요',
          detailedUsage:
              'Digunakan untuk menceritakan kejadian atau aktivitas yang sudah selesai terjadi di masa lampau (kemarin, minggu lalu, tadi).',
          examples: [
            TopikGrammarExample(
              korean: '어제 친구를 만났어요.',
              romaji: 'Eo-je chin-gu-reul man-na-sseo-yo.',
              indonesian: 'Kemarin saya bertemu teman.',
              breakdownNote: '만나다 (ㅏ) + 았어요 → 만났어요',
            ),
            TopikGrammarExample(
              korean: '주말에 영화를 봤어요.',
              romaji: 'Ju-mal-e yeong-hwa-reul bwa-sseo-yo.',
              indonesian: 'Pada akhir pekan saya menonton film.',
              breakdownNote: '보다 (ㅗ) + 았어요 → 봤어요',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-(으)ㄹ 거예요 & -겠-',
          romaji: '-(eu)l geo-ye-yo & -get-',
          title: 'Akhiran Bentuk Masa Depan (Future Tense)',
          ruleSummary:
              '• Vokal / Batchim ㄹ: + -ㄹ 거예요\n• Batchim selain ㄹ: + -을 거예요\n• -겠어요: tekad pembicara / dugaan',
          detailedUsage:
              '-(으)ㄹ 거예요 menyatakan rencana di masa depan ("akan..."). Sedangkan -겠- menyatakan niat kuat pembicara atau ungkapan tetap seperti "잘 먹겠습니다" (selamat makan).',
          examples: [
            TopikGrammarExample(
              korean: '내일 한국에 갈 거예요.',
              romaji: 'Nae-il han-gu-ge gal geo-ye-yo.',
              indonesian: 'Besok saya akan pergi ke Korea.',
              breakdownNote: '가다 (vokal) + -ㄹ 거예요 → 갈 거예요',
            ),
            TopikGrammarExample(
              korean: '열심히 공부하겠습니다!',
              romaji: 'Yeol-sim-hi gong-bu-ha-get-sseum-ni-da!',
              indonesian: 'Saya akan belajar dengan giat!',
              breakdownNote: '공부하- + -겠- (tekad) + -습니다',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-(으)ㅂ시다, -(으)세요, -지 마세요',
          romaji: '-(eu)psida, -(eu)seyo, -ji maseyo',
          title: 'Kalimat Ajakan, Perintah Sopan & Larangan',
          ruleSummary:
              '• -(으)ㅂ시다: Mari kita...\n• -(으)세요: Silakan / Tolong...\n• -지 마세요: Jangan...',
          detailedUsage:
              '-(으)ㅂ시다 mengajak lawan bicara melakukan sesuatu bersama. -(으)세요 meminta dengan sopan. -지 마세요 melarang secara sopan (ditempel langsung pada akar kata kerja tanpa melihat vokal/konsonan).',
          examples: [
            TopikGrammarExample(
              korean: '같이 점심을 먹읍시다.',
              romaji: 'Ga-chi jeom-sim-eul meo-geup-si-da.',
              indonesian: 'Mari kita makan siang bersama.',
              breakdownNote: '먹다 (konsonan) + -읍시다',
            ),
            TopikGrammarExample(
              korean: '여기에 앉으세요. 사진을 찍지 마세요.',
              romaji: 'Yeo-gi-e an-jeu-se-yo. Sa-jin-eul jjik-ji ma-se-yo.',
              indonesian: 'Silakan duduk di sini. Jangan memotret.',
              breakdownNote: '앉다 + 으세요 (perintah) | 찍다 + 지 마세요 (larangan)',
            ),
          ],
        ),
      ],
    ),

    // 3. KATA SAMBUNG & KONJUNGSI (연결 어미)
    TopikGrammarGroup(
      groupTitle: '3. Kata Sambung & Konjungsi (연결 어미)',
      groupSubtitle:
          'Alasan, urutan, pertentangan, penjumlahan, syarat, tujuan, keinginan, dan kemampuan',
      items: [
        TopikGrammarItem(
          pattern: '-아/어서 & -(으)니까',
          romaji: '-a/eo-seo & -(eu)nikka',
          title: 'Konjungsi Alasan (Karena) & Urutan Kejadian',
          ruleSummary:
              '• -아/어서: tidak boleh diikuti kalimat perintah/ajakan\n• -(으)니까: BOLEH diikuti kalimat perintah (-세요) atau ajakan (-ㅂ시다)',
          detailedUsage:
              'Keduanya berarti "karena / jadi". Perbedaan terpenting dalam ujian TOPIK I: gunakan -(으)니까 jika klausa kedua berupa ajakan atau perintah!',
          examples: [
            TopikGrammarExample(
              korean: '배가 고파서 밥을 먹었어요.',
              romaji: 'Bae-ga go-pa-seo bab-eul meo-geo-sseo-yo.',
              indonesian: 'Karena lapar, saya makan nasi.',
              breakdownNote: '고프다 → 고파서 (alasan pernyataan biasa)',
            ),
            TopikGrammarExample(
              korean: '비가 오니까 우산을 가져가세요.',
              romaji: 'Bi-ga o-ni-kka u-san-eul ga-jyeo-ga-se-yo.',
              indonesian: 'Karena turun hujan, silakan bawa payung.',
              breakdownNote: '오다 + 니까 + kalimat perintah (-세요)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-지만, 그런데 & -고',
          romaji: '-jiman, geureonde & -go',
          title: 'Pertentangan (Tetapi) & Penjumlahan (Dan / Lalu)',
          ruleSummary:
              '• -지만: tetapi (menggabungkan 2 klausa)\n• 그런데: ngomong-ngomong / tetapi (awal kalimat)\n• -고: dan / lalu',
          detailedUsage:
              '-지만 ditempelkan langsung pada akar kata kerja/sifat untuk menyatakan pertentangan. -고 digunakan untuk menggabungkan dua kalimat setara ("dan") atau urutan aksi ("lalu").',
          examples: [
            TopikGrammarExample(
              korean: '한국어는 어렵지만 재미있어요.',
              romaji: 'Han-gu-geo-neun eo-ryeop-ji-man jae-mi-i-sseo-yo.',
              indonesian: 'Bahasa Korea itu sulit tetapi menarik.',
              breakdownNote: '어렵다 (sulit) + -지만 (tetapi) + 재미있어요 (menarik)',
            ),
            TopikGrammarExample(
              korean: '손을 씻고 밥을 먹어요.',
              romaji: 'Son-eul ssit-go bab-eul meo-geo-yo.',
              indonesian: 'Mencuci tangan lalu makan nasi.',
              breakdownNote: '씻다 (mencuci) + -고 (lalu)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-(으)면 & -(으)러 가다/오다',
          romaji: '-(eu)myeon & -(eu)reo gada/oda',
          title: 'Syarat (Jika/Kalau) & Tujuan Kepergian (Pergi Untuk...)',
          ruleSummary:
              '• -(으)면: jika / kalau\n• -(으)러 가다/오다: pergi/datang untuk melakukan sesuatu',
          detailedUsage:
              '-(으)면 menyatakan pengandaian atau syarat. -(으)러 hanya dapat diikuti oleh kata kerja perpindahan seperti 가다 (pergi), 오다 (datang), atau 다니다.',
          examples: [
            TopikGrammarExample(
              korean: '시간이 있으면 같이 영화 봐요.',
              romaji: 'Si-gan-i i-sseu-myeon ga-chi yeong-hwa bwa-yo.',
              indonesian: 'Kalau ada waktu, ayo nonton film bersama.',
              breakdownNote: '있다 (ada) + -으면 (jika)',
            ),
            TopikGrammarExample(
              korean: '책을 빌리러 도서관에 가요.',
              romaji: 'Chaeg-eul bil-li-reo do-seo-gwan-e ga-yo.',
              indonesian: 'Pergi ke perpustakaan untuk meminjam buku.',
              breakdownNote: '빌리다 (meminjam) + -러 가요 (pergi untuk)',
            ),
          ],
        ),
        TopikGrammarItem(
          pattern: '-고 싶다 & -(으)ㄹ 수 있다/없다',
          romaji: '-go sipda & -(eu)l su itda/eopda',
          title: 'Keinginan (Ingin) & Kemampuan (Bisa / Tidak Bisa)',
          ruleSummary:
              '• Akar Kata Kerja + -고 싶어요: ingin...\n• Akar Kata Kerja + -(으)ㄹ 수 있어요/없어요: bisa / tidak bisa...',
          detailedUsage:
              'Gunakan -고 싶다 untuk menyatakan keinginan subjek orang pertama ("Saya ingin..."). Gunakan -(으)ㄹ 수 있다/없다 untuk menyatakan kemampuan atau kemungkinan.',
          examples: [
            TopikGrammarExample(
              korean: '한국에 가고 싶어요.',
              romaji: 'Han-gu-ge ga-go si-peo-yo.',
              indonesian: 'Saya ingin pergi ke Korea.',
              breakdownNote: '가다 (pergi) + -고 싶어요 (ingin)',
            ),
            TopikGrammarExample(
              korean: '한글을 읽을 수 있어요.',
              romaji: 'Han-geul-eul il-geul su i-sseo-yo.',
              indonesian: 'Saya bisa membaca Hangeul.',
              breakdownNote: '읽다 (membaca, konsonan) + -을 수 있어요 (bisa)',
            ),
          ],
        ),
      ],
    ),

    // 4. BENTUK KEHORMATAN (높임말)
    TopikGrammarGroup(
      groupTitle: '4. Bentuk Kehormatan (높임말 / Honorifik)',
      groupSubtitle:
          'Sisipan kehormatan -(으)시- serta kosa kata khusus untuk menghormati orang yang lebih tua',
      items: [
        TopikGrammarItem(
          pattern: '-(으)시- & Kosa Kata Honorifik',
          romaji: '-(eu)si- & Honorific Words',
          title: 'Penanda Kehormatan Subjek & Kata Kerja Khusus',
          ruleSummary:
              '• Vokal: + -시- (가다 → 가시다)\n• Konsonan: + -으시- (읽다 → 읽으시다)\n• Kata khusus: 드시다 (makan), 주무시다 (tidur), 말씀하시다 (bicara), 댁 (rumah), 성함 (nama), 연세 (usia)',
          detailedUsage:
              'Digunakan ketika subjek kalimat adalah orang yang dihormati (orang tua, kakek/nenek, guru, atasan). Partikel subjek 이/가 juga berubah menjadi 께서.',
          examples: [
            TopikGrammarExample(
              korean: '할머니께서 진지를 드십니다.',
              romaji: 'Hal-meo-ni-kke-seo jin-ji-reul deu-sim-ni-da.',
              indonesian: 'Nenek sedang makan nasi (bentuk hormat).',
              breakdownNote: '께서 (partikel subjek hormat) + 진지 (nasi) + 드시다 (makan)',
            ),
            TopikGrammarExample(
              korean: '부모님께서는 지금 주무세요.',
              romaji: 'Bu-mo-nim-kke-seo-neun ji-geum ju-mu-se-yo.',
              indonesian: 'Orang tua sekarang sedang tidur.',
              breakdownNote: '자다 (tidur) → bentuk hormat: 주무시다 (주무세요)',
            ),
          ],
        ),
      ],
    ),
  ];

  /// ==========================================================================
  /// BAGIAN 2: KOSA KATA & TEMA SEHARI-HARI TOPIK I (어휘 / VOCABULARY)
  /// ==========================================================================
  static const List<TopikVocabTheme> vocabThemes = [
    // 1. IDENTITAS & PERKENALAN DIRI
    TopikVocabTheme(
      themeTitle: '1. Identitas & Perkenalan Diri',
      themeKorean: '자기소개 • 가족 • 직업',
      description: 'Nama, kebangsaan (나라/국적), pekerjaan (직업), dan anggota keluarga (가족)',
      words: [
        TopikVocabEntry(
          hangeul: '나라 / 국적',
          romaji: 'na-ra / guk-jeok',
          indonesian: 'Negara / Kebangsaan',
          syllableBreakdown: '나(ㄴ+ㅏ) + 라(ㄹ+ㅏ) / 국(ㄱ+ㅜ+ㄱ) + 적(ㅈ+ㅓ+ㄱ)',
          exampleSentence: '어느 나라 사람입니까?',
          exampleMeaning: 'Anda orang negara mana?',
        ),
        TopikVocabEntry(
          hangeul: '직업',
          romaji: 'ji-geop',
          indonesian: 'Pekerjaan / Profesi',
          syllableBreakdown: '직 (ㅈ+ㅣ+ㄱ) + 업 (ㅇ+ㅓ+ㅂ)',
          exampleSentence: '제 직업은 회사원입니다.',
          exampleMeaning: 'Pekerjaan saya adalah karyawan kantor.',
        ),
        TopikVocabEntry(
          hangeul: '학생 & 선생님',
          romaji: 'hak-saeng & seon-saeng-nim',
          indonesian: 'Pelajar & Guru',
          syllableBreakdown: '학(ㅎ+ㅏ+ㄱ)+생(ㅅ+ㅐ+ㅇ) / 선(ㅅ+ㅓ+ㄴ)+생+님',
          exampleSentence: '저는 한국어 학생입니다.',
          exampleMeaning: 'Saya adalah pelajar bahasa Korea.',
        ),
        TopikVocabEntry(
          hangeul: '가족 (부모님)',
          romaji: 'ga-jok (bu-mo-nim)',
          indonesian: 'Keluarga (Orang Tua)',
          syllableBreakdown: '가 (ㄱ+ㅏ) + 족 (ㅈ+ㅗ+ㄱ)',
          exampleSentence: '우리 가족은 네 명이에요.',
          exampleMeaning: 'Keluarga kami berjumlah 4 orang.',
        ),
      ],
    ),

    // 2. ANGKA & SATUAN HITUNG
    TopikVocabTheme(
      themeTitle: '2. Angka & Satuan Hitung',
      themeKorean: '숫자 • 단위 명사',
      description:
          'Sino-Korea (tanggal, uang, telepon, menit) & Asli Korea (jam, usia, satuan: 개, 명, 병, 권, 마리)',
      words: [
        TopikVocabEntry(
          hangeul: '개 & 명',
          romaji: 'gae & myeong',
          indonesian: 'Buah (satuan benda) & Orang (satuan manusia)',
          syllableBreakdown: '개 (ㄱ+ㅐ) & 명 (ㅁ+ㅕ+ㅇ)',
          exampleSentence: '사과 한 개하고 친구 두 명.',
          exampleMeaning: '1 buah apel dan 2 orang teman.',
        ),
        TopikVocabEntry(
          hangeul: '병, 권, 마리',
          romaji: 'byeong, gwon, ma-ri',
          indonesian: 'Botol, Jilid (buku), Ekor (hewan)',
          syllableBreakdown: '병(ㅂ+ㅕ+ㅇ) / 권(ㄱ+ㅝ+ㄴ) / 마(ㅁ+ㅏ)+리(ㄹ+ㅣ)',
          exampleSentence: '물 한 병과 책 세 권을 샀어요.',
          exampleMeaning: 'Membeli 1 botol air dan 3 jilid buku.',
        ),
        TopikVocabEntry(
          hangeul: '원 (돈)',
          romaji: 'won (don)',
          indonesian: 'Won / Mata Uang Korea (Uang)',
          syllableBreakdown: '원 (ㅇ+ㅝ+ㄴ) / 돈 (ㄷ+ㅗ+ㄴ)',
          exampleSentence: '이 가방은 만 원입니다.',
          exampleMeaning: 'Tas ini harganya 10.000 Won.',
        ),
        TopikVocabEntry(
          hangeul: '시 & 분',
          romaji: 'si & bun',
          indonesian: 'Jam (Asli Korea) & Menit (Sino-Korea)',
          syllableBreakdown: '시 (ㅅ+ㅣ) & 분 (ㅂ+ㅜ+ㄴ)',
          exampleSentence: '지금은 두 시 삼십 분이에요.',
          exampleMeaning: 'Sekarang jam 2 lewat 30 menit.',
        ),
      ],
    ),

    // 3. WAKTU & PENANGGALAN
    TopikVocabTheme(
      themeTitle: '3. Waktu & Penanggalan',
      themeKorean: '시간 • 요일 • 날짜',
      description:
          'Hari dalam seminggu, bulan, kemarin (어제), hari ini (오늘), besok (내일), akhir pekan (주말)',
      words: [
        TopikVocabEntry(
          hangeul: '어제, 오늘, 내일',
          romaji: 'eo-je, o-neul, nae-il',
          indonesian: 'Kemarin, Hari ini, Besok',
          syllableBreakdown: '어제(ㅇ+ㅓ/ㅈ+ㅔ) • 오늘(ㅇ+ㅗ/ㄴ+ㅡ+ㄹ) • 내일(ㄴ+ㅐ/ㅇ+ㅣ+ㄹ)',
          exampleSentence: '오늘은 일하고 내일은 쉬어요.',
          exampleMeaning: 'Hari ini bekerja dan besok libur/istirahat.',
        ),
        TopikVocabEntry(
          hangeul: '주말 & 평일',
          romaji: 'ju-mal & pyeong-il',
          indonesian: 'Akhir Pekan & Hari Kerja',
          syllableBreakdown: '주 (ㅈ+ㅜ) + 말 (ㅁ+ㅏ+ㄹ)',
          exampleSentence: '주말에 보통 뭐 해요?',
          exampleMeaning: 'Biasanya melakukan apa pada akhir pekan?',
        ),
        TopikVocabEntry(
          hangeul: '월요일 ~ 일요일',
          romaji: 'wol-yo-il ~ il-yo-il',
          indonesian: 'Hari Senin s/d Hari Minggu',
          syllableBreakdown: '월(Senin), 화(Selasa), 수(Rabu), 목(Kamis), 금(Jumat), 토(Sabtu), 일(Minggu)',
          exampleSentence: '금요일에 시험이 있어요.',
          exampleMeaning: 'Pada hari Jumat ada ujian.',
        ),
      ],
    ),

    // 4. LOKASI & ARAH
    TopikVocabTheme(
      themeTitle: '4. Lokasi, Posisi & Tempat Umum',
      themeKorean: '위치 • 방향 • 장소',
      description:
          'Atas/bawah (위/아래), depan/belakang (앞/뒤), dalam/luar (안/밖), kiri/kanan, stasiun, bandara, bank, RS',
      words: [
        TopikVocabEntry(
          hangeul: '위 / 아래 (밑)',
          romaji: 'wi / a-rae (mit)',
          indonesian: 'Atas / Bawah',
          syllableBreakdown: '위 (ㅇ+ㅟ) / 아 (ㅇ+ㅏ) + 래 (ㄹ+ㅐ)',
          exampleSentence: '책상 위에 컴퓨터가 있어요.',
          exampleMeaning: 'Di atas meja ada komputer.',
        ),
        TopikVocabEntry(
          hangeul: '앞 / 뒤 & 안 / 밖',
          romaji: 'ap / dwi & an / bak',
          indonesian: 'Depan / Belakang & Dalam / Luar',
          syllableBreakdown: '앞(ㅇ+ㅏ+ㅍ) • 뒤(ㄷ+ㅟ) • 안(ㅇ+ㅏ+ㄴ) • 밖(ㅂ+ㅏ+ㄲ)',
          exampleSentence: '학교 앞에서 만나요.',
          exampleMeaning: 'Ayo bertemu di depan sekolah.',
        ),
        TopikVocabEntry(
          hangeul: '왼쪽 / 오른쪽',
          romaji: 'oen-jjok / o-reun-jjok',
          indonesian: 'Sebelah Kiri / Sebelah Kanan',
          syllableBreakdown: '왼(ㅇ+ㅚ+ㄴ)+쪽(ㅉ+ㅗ+ㄱ) / 오+른(ㄹ+ㅡ+ㄴ)+쪽',
          exampleSentence: '은행은 병원 오른쪽에 있어요.',
          exampleMeaning: 'Bank berada di sebelah kanan rumah sakit.',
        ),
        TopikVocabEntry(
          hangeul: '역, 공항, 시장, 병원, 우체국',
          romaji: 'yeok, gong-hang, si-jang, byeong-won, u-che-guk',
          indonesian: 'Stasiun, Bandara, Pasar, Rumah Sakit, Kantor Pos',
          syllableBreakdown: '역(Stasiun) • 공항(Bandara) • 시장(Pasar) • 병원(RS)',
          exampleSentence: '우체국에서 소포를 보내요.',
          exampleMeaning: 'Mengirim paket di kantor pos.',
        ),
      ],
    ),

    // 5. AKTIVITAS HARIAN
    TopikVocabTheme(
      themeTitle: '5. Aktivitas Harian, Cuaca & Musim',
      themeKorean: '일상생활 • 식당 • 날씨 • 계절',
      description:
          'Belanja (쇼핑), memesan di restoran (식당), hobi/olahraga (취미/운동), cuaca & musim (날씨/계절)',
      words: [
        TopikVocabEntry(
          hangeul: '쇼핑 & 식당',
          romaji: 'syo-ping & sik-dang',
          indonesian: 'Belanja & Restoran / Rumah Makan',
          syllableBreakdown: '쇼(ㅅ+ㅛ)+핑(ㅍ+ㅣ+ㅇ) & 식(ㅅ+ㅣ+ㄱ)+당(ㄷ+ㅏ+ㅇ)',
          exampleSentence: '백화점에서 쇼핑하고 식당에서 밥을 먹어요.',
          exampleMeaning: 'Belanja di mal lalu makan di restoran.',
        ),
        TopikVocabEntry(
          hangeul: '취미 & 운동',
          romaji: 'chwi-mi & un-dong',
          indonesian: 'Hobi & Olahraga',
          syllableBreakdown: '취(ㅊ+ㅟ)+미(ㅁ+ㅣ) & 운(ㅇ+ㅜ+ㄴ)+동(ㄷ+ㅗ+ㅇ)',
          exampleSentence: '제 취미는 수영과 축구입니다.',
          exampleMeaning: 'Hobi saya adalah berenang dan sepak bola.',
        ),
        TopikVocabEntry(
          hangeul: '날씨 & 사계절 (봄, 여름, 가을, 겨울)',
          romaji: 'nal-ssi & sa-gye-jeol (bom, yeo-reum, ga-eul, gyeo-ul)',
          indonesian: 'Cuaca & 4 Musim (Semi, Panas, Gugur, Dingin)',
          syllableBreakdown: '봄(Semi) • 여름(Panas) • 가을(Gugur) • 겨울(Dingin)',
          exampleSentence: '여름은 덥고 겨울은 추워요.',
          exampleMeaning: 'Musim panas itu panas dan musim dingin itu dingin.',
        ),
      ],
    ),

    // 6. TRANSPORTASI
    TopikVocabTheme(
      themeTitle: '6. Transportasi & Perjalanan',
      themeKorean: '교통수단 • 타다 / 내리다 / 환승',
      description:
          'Kereta bawah tanah (지하철), bus (버스), taksi (택시), transfer jalur (환승), naik/turun (타다/내리다)',
      words: [
        TopikVocabEntry(
          hangeul: '지하철, 버스, 택시',
          romaji: 'ji-ha-cheol, beo-seu, taek-si',
          indonesian: 'Kereta Bawah Tanah (Subway), Bus, Taksi',
          syllableBreakdown: '지(ㅈ+ㅣ)+하(ㅎ+ㅏ)+철(ㅊ+ㅓ+ㄹ) • 버+스 • 택+시',
          exampleSentence: '아침에는 지하철이 버스보다 빨라요.',
          exampleMeaning: 'Pada pagi hari kereta bawah tanah lebih cepat daripada bus.',
        ),
        TopikVocabEntry(
          hangeul: '타다 & 내리다',
          romaji: 'ta-da & nae-ri-da',
          indonesian: 'Naik (Kendaraan) & Turun (Kendaraan)',
          syllableBreakdown: '타 (ㅌ+ㅏ) + 다 (ㄷ+ㅏ) & 내 (ㄴ+ㅐ) + 리 + 다',
          exampleSentence: '서울역에서 버스를 타고 시청역에서 내려요.',
          exampleMeaning: 'Naik bus di Stasiun Seoul lalu turun di Stasiun Balai Kota.',
        ),
        TopikVocabEntry(
          hangeul: '환승하다 (갈아타다)',
          romaji: 'hwan-seung-ha-da (ga-ra-ta-da)',
          indonesian: 'Transfer / Berganti Jalur Kendaraan',
          syllableBreakdown: '환 (ㅎ+ㅘ+ㄴ) + 승 (ㅅ+ㅡ+ㅇ) + 하 + 다',
          exampleSentence: '이번 역에서 2호선으로 환승하세요.',
          exampleMeaning: 'Silakan transfer ke Jalur 2 di stasiun ini.',
        ),
      ],
    ),
  ];
}

