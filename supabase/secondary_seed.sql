-- Seed data for the socio-emotional skills questionnaire (secondary DB)
-- Execute against the second Supabase project after running the mirrored schema migration.

-- Ensure base test record exists / updated
insert into tests (slug, name, description)
values (
  'sosio-emosional',
  'Inventori Sosio-Emosional Siswa',
  '39 pernyataan Likert untuk komunikasi, empati, regulasi diri, motivasi, dan kolaborasi'
)
on conflict (slug) do update
set name = excluded.name,
    description = excluded.description,
    is_active = true;

-- Cleanup previous seed for idempotency
with t as (select id as test_id from tests where slug = 'sosio-emosional')
delete from result_bands where test_id in (select test_id from t);
with t as (select id as test_id from tests where slug = 'sosio-emosional')
delete from item_subscales using items i
where item_subscales.item_id = i.id and i.test_id in (select test_id from t);
with t as (select id as test_id from tests where slug = 'sosio-emosional')
delete from items where test_id in (select test_id from t);
with t as (select id as test_id from tests where slug = 'sosio-emosional')
delete from subscales where test_id in (select test_id from t);
with t as (select id as test_id from tests where slug = 'sosio-emosional')
delete from likert_options where test_id in (select test_id from t);

-- Subscales & Likert (5-point)
with t as (select id as test_id from tests where slug = 'sosio-emosional'),
subscale_source (key, name) as (
  values
    ('communication_verbal', 'Komunikasi Verbal'),
    ('listening_skills', 'Keterampilan Mendengarkan'),
    ('respect_empathy', 'Menghargai & Peduli'),
    ('cooperation', 'Kerja Sama'),
    ('assertiveness', 'Ketegasan'),
    ('self_awareness', 'Kesadaran Diri'),
    ('self_regulation', 'Pengaturan Diri'),
    ('self_motivation', 'Motivasi Diri'),
    ('empathy_emotional', 'Empati Emosional'),
    ('social_skills', 'Keterampilan Sosial')
)
insert into subscales (test_id, key, name)
select t.test_id, s.key, s.name
from t cross join subscale_source s;

with t as (select id as test_id from tests where slug = 'sosio-emosional')
insert into likert_options (test_id, label, score)
select test_id, 'sangat tidak setuju', 1 from t
union all select test_id, 'tidak setuju', 2 from t
union all select test_id, 'netral', 3 from t
union all select test_id, 'setuju', 4 from t
union all select test_id, 'sangat setuju', 5 from t;

