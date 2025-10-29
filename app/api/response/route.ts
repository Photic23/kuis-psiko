export const runtime = 'nodejs';

import { NextRequest, NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/server';

export async function POST(req: NextRequest) {
  const supabase = createAdminClient();
  const body = await req.json();
  const sessionId: string | undefined = body?.sessionId;
  const itemId: string | undefined = body?.itemId;
  const score: number | undefined = body?.score;
  if (!sessionId || !itemId || typeof score !== 'number') {
    return NextResponse.json({ error: 'invalid payload' }, { status: 400 });
  }

  const { error } = await supabase
    .from('responses')
    .upsert({ session_id: sessionId, item_id: itemId, score }, { onConflict: 'session_id,item_id' });

  if (error) return NextResponse.json({ error: 'failed to save response', message: error.message, details: (error as any).details, hint: (error as any).hint }, { status: 500 });
  return NextResponse.json({ ok: true });
}

export async function PATCH(req: NextRequest) {
  const supabase = createAdminClient();
  const body = await req.json();
  const sessionId: string | undefined = body?.sessionId;
  if (!sessionId) return NextResponse.json({ error: 'sessionId required' }, { status: 400 });
  const { error } = await supabase.from('sessions').update({ completed_at: new Date().toISOString() }).eq('id', sessionId);
  if (error) return NextResponse.json({ error: 'failed to complete session' }, { status: 500 });
  return NextResponse.json({ ok: true });
}


