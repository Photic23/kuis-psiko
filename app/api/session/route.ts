export const runtime = 'nodejs';

import { NextRequest, NextResponse } from 'next/server';
import { createAdminClient } from '@/lib/supabase/server';

export async function POST(req: NextRequest) {
  const form = await req.formData();
  const testId = form.get('testId');
  if (typeof testId !== 'string') {
    return NextResponse.json({ error: 'testId required' }, { status: 400 });
  }

  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from('sessions')
    .insert({ test_id: testId })
    .select('id')
    .single();

  if (error || !data) {
    return NextResponse.json({ error: 'failed to create session' }, { status: 500 });
  }

  return NextResponse.json({ sessionId: data.id }, { status: 201 });
}


