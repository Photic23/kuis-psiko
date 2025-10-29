import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="space-y-6">
      <h1 className="text-2xl font-semibold">Asesmen Perilaku Perundungan</h1>
      <p className="text-slate-600">Jawab pertanyaan berikut menggunakan skala 1–5.</p>
      <Link
        href="/quiz/bullying-id"
        className="inline-flex items-center rounded-md bg-slate-900 px-4 py-2 text-white hover:bg-slate-800"
      >
        Mulai
      </Link>
    </main>
  );
}


