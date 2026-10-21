-- Score Fléchettes : à coller dans Supabase > SQL Editor, puis « Run ».
-- Chaque joueur connecté ne voit et ne modifie que ses propres données.

create table if not exists public.players (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name text not null check (char_length(name) between 1 and 40),
  archived boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.games (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  played_at timestamptz not null default now(),
  kind text not null check (kind in ('match','drill')),
  data jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists players_user_idx on public.players (user_id);
create index if not exists games_user_played_idx on public.games (user_id, played_at desc);

alter table public.players enable row level security;
alter table public.games enable row level security;

drop policy if exists "players_own" on public.players;
create policy "players_own" on public.players for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

drop policy if exists "games_own" on public.games;
create policy "games_own" on public.games for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

grant select, insert, update, delete on public.players, public.games to authenticated;

-- Bouton « Supprimer mon compte » : efface le compte et, en cascade, toutes ses données.
create or replace function public.delete_my_account()
returns void language sql security definer set search_path = '' as $$
  delete from auth.users where id = (select auth.uid());
$$;
revoke all on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
