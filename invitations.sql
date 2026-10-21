-- Score Fléchettes : création de compte sur invitation uniquement.
-- À coller dans Supabase > SQL Editor, puis « Run ».

-- 1. Liste des codes d'invitation (personne ne peut la lire depuis l'appli)
create table if not exists public.invite_codes (
  code text primary key,
  uses_left integer,          -- nombre de comptes encore possibles ; vide = illimité
  note text,                  -- pour qui est ce code (pour toi)
  created_at timestamptz not null default now()
);
alter table public.invite_codes enable row level security;
revoke all on public.invite_codes from anon, authenticated;

-- 2. Vérification à chaque création de compte
create or replace function public.hook_check_invite(event jsonb)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  c text := upper(trim(coalesce(event->'user'->'user_metadata'->>'invite', '')));
begin
  update public.invite_codes
     set uses_left = uses_left - 1
   where code = c and (uses_left is null or uses_left > 0);
  if found then
    return '{}'::jsonb;
  end if;
  return jsonb_build_object('error', jsonb_build_object(
    'http_code', 403,
    'message', 'Code d''invitation invalide ou épuisé.'));
end $$;

grant execute on function public.hook_check_invite(jsonb) to supabase_auth_admin;
revoke execute on function public.hook_check_invite(jsonb) from authenticated, anon, public;

-- 3. Un premier code : 20 comptes possibles. Change-le avant de lancer le script si tu veux.
insert into public.invite_codes (code, uses_left, note)
values ('FLECHES-2026', 20, 'Premier code')
on conflict (code) do nothing;
