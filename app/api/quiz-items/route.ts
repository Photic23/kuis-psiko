export const runtime = 'nodejs';

import { NextRequest, NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/server';

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const slug = searchParams.get('slug');
  if (!slug) return NextResponse.json({ error: 'slug required' }, { status: 400 });
  const supabase = createAdminClient();
  const { data: test } = await supabase
    .from('tests')
    .select('id')
    .eq('slug', slug)
    .single();
  if (!test) return NextResponse.json({ items: [] });
  const { data: items } = await supabase
    .from('items')
    .select('id, text, order_index')
    .eq('test_id', test.id)
    .eq('is_active', true)
    .order('order_index');
  return NextResponse.json({ items: items ?? [] });
}