-- Items and subscale mapping
with t as (select id as test_id from tests where slug = 'sosio-emosional'),
item_rows (order_index, text) as (
  values
    (1, 'Saya mampu menjelaskan ulang materi pelajaran yang sulit dengan bahasa saya sendiri setelah dijelaskan oleh guru.'),
    (2, 'Saya memberi perhatian penuh saat teman menceritakan pengalamanya.'),
    (3, 'Saya menghargai pendapat teman dalam diskusi kelompok.'),
    (4, 'Saya terbuka terhadap ide-ide baru saat diskusi.'),
    (5, 'Saya berani menyampaikan pendapat saat diskusi di kelas.'),
    (6, 'Saya menjaga agar suara saya terdengar jelas saat diskusi.'),
    (7, 'Saya tidak memainkan ponsel saat sedang diajak bicara.'),
    (8, 'Saya tidak membeda-bedakan teman berdasarkan asal atau status sosial.'),
    (9, 'Saya bersedia menerima keputusan kelompok walaupun beda pendapat.'),
    (10, 'Saya bisa menolak ajakan teman untuk bolos sekolah dengan baik dan sopan.'),
    (11, 'Saya menghindari penggunaan kata atau singkatan yang tidak dipahami teman-teman saat berdiskusi.'),
    (12, 'Saya selalu fokus saat guru menjelaskan materi di kelas.'),
    (13, 'Saya mendengarkan ketika teman curhat tentang masalahnya tanpa menghakimi.'),
    (14, 'Saya membantu teman menyelesaikan tugas kelompok.'),
    (15, 'Saya mengakui kesalahan jika memang salah.'),
    (16, 'Saya mengetahui apa yang membuat saya nyaman dan tidak nyaman.'),
    (17, 'Saya mengelola stres dengan melakukan kegiatan yang bermanfaat, seperti berolahraga atau mendengarkan musik.'),
    (18, 'Saya mencari cara baru untuk belajar setelah gagal memahami materi.'),
    (19, 'Saya ikut merasa sedih ketika teman saya sedang sedih.'),
    (20, 'Saya mudah akrab dengan teman baru.'),
    (21, 'Saya menyadari kegugupan saat berbicara di depan banyak orang.'),
    (22, 'Saya menahan diri untuk tidak berkata kasar saat sedang marah.'),
    (23, 'Saya bersemangat ketika meraih nilai ujian sesuai target.'),
    (24, 'Saya peduli dengan menanyakan kabar teman yang sedang sedih.'),
    (25, 'Saya mampu bekerja sama dengan teman dalam menyelesaikan tugas kelompok sampai tuntas.'),
    (26, 'Saya bisa mengenali perubahan emosi saya ketika saya merasa sedih, senang, atau marah lalu menenangkan diri.'),
    (27, 'Saya tetap tenang meskipun ada teman yang mengejek saya.'),
    (28, 'Saya akan mencoba kembali dengan strategi baru jika gagal mengerjakan tugas atau soal.'),
    (29, 'Saya berusaha memahami perasaan orang lain dengan membayangkan diri saya berada dalam situasi mereka.'),
    (30, 'Saya mau bekerja sama menyelesaikan konflik kecil di kelas agar tetap nyaman.'),
    (31, 'Saya mau bertanya jika ada hal yang belum saya mengerti agar tidak salah paham.'),
    (32, 'Saya mengangguk atau memberi respon kecil sebagai tanda saya memahami lawan bicara.'),
    (33, 'Saya menghargai usaha teman meskipun hasilnya belum maksimal.'),
    (34, 'Saya mau berbagi tugas dengan teman, misalnya saya menulis laporan sementara teman lain mencari referensi.'),
    (35, 'Saya tegas menolak ajakan teman untuk melakukan hal yang melanggar aturan sekolah.'),
    (36, 'Saya menyadari kelebihan saya dalam berbicara di depan umum masih kurang.'),
    (37, 'Saya termotivasi untuk belajar giat agar bisa masuk perguruan tinggi yang saya impikan.'),
    (38, 'Ketika melihat teman kehilangan barang saya menawarkan bantuan untuk mencarinya.'),
    (39, 'Saya berani menyapa dan memulai percakapan dengan orang baru.')
),
inserted_items as (
  insert into items (test_id, order_index, text, is_active)
  select t.test_id, ir.order_index, ir.text, true
  from t join item_rows ir on true
  returning id, order_index
),
subscale_lookup as (
  select s.id, s.key
  from subscales s
  join t on s.test_id = t.test_id
),
item_subscale_pairs (order_index, subscale_key) as (
  values
    (1, 'communication_verbal'),
    (4, 'communication_verbal'),
    (5, 'communication_verbal'),
    (6, 'communication_verbal'),
    (11, 'communication_verbal'),
    (2, 'listening_skills'),
    (7, 'listening_skills'),
    (12, 'listening_skills'),
    (13, 'listening_skills'),
    (32, 'listening_skills'),
    (8, 'respect_empathy'),
    (13, 'respect_empathy'),
    (18, 'respect_empathy'),
    (24, 'respect_empathy'),
    (33, 'respect_empathy'),
    (3, 'respect_empathy'),
    (9, 'cooperation'),
    (14, 'cooperation'),
    (25, 'cooperation'),
    (30, 'cooperation'),
    (34, 'cooperation'),
    (10, 'assertiveness'),
    (15, 'assertiveness'),
    (35, 'assertiveness'),
    (16, 'self_awareness'),
    (21, 'self_awareness'),
    (36, 'self_awareness'),
    (17, 'self_regulation'),
    (26, 'self_regulation'),
    (27, 'self_regulation'),
    (23, 'self_motivation'),
    (28, 'self_motivation'),
    (31, 'self_motivation'),
    (37, 'self_motivation'),
    (19, 'empathy_emotional'),
    (24, 'empathy_emotional'),
    (28, 'empathy_emotional'),
    (29, 'empathy_emotional'),
    (39, 'empathy_emotional'),
    (20, 'social_skills'),
    (22, 'social_skills'),
    (29, 'social_skills'),
    (37, 'social_skills'),
    (38, 'social_skills')
),
insert_item_subscales as (
  insert into item_subscales (item_id, subscale_id)
  select ii.id, sl.id
  from item_subscale_pairs isp
  join inserted_items ii on ii.order_index = isp.order_index
  join subscale_lookup sl on sl.key = isp.subscale_key
  on conflict do nothing
  returning 1
)
select 'seeded ' || count(*) || ' item-subscale rows' from insert_item_subscales;

