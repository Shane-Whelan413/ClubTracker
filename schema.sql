-- Golf Society App — Supabase Schema
-- Run this in the SQL Editor of a new Supabase project

-- Players
CREATE TABLE players (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  name text NOT NULL,
  handicap_index numeric(4,1) DEFAULT 18.0,
  pin text DEFAULT '1234',
  is_admin boolean DEFAULT false,
  plays_womens_index boolean DEFAULT false,
  avatar_url text,
  created_at timestamptz DEFAULT now()
);

-- Events
CREATE TABLE events (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_date date NOT NULL,
  event_type text DEFAULT 'sunday_9', -- sunday_9 | outing_18
  course_name text NOT NULL,
  course_rating numeric(4,1) DEFAULT 35.0,
  slope_rating integer DEFAULT 113,
  par integer DEFAULT 35,
  womens_course_rating numeric(4,1),
  womens_slope_rating integer,
  womens_par integer,
  stroke_index integer[],
  womens_stroke_index integer[],
  par_values integer[],
  womens_par_values integer[],
  published boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Rounds
CREATE TABLE rounds (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id uuid REFERENCES events(id) ON DELETE CASCADE,
  player_id uuid REFERENCES players(id) ON DELETE CASCADE,
  hole_scores integer[],
  par_values integer[],
  stableford_points integer DEFAULT 0,
  gross_score integer DEFAULT 0,
  course_handicap integer DEFAULT 0,
  handicap_before numeric(4,1),
  handicap_after numeric(4,1),
  league_points integer DEFAULT 0,
  verified boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Noticeboard
CREATE TABLE noticeboard (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  event_id uuid REFERENCES events(id) ON DELETE CASCADE,
  title text,
  body text,
  closest_to_pin text,
  birdies text[],
  custom_text text,
  created_at timestamptz DEFAULT now()
);

-- Knockout (optional — only needed if features.knockout = true)
CREATE TABLE knockout_matches (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  round integer,
  match_number integer,
  player1_id uuid REFERENCES players(id),
  player2_id uuid REFERENCES players(id),
  is_bye boolean DEFAULT false,
  holes integer DEFAULT 9,
  hole_scores_p1 integer[],
  hole_scores_p2 integer[],
  result text,
  winner_id uuid REFERENCES players(id),
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- RLS Policies (allow public access — app uses publishable key)
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE rounds ENABLE ROW LEVEL SECURITY;
ALTER TABLE noticeboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE knockout_matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public access" ON players FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public access" ON events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public access" ON rounds FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public access" ON noticeboard FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public access" ON knockout_matches FOR ALL USING (true) WITH CHECK (true);

-- Storage bucket for avatars (run after creating bucket in dashboard)
CREATE POLICY "allow public uploads to avatars" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars');
CREATE POLICY "allow public updates to avatars" ON storage.objects FOR UPDATE USING (bucket_id = 'avatars');
CREATE POLICY "allow public reads from avatars" ON storage.objects FOR SELECT USING (bucket_id = 'avatars');

-- Add your first admin player
-- INSERT INTO players (name, handicap_index, pin, is_admin) VALUES ('Your Name', 10.0, 'yourpin', true);
