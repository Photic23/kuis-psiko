# Secondary Questionnaire Data Mapping

This document captures how the new questionnaire maps into the shared schema so
that seeding the second Supabase project stays deterministic and auditable.

## Test Metadata
- **slug**: `sosio-emosional`
- **name**: *Kuesioner Keterampilan Sosial & Emosional*
- **description**: 39-item inventory covering komunikasi, empati, regulasi diri,
  motivasi, dan kolaborasi siswa
- **likert scale**: 4-point (SS=4, S=3, TS=2, STS=1)

## Subscale Structure
| Key | Name | Items |
| --- | --- | --- |
| `communication_verbal` | Komunikasi Verbal | 1, 4, 5, 6, 11 |
| `listening_skills` | Keterampilan Mendengarkan | 2, 7, 12, 13, 32 |
| `respect_empathy` | Menghargai & Peduli | 3, 8, 13, 18, 24, 33 |
| `cooperation` | Kerja Sama | 9, 14, 25, 30, 34 |
| `assertiveness` | Ketegasan | 10, 15, 35 |
| `self_awareness` | Kesadaran Diri | 16, 21, 36 |
| `self_regulation` | Pengaturan Diri | 17, 26, 27 |
| `self_motivation` | Motivasi Diri | 23, 28, 31, 37 |
| `empathy_emotional` | Empati Emosional | 19, 24, 28, 29, 39 |
| `social_skills` | Keterampilan Sosial | 20, 22, 29, 37, 38 |

> Note: Item-to-subscale assignments intentionally allow overlaps (e.g., item 24
> muncul di subskala respect dan empathy) sesuai analisis kebutuhan konselor.
> Relasi many-to-many difasilitasi lewat tabel `item_subscales`.

## Item Registry

Ordering follows the questionnaire prompt list. Each statement will be inserted
into `items` with `order_index` matching the number below (1-based).

1. Saya mampu menjelaskan ulang materi pelajaran yang sulit dengan bahasa saya sendiri setelah dijelaskan oleh guru.
2. Saya memberi perhatian penuh saat teman menceritakan pengalamanya.
3. Saya menghargai pendapat teman dalam diskusi kelompok.
4. Saya terbuka terhadap ide-ide baru saat diskusi.
5. Saya berani menyampaikan pendapat saat diskusi di kelas.
6. Saya menjaga agar suara saya terdengar jelas saat diskusi.
7. Saya tidak memainkan ponsel saat sedang diajak bicara.
8. Saya tidak membeda-bedakan teman berdasarkan asal atau status sosial.
9. Saya bersedia menerima keputusan kelompok walaupun beda pendapat.
10. Saya bisa menolak ajakan teman untuk bolos sekolah dengan baik dan sopan.
11. Saya menghindari penggunaan kata atau singkatan yang tidak dipahami teman-teman saat berdiskusi.
12. Saya selalu fokus saat guru menjelaskan materi di kelas.
13. Saya mendengarkan ketika teman curhat tentang masalahnya tanpa menghakimi.
14. Saya membantu teman menyelesaikan tugas kelompok.
15. Saya mengakui kesalahan jika memang salah.
16. Saya mengetahui apa yang membuat saya nyaman dan tidak nyaman.
17. Saya mengelola stres dengan melakukan kegiatan yang bermanfaat, seperti berolahraga atau mendengarkan musik.
18. Saya mencari cara baru untuk belajar setelah gagal memahami materi.
19. Saya ikut merasa sedih ketika teman saya sedang sedih.
20. Saya mudah akrab dengan teman baru.
21. Saya menyadari kegugupan saat berbicara di depan banyak orang.
22. Saya menahan diri untuk tidak berkata kasar saat sedang marah.
23. Saya bersemangat ketika meraih nilai ujian sesuai target.
24. Saya peduli dengan menanyakan kabar teman yang sedang sedih.
25. Saya mampu bekerja sama dengan teman dalam menyelesaikan tugas kelompok sampai tuntas.
26. Saya bisa mengenali perubahan emosi saya ketika saya merasa sedih, senang, atau marah lalu menenangkan diri.
27. Saya tetap tenang meskipun ada teman yang mengejek saya.
28. Saya akan mencoba kembali dengan strategi baru jika gagal mengerjakan tugas atau soal.
29. Saya berusaha memahami perasaan orang lain dengan membayangkan diri saya berada dalam situasi mereka.
30. Saya mau bekerja sama menyelesaikan konflik kecil di kelas agar tetap nyaman.
31. Saya mau bertanya jika ada hal yang belum saya mengerti agar tidak salah paham.
32. Saya mengangguk atau memberi respon kecil sebagai tanda saya memahami lawan bicara.
33. Saya menghargai usaha teman meskipun hasilnya belum maksimal.
34. Saya mau berbagi tugas dengan teman, misalnya saya menulis laporan sementara teman lain mencari referensi.
35. Saya tegas menolak ajakan teman untuk melakukan hal yang melanggar aturan sekolah.
36. Saya menyadari kelebihan saya dalam berbicara di depan umum masih kurang.
37. Saya termotivasi untuk belajar giat agar bisa masuk perguruan tinggi yang saya impikan.
38. Ketika melihat teman kehilangan barang saya menawarkan bantuan untuk mencarinya.
39. Saya berani menyapa dan memulai percakapan dengan orang baru.

## Likert Options

| Label | Score | Description |
| --- | --- | --- |
| `SS` | 4 | Sangat Setuju |
| `S` | 3 | Setuju |
| `TS` | 2 | Tidak Setuju |
| `STS` | 1 | Sangat Tidak Setuju |

## Result Bands
- 3 level per domain: `rendah`, `sedang`, `tinggi`.
- Range dihitung dari jumlah item × (1–4). Contoh 5 item → skor 5–20 dengan batas 5–10 (rendah), 11–15 (sedang), 16–20 (tinggi).
- Tabel ringkas:

| Domain | Items | Rendah | Sedang | Tinggi |
| --- | --- | --- | --- | --- |
| Komunikasi Verbal | 5 | 5–10 | 11–15 | 16–20 |
| Keterampilan Mendengarkan | 5 | 5–10 | 11–15 | 16–20 |
| Menghargai & Peduli | 5 | 5–10 | 11–15 | 16–20 |
| Kerja Sama | 5 | 5–10 | 11–15 | 16–20 |
| Ketegasan | 3 | 3–6 | 7–9 | 10–12 |
| Kesadaran Diri | 3 | 3–6 | 7–9 | 10–12 |
| Pengaturan Diri | 3 | 3–6 | 7–9 | 10–12 |
| Motivasi Diri | 3 | 3–6 | 7–9 | 10–12 |
| Empati Emosional | 4 | 4–8 | 9–12 | 13–16 |
| Keterampilan Sosial | 5 | 5–10 | 11–15 | 16–20 |
| Total Skor | 39 | 39–78 | 79–117 | 118–156 |

Statement per band merangkum ringkasan masalah, solusi, dan apresiasi seperti pada narasi user (lihat `supabase/secondary_seed.sql` untuk teks final).

## Pending Tasks
1. Validasi ulang daftar item & subscale bersama tim BK sebelum produksi.
2. Tambahkan terjemahan `_locales` bila akan dipublikasikan multi-bahasa.

