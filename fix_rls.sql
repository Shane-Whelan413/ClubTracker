-- Fix RLS policies to allow wizard setup
-- Run this in Supabase SQL editor

-- Drop the restrictive insert policies
drop policy if exists "anyone can insert society on signup" on public.societies;
drop policy if exists "insert own settings" on public.society_settings;
drop policy if exists "insert player on signup" on public.players;

-- Re-create with proper anon access for initial setup
create policy "anon can insert society"
  on public.societies for insert
  to anon, authenticated
  with check (true);

create policy "anon can insert settings"
  on public.society_settings for insert
  to anon, authenticated
  with check (true);

create policy "anon can insert player"
  on public.players for insert
  to anon, authenticated
  with check (true);

-- Also allow authenticated users to read societies by invite code
-- (needed for member signup with invite code)
create policy "anyone can read society by invite code"
  on public.societies for select
  to anon, authenticated
  using (true);
