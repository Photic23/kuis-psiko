insert into tests (slug, name, description)
values ('bullying-id', 'Asesmen Perundungan', 'Skala Likert untuk fisik, verbal, dan siber')
on conflict (slug) do update set name = excluded.name;

-- Cleanup previous seed for idempotency (safe for repeated runs)
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
delete from result_bands where test_id in (select test_id from t);
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
delete from item_subscales using items i where item_subscales.item_id = i.id and i.test_id in (select test_id from t);
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
delete from items where test_id in (select test_id from t);
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
delete from subscales where test_id in (select test_id from t);
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
delete from likert_options where test_id in (select test_id from t);

-- Subscales
with s as (
  select id as test_id from tests where slug = 'bullying-id'
)
insert into subscales (test_id, key, name)
select s.test_id, 'physical', 'Fisik' from s
union all
select s.test_id, 'verbal', 'Verbal' from s
union all
select s.test_id, 'cyber', 'Siber' from s;

-- Likert options
with t as (select id as test_id from tests where slug = 'bullying-id')
insert into likert_options (test_id, label, score)
select test_id, 'sangat tidak setuju', 1 from t
union all select test_id, 'tidak setuju', 2 from t
union all select test_id, 'netral', 3 from t
union all select test_id, 'setuju', 4 from t
union all select test_id, 'sangat setuju', 5 from t;

-- Items (placeholders; replace with full list during app runtime seed)
with t as (
  select id as test_id from tests where slug = 'bullying-id'
)
insert into items (test_id, order_index, text, is_active)
select t.test_id, 1, 'Saya memukul teman ketika sedang marah', true from t
union all select t.test_id, 2, 'Saya menendang teman untuk menjadikan bahan bercanda', true from t
union all select t.test_id, 3, 'Saya menyikut teman agar ia menjauh', true from t
union all select t.test_id, 4, 'Saya mendorong teman pada saat bermain', true from t
union all select t.test_id, 5, 'Saya meninju teman karena perasaan kesal dan jengkel', true from t
union all select t.test_id, 6, 'Saya mencakar teman ketika dalam perkelahian', true from t
union all select t.test_id, 7, 'Saya mencekik teman ketika bertengkar', true from t
union all select t.test_id, 8, 'Saya menggigit teman saat berkelahi', true from t
union all select t.test_id, 9, 'Saya meludahi teman ketika saya merasa kesal', true from t
union all select t.test_id, 10, 'Saya menarik rambut teman dengan sengaja', true from t
union all select t.test_id, 11, 'Saya menyakiti teman dengan cara apa pun', true from t
union all select t.test_id, 12, 'Saya selalu melakukan kekerasan fisik kepada teman', true from t
union all select t.test_id, 13, 'Saya suka melihat teman melakukan kekerasan', true from t
union all select t.test_id, 14, 'Saya mengejek teman karena penampilannya', true from t
union all select t.test_id, 15, 'Saya memberi julukan negatif pada teman', true from t
union all select t.test_id, 16, 'Saya menyoraki teman yang diejek oleh orang lain', true from t
union all select t.test_id, 17, 'Saya menyebarkan gosip buruk tentang teman saya', true from t
union all select t.test_id, 18, 'Saya menuduh teman dengan kata-kata yang kasar', true from t
union all select t.test_id, 19, 'Saya mengancam teman dengan kata-kata kasar', true from t
union all select t.test_id, 20, 'Saya menertawakan kesalahan teman di depan orang lain', true from t
union all select t.test_id, 21, 'Saya sealu membentak teman saya', true from t
union all select t.test_id, 22, 'Saya menghina teman di depan orang banyak', true from t
union all select t.test_id, 23, 'Saya meneror teman lewat telepon atau pesan', true from t
union all select t.test_id, 24, 'Saya berkata kasar kepada teman terdekat maupun orang lain', true from t
union all select t.test_id, 25, 'Saya membuat teman malu dengan ucapan saya', true from t
union all select t.test_id, 26, 'Saya mempermalukan teman di depan kelas', true from t
union all select t.test_id, 27, 'Saya menyebarkan cerita buruk tentang teman', true from t
union all select t.test_id, 28, 'Saya memaki teman saat marah', true from t
union all select t.test_id, 29, 'Saya menirukan cara bicara teman untuk bahan lelucon', true from t
union all select t.test_id, 30, 'Saya menganggap wajar jika teman saling mengejek di sekolah', true from t
union all select t.test_id, 31, 'Saya senang jika teman menjadi bahan ejekan di kelas', true from t
union all select t.test_id, 32, 'Saya menggoda teman dengan kata-kata yang membuatnya malu', true from t
union all select t.test_id, 33, 'Saya mempermalukan teman melalui candaan di depan orang banyak', true from t
union all select t.test_id, 34, 'Saya memilih untuk mengejek atau memberi julukan buruk kepda teman', true from t
union all select t.test_id, 35, 'Saya menggunakan kata kasar terhadap siapa pun', true from t
union all select t.test_id, 36, 'Saya menyebar komentar jahat di media sosial', true from t
union all select t.test_id, 37, 'Saya memposting gambar teman tanpa meminta izin terlebih dahulu', true from t
union all select t.test_id, 38, 'Saya membuat akun palsu untuk mengolok-olok teman', true from t
union all select t.test_id, 39, 'Saya berpura-pura menjadi orang lain di media sosial', true from t
union all select t.test_id, 40, 'Saya menulis pesan yang menyakiti teman secara online', true from t
union all select t.test_id, 41, 'Saya mengunggah video teman agar orang lain menertawakan', true from t
union all select t.test_id, 42, 'Saya memilih untuk mengina siapa pun melalui media siosial', true from t;

