export const runtime = 'nodejs';

import { NextRequest, NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/server';
import { mapScoreToBand } from '@/lib/scoring';

type BandRow = {
  subscale_id: string | null;
  label: string;
  min_score: number;
  max_score: number;
  statement: string;
};

export async function GET(_req: NextRequest, { params }: { params: { sessionId: string } }) {
  const supabase = createAdminClient();

  const { data: session } = await supabase
    .from('sessions')
    .select('id, test_id')
    .eq('id', params.sessionId)
    .single();
  if (!session) return NextResponse.json({ error: 'not found' }, { status: 404 });

  const { data: items } = await supabase
    .from('items')
    .select('id, order_index, item_subscales(subscale_id), responses(score)')
    .eq('test_id', session.test_id)
    .eq('responses.session_id', session.id);

  const { data: subscales } = await supabase
    .from('subscales')
    .select('id, key, name')
    .eq('test_id', session.test_id);

  const { data: bands } = await supabase
    .from('result_bands')
    .select('subscale_id, label, min_score, max_score, statement')
    .eq('test_id', session.test_id);

  const subscaleById = new Map<string, string>();
  (subscales ?? []).forEach(s => subscaleById.set(s.id, s.key));

  const scores = new Map<string, number>();
  let overall = 0;
  for (const item of items ?? []) {
    const s = (item.responses?.[0]?.score ?? 0) as number;
    overall += s;
    for (const is of item.item_subscales ?? []) {
      const key = subscaleById.get(is.subscale_id);
      if (!key) continue;
      scores.set(key, (scores.get(key) ?? 0) + s);
    }
  }

  const bySubscale: Record<string, { label: string; statement: string }> = {};
  for (const [key, score] of scores.entries()) {
    const subscaleId = [...subscaleById.entries()].find(([, k]) => k === key)?.[0] ?? '';
    const bandsFor = (bands ?? []).filter((b: BandRow) => b.subscale_id === subscaleId);
    const mapped = mapScoreToBand(score, bandsFor);
    if (mapped) bySubscale[key] = { label: mapped.label, statement: mapped.statement };
  }

  const overallBands = (bands ?? []).filter((b: BandRow) => b.subscale_id === null);
  const overallMapped = mapScoreToBand(overall, overallBands);

  return NextResponse.json({
    overall: overallMapped ? { label: overallMapped.label, statement: overallMapped.statement } : null,
    subscales: bySubscale,
  });
}


