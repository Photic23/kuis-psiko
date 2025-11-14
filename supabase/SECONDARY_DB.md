# Secondary Supabase Database

Use this document when provisioning the socio-emotional questionnaire in a
separate Supabase project (distinct from the primary bullying assessment DB).

## 1. Prerequisites
- Supabase CLI ≥ 1.177.0 with access tokens configured (`supabase login`).
- Project reference for the secondary workspace (e.g., `abcd1234`).
- Postgres connection string for manual `psql` executions if desired.

## 2. Apply Schema
1. `cd` into the repo root.
2. Point the CLI to the secondary project:
   ```sh
   supabase link --project-ref <secondary-ref> --password <db-password>
   ```
3. Apply the mirrored migration via `psql` (or Supabase SQL editor):
   ```sh
   psql "$SECONDARY_DB_URL" -f supabase/migrations_secondary/0001_schema.sql
   ```
   > The migration is idempotent and only creates objects that do not yet exist.

## 3. Seed Questionnaire Data
- Option A: via Supabase CLI
  ```sh
  supabase db remote commit \
    --project-ref <secondary-ref> \
    --file supabase/secondary_seed.sql
  ```
- Option B: via `psql`
  ```sh
  psql "$SECONDARY_DB_URL" -f supabase/secondary_seed.sql
  ```

The seed file performs a full cleanup of the `sosio-emosional` slug before
reinserting rows, so it is safe to re-run after adjustments.

## 4. Environment Separation
- Keep a dedicated `.env.secondary` (or CI secret) with
  `SUPABASE_URL_SECONDARY` / `SUPABASE_SERVICE_ROLE_SECONDARY`.
- When running the Next.js app locally against the second DB, export the
  alternate env values before invoking `pnpm dev`.

## 5. Next Steps
- Collaborate with counselors to define `result_bands` thresholds for each
  subscale, then codify them as a follow-up migration.
- Add integration tests that hit both Supabase projects (or use mocking) to
  ensure the API honors the correct connection string.