-- Map items to subscales per selection (b):
-- Physical: 1–12; Verbal: 13–22 and 35; Cyber: 36–42
with ctx as (
  select te.id as test_id,
         (select id from subscales where test_id = te.id and key = 'physical' limit 1) as physical_id,
         (select id from subscales where test_id = te.id and key = 'verbal' limit 1) as verbal_id,
         (select id from subscales where test_id = te.id and key = 'cyber' limit 1) as cyber_id
  from tests te where te.slug = 'bullying-id'
)
insert into item_subscales (item_id, subscale_id)
select i.id, c.physical_id from items i cross join ctx c
where i.test_id = c.test_id and i.order_index between 1 and 12
on conflict do nothing;

with ctx as (
  select te.id as test_id,
         (select id from subscales where test_id = te.id and key = 'verbal' limit 1) as verbal_id
  from tests te where te.slug = 'bullying-id'
)
insert into item_subscales (item_id, subscale_id)
select i.id, c.verbal_id from items i cross join ctx c
where i.test_id = c.test_id and (i.order_index between 13 and 22 or i.order_index = 35)
on conflict do nothing;

with ctx as (
  select te.id as test_id,
         (select id from subscales where test_id = te.id and key = 'cyber' limit 1) as cyber_id
  from tests te where te.slug = 'bullying-id'
)
insert into item_subscales (item_id, subscale_id)
select i.id, c.cyber_id from items i cross join ctx c
where i.test_id = c.test_id and i.order_index between 36 and 42
on conflict do nothing;

-- Default result bands (sum-based) with three levels: rendah, sedang, tinggi
-- Physical (12 items): min 12, max 60 → 12–24, 25–42, 43–60
with t as (select id as test_id from tests where slug = 'bullying-id'),
sp as (select id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'physical')
insert into result_bands (test_id, subscale_id, label, min_score, max_score, statement)
select t.test_id, sp.subscale_id, 'rendah', 12, 24, 'Indikasi perilaku fisik rendah. Pertahankan kontrol emosi dan empati.' from t, sp
union all select t.test_id, sp.subscale_id, 'sedang', 25, 42, 'Indikasi perilaku fisik sedang. Rekomendasi: jauhi situasi pemicu, jangan membalas dengan fisik, minta bantuan orang dewasa, laporkan kejadian, gunakan buddy system.' from t, sp
union all select t.test_id, sp.subscale_id, 'tinggi', 43, 60, 'Indikasi perilaku fisik tinggi. Fokus pada keselamatan: segera menjauh, gunakan suara tegas ("HENTIKAN!"), laporkan ke guru/orang tua, hindari area sepi, dan minta dukungan sekolah untuk pengawasan aktif serta kebijakan zero tolerance.' from t, sp;

