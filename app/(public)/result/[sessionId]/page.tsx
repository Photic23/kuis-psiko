export const dynamic = 'force-dynamic';

type Band = { label: string; statement: string };

import { headers } from 'next/headers';

export default async function ResultPage({ params }: { params: { sessionId: string } }) {
  const envBase = process.env.NEXT_PUBLIC_APP_URL;
  const h = headers();
  const host = h.get('x-forwarded-host') ?? h.get('host');
  const proto = h.get('x-forwarded-proto') ?? 'http';
  const derivedBase = host ? `${proto}://${host}` : '';
  const base = envBase && envBase.length > 0 ? envBase : derivedBase;
  const url = `${base}/api/result/${params.sessionId}`;
  const res = await fetch(url, { cache: 'no-store' });
  if (!res.ok) return <p>Terjadi kesalahan memuat hasil.</p>;
  const { overall, subscales }: { overall: Band | null; subscales: Record<string, Band> } = await res.json();

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-semibold">Hasil</h1>
      {overall && (
        <div className="rounded-md border p-4">
          <h2 className="mb-2 text-lg font-medium">Kesimpulan Umum: {overall.label}</h2>
          <details className="rounded-md border p-3">
            <summary className="cursor-pointer select-none text-sm text-slate-700">Lihat rekomendasi lengkap</summary>
            <div className="mt-2 whitespace-pre-wrap text-sm text-slate-800">{overall.statement}</div>
          </details>
        </div>
      )}
      <div className="grid gap-4 sm:grid-cols-2">
        {Object.entries(subscales).map(([key, band]) => (
          <div key={key} className="rounded-md border p-4">
            <h3 className="mb-1 font-medium capitalize">{key}: {band.label}</h3>
            <details className="rounded-md border p-3">
              <summary className="cursor-pointer select-none text-sm text-slate-700">Lihat rekomendasi lengkap</summary>
              <div className="mt-2 whitespace-pre-wrap text-sm text-slate-800">{band.statement}</div>
            </details>
          </div>
        ))}
      </div>
    </div>
  );
}


