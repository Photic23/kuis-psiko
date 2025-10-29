# Psychology Quiz App

Next.js 14 (App Router) + Supabase (PostgreSQL) + Tailwind. Quiz with Likert options, per-subscale scoring, and customizable result bands. Ready for Vercel.

### Prerequisites
- Node.js 18+ and npm
- A Supabase project (URL + anon key + service role key)
- Recommended: psql or Supabase SQL editor

### Environment variables
Create `.env.local` (local) and add the same keys to Vercel Project Settings → Environment Variables.

- `NEXT_PUBLIC_SUPABASE_URL`: your Supabase project URL (public)
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: your Supabase anon key (public)
- `SUPABASE_SERVICE_ROLE`: service role key (server-only, never exposed client-side)
- `NEXT_PUBLIC_APP_URL`: base URL used by server components to fetch API (e.g., `http://localhost:3000` in dev, your Vercel URL in prod)

Example `.env.local`:
```
NEXT_PUBLIC_SUPABASE_URL=https://xyzcompany.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=ey...public
SUPABASE_SERVICE_ROLE=ey...secret
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Install and run (local)
```
npm i
npm run dev
```
App runs at `http://localhost:3000`.

### Database setup (Supabase)
1) Apply schema migration (use SQL editor or psql)
```
-- run file supabase/migrations/0001_schema.sql
```
2) Seed data (tests, subscales, items, likert, mappings, default result bands)
```
-- run file supabase/seed.sql
```

Included defaults
- Test slug: `bullying-id`
- Items: 42 Indonesian statements (order_index 1–42)
- Subscales: physical (1–12), verbal (13–22, 35), cyber (36–42)
- Likert labels: sangat tidak setuju (1) → sangat setuju (5)
- Result bands (sum-based):
  - Physical: 12–24 rendah, 25–42 sedang, 43–60 tinggi
  - Verbal: 11–22 rendah, 23–38 sedang, 39–55 tinggi
  - Cyber: 7–14 rendah, 15–25 sedang, 26–35 tinggi
  - Overall: 42–84 rendah, 85–147 sedang, 148–210 tinggi

### Running the flow
- Home: `/`
- Start quiz: `/quiz/bullying-id`
  - Starts a session, then redirects to `/quiz/bullying-id/take/[sessionId]`
- Answer items: buttons save responses via API
- Finish → results: `/result/[sessionId]`

### Security notes
- All writes use server route handlers with Node.js runtime
- Service role key is only read on server; do not expose it client-side
- DOMPurify sanitizes result statements on render
- Row Level Security (RLS) is not included here; you can add policies later to tighten per-session access

### Deploy to Vercel
1) Push this repo to GitHub/GitLab/Bitbucket
2) Import into Vercel and set Environment Variables (Production and Preview):
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE` (server only)
   - `NEXT_PUBLIC_APP_URL` (e.g., `https://your-app.vercel.app`)
3) Build & output settings: default Next.js (no extra config)
4) After first deploy, visit the production URL and test `/quiz/bullying-id`

Notes
- Route handlers already specify `export const runtime = 'nodejs'` for server-side Supabase admin calls
- CSP headers are configured in `next.config.ts`; adjust if you add external assets
- Results page fetches with `no-store` to reflect latest answers

### Customization
- Bands/statements: edit rows in `result_bands` (per subscale and overall)
- Add tests: insert into `tests`, add subscales, items, mappings, and bands
- UI: Tailwind classes in `app/*` and components