-- Verbal (11 items: 13–22 & 35): min 11, max 55 → 11–22, 23–38, 39–55
with t as (select id as test_id from tests where slug = 'bullying-id'),
sv as (select id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'verbal')
insert into result_bands (test_id, subscale_id, label, min_score, max_score, statement)
select t.test_id, sv.subscale_id, 'rendah', 11, 22, 'Indikasi perilaku verbal rendah. Pertahankan komunikasi yang empatik.' from t, sv
union all select t.test_id, sv.subscale_id, 'sedang', 23, 38, 'Indikasi perilaku verbal sedang. Rekomendasi: respon asertif ("Hentikan"), jangan memberi reaksi berlebihan, tinggalkan situasi, dukung teman yang menjadi korban, dan laporkan ke guru/orang tua.' from t, sv
union all select t.test_id, sv.subscale_id, 'tinggi', 39, 55, 'Indikasi perilaku verbal tinggi. Langkah lanjut: hentikan ejekan, alihkan topik, dukung korban secara pribadi, laporkan kejadian, dan dorong sekolah menerapkan aturan tegas soal panggilan nama, gosip/fitnah, dan ancaman.' from t, sv;

-- Cyber (7 items: 36–42): min 7, max 35 → 7–14, 15–25, 26–35
with t as (select id as test_id from tests where slug = 'bullying-id'),
sc as (select id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'cyber')
insert into result_bands (test_id, subscale_id, label, min_score, max_score, statement)
select t.test_id, sc.subscale_id, 'rendah', 7, 14, 'Indikasi perilaku siber rendah. Pertahankan etika digital dan privasi.' from t, sc
union all select t.test_id, sc.subscale_id, 'sedang', 15, 25, 'Indikasi perilaku siber sedang. Rekomendasi: jangan membalas, simpan bukti (screenshot), blokir & laporkan akun, bicarakan ke orang tepercaya, perkuat pengaturan privasi.' from t, sc
union all select t.test_id, sc.subscale_id, 'tinggi', 26, 35, 'Indikasi perilaku siber tinggi. Tindakan: hentikan interaksi, dokumentasikan semua bukti, blokir dan laporkan di platform, minta dukungan orang tua/guru BK, atur akun ke private, dan jika perlu eskalasi ke pihak sekolah/berwenang.' from t, sc;

-- Overall (42 items): min 42, max 210 → 42–84, 85–147, 148–210
with t as (select id as test_id from tests where slug = 'bullying-id')
insert into result_bands (test_id, subscale_id, label, min_score, max_score, statement)
select t.test_id, null::uuid, 'rendah', 42, 84, 'Kesimpulan umum rendah. Pertahankan kebiasaan baik, jaga empati dan keamanan digital.' from t
union all select t.test_id, null::uuid, 'sedang', 85, 147, 'Kesimpulan umum sedang. Terapkan strategi pencegahan: asertif tanpa agresi, jangan membalas, laporkan kejadian, minta dukungan orang dewasa.' from t
union all select t.test_id, null::uuid, 'tinggi', 148, 210, 'Kesimpulan umum tinggi. Disarankan pendampingan lanjut (konselor/guru BK), rencana keselamatan personal, penanganan sekolah yang tegas, serta dukungan orang tua.' from t;

