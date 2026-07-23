# Deploy to Vercel

## One-time setup

1. Push the repository to GitHub/GitLab/Bitbucket.
2. Go to https://vercel.com/new and import the repo.
3. Vercel auto-detects Vite. Confirm:
   - **Framework Preset:** Vite
   - **Build Command:** `vite build`
   - **Output Directory:** `dist`
   - **Install Command:** `npm install`
4. Add Environment Variables (Project Settings → Environment Variables) — copy from `.env`:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_PUBLISHABLE_KEY`
   - `VITE_SUPABASE_PROJECT_ID`
   Apply to **Production**, **Preview**, and **Development**.
5. Click **Deploy**.

## What `vercel.json` does

- SPA rewrite — all non-asset routes fall back to `index.html` so React Router deep links work on refresh.
- Long-term caching for hashed assets in `/assets/*`.
- Correct headers for the PWA service worker (`sw.js`) and web manifest so updates propagate immediately.
- Baseline security headers (nosniff, frame-options, referrer-policy, permissions-policy).

## Custom domain

Vercel dashboard → Project → Settings → Domains → Add. Follow the DNS instructions Vercel shows. SSL is automatic.

## Notes

- The `android/`, `ios/`, and `supabase/` folders are excluded from the Vercel build via `.vercelignore` — Vercel only ships the web bundle.
- Supabase Edge Functions continue to run on Lovable Cloud; Vercel only hosts the static frontend.
- Every push to the default branch triggers a production deploy; other branches get preview deployments automatically.
