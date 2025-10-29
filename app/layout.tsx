import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Psychology Quiz',
  description: 'Likert-based subscale quiz with customizable results',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="id">
      <body className="min-h-screen bg-white text-slate-900 antialiased">
        <div className="mx-auto max-w-3xl px-4 py-6">{children}</div>
      </body>
    </html>
  );
}