-- Replace default brief statements with full recommendations provided (collapsible UI will show full text)
-- Cyber (tinggi)
with t as (select id as test_id from tests where slug = 'bullying-id'),
sc as (
  select s.id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'cyber'
)
update result_bands rb
set statement = $$BULYING CYBER
solusi yang bisa dilakukan, dibagi berdasarkan peran Anda:

1. Jika Anda Menjadi Korban

Tindakan Anda saat mengalaminya sangat penting untuk menghentikan siklus perundungan.

* Jangan Dibalas: Hal terpenting adalah jangan merespons atau membalas pesan tersebut. Pelaku cyberbullying sering mencari reaksi. Memberi mereka reaksi (seperti kemarahan atau kesedihan) hanya akan membuat mereka puas dan melanjutkan tindakannya.
* Simpan Bukti (Screenshot): Ambil tangkapan layar (screenshot) dari semua pesan, komentar, atau gambar yang mengganggu. Kumpulkan bukti ini. Ini akan sangat penting jika Anda perlu melaporkannya ke pihak berwenang, sekolah, atau platform media sosial.
* Blokir dan Laporkan: Segera blokir akun pelaku agar mereka tidak bisa menghubungi Anda lagi. Gunakan fitur "Laporkan" (Report) yang ada di semua platform media sosial (Instagram, TikTok, WhatsApp, dll.) untuk melaporkan konten atau akun tersebut.
* Bicarakan kepada Orang yang Anda Percaya: Ini adalah langkah krusial. Jangan menyimpannya sendiri. Ceritakan apa yang Anda alami kepada orang dewasa yang Anda percaya, seperti:
    * Orang tua
    * Guru atau konselor sekolah (Guru BK)
    * Saudara atau teman dekat yang bisa dipercaya
* Perkuat Pengaturan Privasi: Tinjau kembali pengaturan privasi di semua akun media sosial Anda. Batasi siapa saja yang bisa melihat unggahan Anda, mengomentari, atau mengirimi Anda pesan. Setel akun Anda ke mode "Private" jika memungkinkan.

2. Jika Anda Menjadi Saksi (Bystander)

Melihat cyberbullying terjadi dan tidak melakukan apa-apa (diam) bisa dianggap mendukung pelaku. Anda memiliki kekuatan untuk membantu.

* Jangan Ikut-ikutan: Jangan menyukai (like), membagikan (share), atau ikut berkomentar pada unggahan yang bersifat bullying.
* Dukung Korban: Kirimkan pesan pribadi (DM) kepada korban. Katakan bahwa Anda mendukung mereka dan apa yang mereka alami itu salah. Mengetahui ada yang peduli bisa sangat berarti bagi korban.
* Tantang Pelaku (Jika Aman): Jika Anda merasa aman dan nyaman, Anda bisa membela korban secara terbuka (misalnya, dengan komentar "Ini tidak keren" atau "Hentikan"). Namun, seringkali lebih efektif untuk tidak memberi panggung pada pelaku.
* Laporkan Perilaku Tersebut: Sama seperti korban, Anda juga bisa melaporkan unggahan atau komentar tersebut ke platform media sosial. Semakin banyak laporan, semakin cepat konten itu ditinjau.
* Beri Tahu Orang Dewasa: Jika Anda seorang siswa, beri tahu guru atau konselor Anda tentang apa yang Anda lihat.

3. Peran Orang Tua dan Guru (Edukator)

Pencegahan dan edukasi adalah kunci utama.

* Edukasi tentang "Jejak Digital": Ajarkan anak-anak dan siswa bahwa apa pun yang mereka unggah di internet akan ada di sana selamanya. Berpikir sebelum mengunggah.
* Ajarkan Empati: Diskusikan secara terbuka tentang dampak kata-kata. Sebuah lelucon di satu sisi bisa menjadi luka mendalam bagi sisi lain.
* Ciptakan Lingkungan Terbuka: Pastikan anak atau siswa merasa aman untuk datang kepada Anda jika mereka mengalami masalah online tanpa takut disalahkan atau gadget-nya langsung disita (yang sering membuat anak enggan melapor).
* Tetapkan Aturan Dasar: Buat aturan yang jelas tentang penggunaan gadget, jam online, dan aplikasi apa yang boleh digunakan, terutama untuk anak-anak yang lebih muda.$$
where rb.subscale_id in (select subscale_id from sc) and rb.label = 'tinggi';

