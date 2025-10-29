'use client';

import { useEffect, useMemo, useState } from 'react';
import { useRouter } from 'next/navigation';

type Item = { id: string; text: string; order_index: number };

export default function QuizRunner({ initialItems, sessionId }: { initialItems: Item[]; sessionId: string }) {
  const router = useRouter();
  const [items] = useState<Item[]>(initialItems);
  const [index, setIndex] = useState<number>(0);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [selectedScore, setSelectedScore] = useState<number | null>(null);

  const likert = useMemo(
    () => [
      { label: 'sangat tidak setuju', score: 1 },
      { label: 'tidak setuju', score: 2 },
      { label: 'netral', score: 3 },
      { label: 'setuju', score: 4 },
      { label: 'sangat setuju', score: 5 },
    ],
    []
  );

  const current = items[index];

  useEffect(() => {
    if (!current) return;
    setSelectedScore(answers[current.id] ?? null);
  }, [index, current?.id]);

  const setAnswer = async (itemId: string, score: number) => {
    setSelectedScore(score);
    setAnswers(prev => ({ ...prev, [itemId]: score }));
    void fetch('/api/response', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sessionId, itemId, score }),
    });
  };

  const next = () => {
    if (index < items.length - 1) setIndex(i => i + 1);
  };
  const prev = () => {
    if (index > 0) setIndex(i => i - 1);
  };

  const finish = async () => {
    await fetch('/api/response', {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ sessionId }),
    });
    router.push(`/result/${sessionId}`);
  };

  if (!current) return <p>Tidak ada item.</p>;

  return (
    <div className="space-y-6">
      <div className="text-sm text-slate-600">Pertanyaan {index + 1} dari {items.length}</div>
      <div className="rounded-md border p-4">
        <p className="mb-4">{current.text}</p>
        <div className="grid gap-2 sm:grid-cols-5">
          {likert.map(opt => {
            const isSelected = selectedScore === opt.score;
            const base = 'rounded-md border px-3 py-2 text-sm transition-colors';
            const selected = 'bg-slate-900 text-white border-slate-900 ring-2 ring-slate-900';
            const idle = 'bg-white text-slate-900 hover:bg-slate-100 border-slate-300';
            return (
              <button
                key={opt.score}
                type="button"
                aria-pressed={isSelected}
                className={`${base} ${isSelected ? selected : idle}`}
                onClick={() => void setAnswer(current.id, opt.score)}
              >
                {opt.label}
              </button>
            );
          })}
        </div>
      </div>
      <div className="flex items-center justify-between">
        <button onClick={prev} disabled={index === 0} className="rounded-md border px-4 py-2 disabled:opacity-50">Sebelumnya</button>
        {index < items.length - 1 ? (
          <button onClick={next} className="rounded-md bg-slate-900 px-4 py-2 text-white">Berikutnya</button>
        ) : (
          <button onClick={finish} className="rounded-md bg-emerald-600 px-4 py-2 text-white">Selesai</button>
        )}
      </div>
    </div>
  );
}


