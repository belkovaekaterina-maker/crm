-- Мини CRM: таблица клиентов. Выполнить один раз в Supabase → SQL Editor → Run.
create table if not exists public.clients (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name         text not null,
  phone        text default '',
  contact      text default '',
  status       text not null default 'new',
  amount       numeric default 0,
  source       text default '',
  next_contact date,
  note         text default '',
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

create index if not exists clients_user_idx on public.clients(user_id);

-- Каждый видит и меняет только своих клиентов
alter table public.clients enable row level security;

drop policy if exists "own clients" on public.clients;
create policy "own clients" on public.clients
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
