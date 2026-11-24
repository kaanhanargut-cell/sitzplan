-- Sitzplan: database setup for Supabase (run once in the SQL Editor).
-- Shared document store + team allow-list. Nothing is readable without sign-in.

create table if not exists public.allowed_emails (
  email text primary key
);

create table if not exists public.docs (
  collection text not null check (collection in ('rooms','classes')),
  id         text not null check (length(id) between 1 and 64),
  data       jsonb not null check (pg_column_size(data) < 262144),
  updated_at timestamptz not null default now(),
  updated_by text,
  primary key (collection, id)
);

alter table public.allowed_emails enable row level security;  -- no policies: invisible via the API
alter table public.docs enable row level security;

create or replace function public.am_i_allowed() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.allowed_emails
                 where lower(email) = lower(coalesce(auth.jwt() ->> 'email', '')));
$$;
revoke all on function public.am_i_allowed() from public, anon;
grant execute on function public.am_i_allowed() to authenticated;

drop policy if exists "team read"   on public.docs;
drop policy if exists "team insert" on public.docs;
drop policy if exists "team update" on public.docs;
drop policy if exists "team delete" on public.docs;
create policy "team read"   on public.docs for select to authenticated using (public.am_i_allowed());
create policy "team insert" on public.docs for insert to authenticated with check (public.am_i_allowed());
create policy "team update" on public.docs for update to authenticated using (public.am_i_allowed()) with check (public.am_i_allowed());
create policy "team delete" on public.docs for delete to authenticated using (public.am_i_allowed());

-- live updates
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;
