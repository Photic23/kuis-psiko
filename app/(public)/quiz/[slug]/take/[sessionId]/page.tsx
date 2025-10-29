import QuizRunner from './QuizRunner';
import { createAdminClient } from '@/lib/supabase/server';

type Item = { id: string; text: string; order_index: number };

export default async function TakeQuizPage({ params }: { params: { slug: string; sessionId: string } }) {
  const admin = createAdminClient();
  const { data: test } = await admin.from('tests').select('id').eq('slug', params.slug).single();
  if (!test) return <p>Tidak ada item.</p>;
  const { data: items } = await admin
    .from('items')
    .select('id, text, order_index')
    .eq('test_id', test.id)
    .eq('is_active', true)
    .order('order_index');
  return <QuizRunner initialItems={items ?? []} sessionId={params.sessionId} />;
}


