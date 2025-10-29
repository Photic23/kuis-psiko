import { createClient, createAdminClient } from '@/lib/supabase/server';
import Link from 'next/link';
import { redirect } from 'next/navigation';

export const dynamic = 'force-dynamic';

export default async function QuizPage({ params }: { params: { slug: string } }) {
  const supabase = createClient();
  const { data: test } = await supabase
    .from('tests')
    .select('id, name, items:items(id, text, order_index)')
    .eq('slug', params.slug)
    .eq('is_active', true)
    .order('order_index', { referencedTable: 'items', ascending: true })
    .single();

  if (!test) {
    return (
      <div className="space-y-3">
        <p>Test tidak ditemukan.</p>
        <Link className="text-blue-600 underline" href="/">Kembali</Link>
      </div>
    );
  }

  async function createSession() {
    'use server';
    const admin = createAdminClient();
    const { data, error } = await admin
      .from('sessions')
      .insert({ test_id: test.id })
      .select('id')
      .single();
    if (error || !data) return;
    redirect(`/quiz/${params.slug}/take/${data.id}`);
  }

  return (
    <div className="space-y-6">
      <h1 className="text-xl font-semibold">{test.name}</h1>
      <form action={createSession}>
        <button className="rounded-md bg-slate-900 px-4 py-2 text-white hover:bg-slate-800">Mulai</button>
      </form>
      <p className="text-slate-500">Setelah memulai, pertanyaan akan muncul satu per satu.</p>
    </div>
  );
}


