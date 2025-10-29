create extension if not exists pgcrypto;

create table if not exists tests (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  name text not null,
  description text,
  is_active boolean not null default true
);

create table if not exists subscales (
  id uuid primary key default gen_random_uuid(),
  test_id uuid references tests(id) on delete cascade,
  key text not null,
  name text not null
);

create table if not exists items (
  id uuid primary key default gen_random_uuid(),
  test_id uuid references tests(id) on delete cascade,
  order_index int not null,
  text text not null,
  is_active boolean not null default true
);

create table if not exists item_subscales (
  item_id uuid references items(id) on delete cascade,
  subscale_id uuid references subscales(id) on delete cascade,
  primary key (item_id, subscale_id)
);

create table if not exists likert_options (
  id uuid primary key default gen_random_uuid(),
  test_id uuid references tests(id) on delete cascade,
  label text not null,
  score int not null
);

create table if not exists sessions (
  id uuid primary key default gen_random_uuid(),
  test_id uuid references tests(id) on delete cascade,
  user_id uuid null,
  started_at timestamptz not null default now(),
  completed_at timestamptz
);

create table if not exists responses (
  session_id uuid references sessions(id) on delete cascade,
  item_id uuid references items(id) on delete cascade,
  score int not null check(score between 1 and 5),
  primary key (session_id, item_id)
);

create table if not exists result_bands (
  id uuid primary key default gen_random_uuid(),
  test_id uuid references tests(id) on delete cascade,
  subscale_id uuid null references subscales(id) on delete cascade,
  label text not null,
  min_score int not null,
  max_score int not null,
  statement text not null
);