-- Fisik (tinggi)
with t as (select id as test_id from tests where slug = 'bullying-id'),
sf as (
  select s.id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'physical'
)
update result_bands rb
set statement = $$SOLUSI UNTUK BULYING FISIK
Solusi untuk bullying fisik berfokus pada keselamatan segera dan intervensi orang dewasa, karena melibatkan ancaman langsung terhadap tubuh.

1. Jika Anda Menjadi Korban

Keselamatan Anda adalah prioritas nomor satu.

* Segera Menjauh: Prioritas utama Anda adalah keluar dari situasi berbahaya tersebut. Lari ke tempat yang ramai atau tempat di mana ada orang dewasa (ruang guru, kantor satpam, kantin, perpustakaan).
* Jangan Membalas dengan Fisik: Meskipun naluri Anda mungkin ingin melawan, membalas secara fisik sering kali memperburuk situasi. Ini dapat meningkatkan risiko cedera serius dan membuat Anda terlihat sama bersalahnya di mata orang dewasa (dianggap sebagai "perkelahian", bukan bullying).
* Gunakan Suara Anda (Jika Aman): Jika Anda tidak bisa langsung pergi, gunakan suara yang keras dan tegas. Katakan dengan jelas: "HENTIKAN!" atau "JANGAN SENTUH SAYA!" Terkadang, keberanian ini (tanpa agresi fisik) bisa mengejutkan pelaku dan memberi Anda waktu untuk pergi.
* Segera Laporkan ke Orang Dewasa Ini adalah langkah paling penting. Bullying fisik tidak akan berhenti jika dibiarkan. Anda harus memberi tahu orang dewasa yang Anda percaya setiap kali itu terjadi.
    * Di Sekolah: Beri tahu Guru BK, Wali Kelas, atau guru piket. Jelaskan apa yang terjadi, siapa yang melakukannya, dan di mana itu terjadi.
    * Di Rumah: Beri tahu orang tua Anda. Mereka perlu tahu agar bisa berbicara dengan pihak sekolah untuk memastikan Anda aman.
* Cari Teman (Buddy System): Hindari berada sendirian di area-area sepi tempat perundungan sering terjadi (seperti kamar mandi, lorong sepi, atau area parkir). Selalu pergi bersama setidaknya satu teman.

2. Jika Anda Menjadi Saksi (Bystander)

Diam saat melihat bullying fisik sama dengan mendukung pelaku. Anda memiliki peran besar untuk menghentikannya.

* Jangan Hanya Menonton atau Merekam: Merekam kejadian hanya akan mempermalukan korban lebih jauh dan tidak menghentikan kekerasan. Menonton dan menertawakan akan memberi "panggung" bagi pelaku.
* Cari Bantuan Orang Dewasa (Paling Aman): Tindakan terbaik dan teraman adalah segera lari dan panggil guru atau orang dewasa terdekat. Ini bukan "mengadu", ini adalah tindakan menyelamatkan seseorang dari bahaya.
* Buat Gangguan (Jika Aman): Jika Anda tidak bisa memanggil guru dengan cepat, buatlah gangguan untuk mengalihkan perhatian pelaku. Berteriak "Ada guru datang!" atau jatuhkan sesuatu yang berisik.
* Ajak Korban Menjauh: Jika situasinya memungkinkan, ajak korban untuk pergi bersama Anda. "Ayo, kita ke kantin saja."
* Dukung Korban Setelah Kejadian: Temani korban, pastikan dia baik-baik saja, dan tawarkan diri untuk menemaninya melapor ke guru.

3. Peran Sekolah dan Orang Tua

