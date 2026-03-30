# Golf Society App — Template

A mobile-first PWA for running a golf society league. Handles Stableford scoring, handicap tracking, leaderboards, outings and knockout competitions.

---

## Setup for a new society

### 1. Create a Supabase project
- Go to supabase.com → New project
- Copy your **Project URL** and **Publishable (anon) key**

### 2. Run the database schema
- In Supabase → SQL Editor → paste contents of `schema.sql` → Run

### 3. Create Storage bucket for avatars
- Supabase → Storage → New bucket
- Name: `avatars`
- Public: ON
- Max file size: 204800 (200KB)
- Then run the storage RLS policies from the bottom of `schema.sql`

### 4. Edit config.json
Fill in the society details, Supabase credentials and scoring rules:

```json
{
  "society": {
    "name": "My Golf Society",
    "short_name": "MGS",
    "season_year": 2026,
    "season_start": "2026-03-01",
    "season_end": "2026-11-30"
  },
  "branding": {
    "primary": "#0a1628",
    "accent": "#C9A84C"
  },
  "supabase": {
    "url": "https://xxxx.supabase.co",
    "key": "your-publishable-key"
  },
  "scoring": {
    "handicap_gain": 0.2,
    "handicap_cut": 1,
    "handicap_cut_threshold": 18,
    "top_finish_protection": 3,
    "outing_cut_threshold": 37,
    "league_points": [20,19,18,17,16,15,14,13,12,11,10,9,8,7,6],
    "league_points_default": 6,
    "best_weeks": 33
  },
  "features": {
    "knockout": false,
    "outings": true,
    "womens_index": false,
    "noticeboard": true,
    "profile_photos": true
  },
  "admin_password": "changeme"
}
```

### 5. Add your logo
- Replace `icon-192.png` and `icon-512.png` with the society logo
- 192×192 and 512×512 pixels, PNG format

### 6. Deploy to GitHub Pages
- Create a new GitHub repo
- Upload all files
- Settings → Pages → Deploy from main branch

### 7. Add first admin player
In Supabase SQL Editor:
```sql
INSERT INTO players (name, handicap_index, pin, is_admin)
VALUES ('Your Name', 10.0, 'yourpin', true);
```

### 8. Tell members to install
Share the GitHub Pages URL. On iPhone: Safari → Share → Add to Home Screen

---

## Features
- Stableford scoring with handicap strokes per hole
- Automatic handicap updates after each round
- Season leaderboard with best N weeks
- Weekly events and 18-hole outings
- Knockout competition bracket (optional)
- Noticeboard / home feed
- Profile photos
- PWA — installs as a native-feeling app on iPhone and Android

## Scoring rules (configurable)
- Weekly: score ≥ cut threshold → −1 hcp | top 3 finish → no change | 4th or lower → +0.2
- Outings: score ≥ outing threshold → −1 hcp | otherwise → +0.2
- Tiebreaker: holes 7+8+9 total → then hole 6 alone back to hole 1

## Branding colours
Common choices:
- Navy + Gold: primary `#0a1628`, accent `#C9A84C`
- Green + White: primary `#1a4a1a`, accent `#ffffff`
- Black + Red: primary `#1a0000`, accent `#cc2200`

---

## Files
| File | Purpose |
|------|---------|
| `index.html` | The app |
| `config.json` | Society settings — edit this |
| `schema.sql` | Run once in Supabase to create tables |
| `manifest.json` | PWA manifest |
| `sw.js` | Service worker for offline support |
| `icon-192.png` | App icon (replace with society logo) |
| `icon-512.png` | App icon large (replace with society logo) |