-- Result bands (3 tingkat)
with context as (
  select id as test_id from tests where slug = 'sosio-emosional'
),
band_rows (subscale_key, label, min_score, max_score, statement) as (
  values
    ('communication_verbal', 'rendah', 5, 11,
     'Kemampuan komunikasi verbal perlu diperkuat. Latih menjelaskan ulang materi, berani menyampaikan pendapat, jaga intonasi, dan hindari istilah yang membingungkan.'),
    ('communication_verbal', 'sedang', 12, 18,
     'Komunikasi verbal berada di tingkat sedang. Perbanyak kesempatan berbicara terstruktur dan mintalah umpan balik supaya penyampaian makin jelas.'),
    ('communication_verbal', 'tinggi', 19, 25,
     'Komunikasi verbal sudah kuat. Pertahankan keberanian menyampaikan ide dan bantu teman yang masih ragu berbicara.'),
    ('listening_skills', 'rendah', 5, 11,
     'Listening skill rendah. Beri perhatian penuh, jauhkan gawai saat diajak bicara, dan biasakan memberi respon kecil agar lawan bicara merasa dihargai.'),
    ('listening_skills', 'sedang', 12, 18,
     'Listening skill cukup baik. Tetap latih fokus dan kesabaran agar tidak memotong pembicaraan teman.'),
    ('listening_skills', 'tinggi', 19, 25,
     'Listening skill sangat baik. Terus jaga empati saat mendengar curhat teman dan tularkan kebiasaan mendengarkan aktif.'),
    ('respect_empathy', 'rendah', 6, 13,
     'Sikap menghargai & peduli masih rendah. Hindari membeda-bedakan teman, hadirkan empati, dan apresiasi usaha orang lain.'),
    ('respect_empathy', 'sedang', 14, 21,
     'Empati berada di tingkat sedang. Tingkatkan kebiasaan menolong teman, mendengarkan tanpa menghakimi, serta memberi dukungan emosional.'),
    ('respect_empathy', 'tinggi', 22, 30,
     'Empati dan rasa hormat kuat. Pertahankan sikap menghargai perbedaan dan jadilah teladan dalam diskusi kelompok.'),
    ('cooperation', 'rendah', 5, 11,
     'Kerja sama kelompok rendah. Belajar menerima keputusan bersama, berbagi tugas, dan bantu teman hingga selesai.'),
    ('cooperation', 'sedang', 12, 18,
     'Kerja sama cukup stabil. Terus aktif ketika konflik kecil muncul dan dukung ritme kerja tim.'),
    ('cooperation', 'tinggi', 19, 25,
     'Kerja sama sangat baik. Pertahankan kultur saling membantu dan bantu tim lain yang masih belum kompak.'),
    ('assertiveness', 'rendah', 3, 7,
     'Ketegasan rendah. Latih menolak ajakan negatif secara sopan, jujur mengakui kesalahan, dan teguh menjaga aturan sekolah.'),
    ('assertiveness', 'sedang', 8, 11,
     'Ketegasan moderat. Tingkatkan keberanian menyampaikan batasan memakai bahasa santun.'),
    ('assertiveness', 'tinggi', 12, 15,
     'Ketegasan tinggi. Terus gunakan pendekatan sopan namun tegas dan bantu teman yang masih ragu bersikap.'),
    ('self_awareness', 'rendah', 3, 7,
     'Kesadaran diri rendah. Kenali apa yang membuat nyaman/tidak nyaman dan refleksikan ekspresi saat berbicara di depan umum.'),
    ('self_awareness', 'sedang', 8, 11,
     'Kesadaran diri cukup. Pertahankan kebiasaan mengevaluasi diri dan buat rencana perbaikan ketika gugup.'),
    ('self_awareness', 'tinggi', 12, 15,
     'Kesadaran diri tinggi. Manfaatkan pemahaman diri untuk mengembangkan potensi berbicara dan membantu teman menemukan zona nyaman mereka.'),
    ('self_regulation', 'rendah', 3, 7,
     'Pengaturan diri rendah. Bangun rutinitas positif untuk mengelola stres dan belajar menenangkan diri ketika diejek.'),
    ('self_regulation', 'sedang', 8, 11,
     'Pengaturan diri cukup baik. Teruskan kebiasaan mengendalikan emosi dan tambahkan teknik relaksasi singkat saat situasi sulit.'),
    ('self_regulation', 'tinggi', 12, 15,
     'Pengaturan diri tinggi. Pertahankan kemampuan tetap tenang dan bagikan strategi coping kepada teman.'),
    ('self_motivation', 'rendah', 4, 9,
     'Motivasi diri rendah. Rayakan keberhasilan kecil, tetapkan tujuan belajar, dan coba strategi baru saat menemui hambatan.'),
    ('self_motivation', 'sedang', 10, 14,
     'Motivasi diri berada di tengah. Buat jadwal belajar yang konsisten dan catat progres agar semangat tetap terjaga.'),
    ('self_motivation', 'tinggi', 15, 20,
     'Motivasi diri tinggi. Pertahankan kebiasaan mengejar target akademik dan inspirasi teman untuk bangkit setelah gagal.'),
    ('empathy_emotional', 'rendah', 5, 11,
     'Empati emosional rendah. Perluas kepekaan terhadap perasaan teman dengan aktif bertanya kabar dan hadir ketika mereka sedih.'),
    ('empathy_emotional', 'sedang', 12, 18,
     'Empati emosional cukup. Tingkatkan kebiasaan memahami sudut pandang orang lain sebelum merespons.'),
    ('empathy_emotional', 'tinggi', 19, 25,
     'Empati emosional tinggi. Pertahankan keterbukaan hati dan bantu kelompok menjaga iklim saling mendukung.'),
    ('social_skills', 'rendah', 5, 11,
     'Keterampilan sosial rendah. Latih keberanian menyapa orang baru, jaga tutur kata, dan tawarkan bantuan saat teman kesulitan.'),
    ('social_skills', 'sedang', 12, 18,
     'Keterampilan sosial cukup. Perluas jaringan pertemanan dan terus kelola konflik kecil agar kelas nyaman.'),
    ('social_skills', 'tinggi', 19, 25,
     'Keterampilan sosial tinggi. Pertahankan inisiatif membantu teman dan jadilah penggerak suasana positif di kelas.'),
    ('overall', 'rendah', 39, 91,
     'Skor keseluruhan rendah. Fokus meningkatkan komunikasi, empati, pengelolaan emosi, serta motivasi belajar secara bertahap.'),
    ('overall', 'sedang', 92, 143,
     'Skor keseluruhan sedang. Teruskan kebiasaan positif dan lengkapi area yang belum konsisten melalui latihan terarah.'),
    ('overall', 'tinggi', 144, 195,
     'Skor keseluruhan tinggi. Pertahankan keseimbangan keterampilan sosial-emosional dan dukung teman yang masih membutuhkan pendampingan.')
)
insert into result_bands (test_id, subscale_id, label, min_score, max_score, statement)
select c.test_id,
       case
         when br.subscale_key = 'overall' then null
         else (
           select s.id from subscales s
           where s.test_id = c.test_id and s.key = br.subscale_key
           limit 1
         )
       end as subscale_id,
       br.label,
       br.min_score,
       br.max_score,
       br.statement
from context c
cross join band_rows br;