Pencegahan dan intervensi sistematis adalah kunci untuk menghentikan bullying fisik.

* Pengawasan Aktif: Sekolah harus memastikan ada pengawasan orang dewasa yang "terlihat" di area-area rawan (seperti jam istirahat, lorong, dan kamar mandi). Kehadiran guru saja seringkali cukup untuk mencegah bullying fisik.
* Kebijakan "Zero Tolerance" yang Jelas: Sekolah harus memiliki aturan yang tegas, jelas, dan konsisten mengenai bullying fisik. Siswa harus tahu bahwa akan ada konsekuensi serius jika mereka menyakiti siswa lain secara fisik.
* Percayai Laporan Korban: Ketika seorang siswa melapor, orang tua dan guru harus menanggapinya dengan serius. Jangan pernah berkata, "Abaikan saja" atau "Itu cuma bercanda."
* Edukasi Empati dan Pengendalian Emosi: Sekolah perlu secara aktif mengajarkan keterampilan sosial-emosional, cara mengelola amarah tanpa kekerasan, dan empati.
* Intervensi untuk Pelaku: Pelaku bullying juga membutuhkan bantuan—konsekuensi yang tegas diikuti pendampingan (konseling) untuk memahami akar perilaku dan memperbaiki cara berinteraksi.$$
where rb.subscale_id in (select subscale_id from sf) and rb.label = 'tinggi';

-- Verbal (tinggi)
with t as (select id as test_id from tests where slug = 'bullying-id'),
sv as (
  select s.id as subscale_id from subscales s join t on s.test_id = t.test_id where s.key = 'verbal'
)
update result_bands rb
set statement = $$BULYING VERBAL
solusi untuk mengatasi bullying verbal:

1. Jika Anda Menjadi Korban

Tujuannya adalah untuk mengambil kembali kekuatan dari kata-kata pelaku.

• Jangan Beri Reaksi yang Mereka Inginkan: Tetap tenang di luar, tarik napas dalam.
• Katakan dengan Tegas dan Jelas: Gunakan suara kuat dan kontak mata. Contoh:
  * "Hentikan."
  * "Saya tidak suka cara bicaramu."
  * "Jangan bicara seperti itu padaku."
• Pergi (Walk Away): Setelah menyatakan batasan, tinggalkan situasi.
• Jangan Percaya Kata-Kata Mereka: Bullying mencerminkan masalah pelaku, bukan diri Anda.
• Laporkan ke Orang Dewasa: Beri tahu Guru BK/Wali Kelas/orang tua kapan, siapa, dan apa yang dikatakan.
• Perkuat Diri Anda: Berada di lingkungan yang mendukung; tekuni hobi/bakat untuk membangun kepercayaan diri.

2. Jika Anda Menjadi Saksi (Bystander)

• Jangan Ikut Tertawa: Tanpa tawa, ejekan kehilangan kekuatan.
• Alihkan Perhatian: Ubah topik, pecah fokus pelaku.
• Bela Korban (Jika Aman): Contoh: "Itu tidak lucu." / "Sudahlah, jangan begitu."
• Dukung Korban Secara Pribadi: Tanyakan kondisinya dan tegaskan bahwa ucapan pelaku tidak benar.
• Laporkan: Sampaikan ke guru; laporan saksi memperkuat laporan korban.

3. Peran Sekolah dan Orang Tua

• Jangan Anggap Remeh ("Cuma Bercanda"): Bedakan bercanda vs mengejek.
• Tetapkan Aturan Tegas: Larang julukan negatif, gosip/fitnah, mengejek identitas, ancaman.
• Ajarkan Komunikasi Asertif: Ekspresikan ketidaksukaan tanpa hinaan.
• Beri Konsekuensi: Terapkan konsekuensi jelas bagi pelanggar berulang.
• Konseling Pelaku: Bantu pelaku memahami akar perilaku dan alternatif yang sehat.$$
where rb.subscale_id in (select subscale_id from sv) and rb.label = 'tinggi';
