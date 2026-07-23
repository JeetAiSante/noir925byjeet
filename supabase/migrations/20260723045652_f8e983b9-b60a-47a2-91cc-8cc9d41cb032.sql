
-- 1) invoice_settings: admin-only read
DROP POLICY IF EXISTS "Public can read invoice settings" ON public.invoice_settings;

-- 2) site_contact: create public view with safe columns, restrict base table to admins
DROP POLICY IF EXISTS "Anyone can view site contact info" ON public.site_contact;

CREATE OR REPLACE VIEW public.site_contact_public
WITH (security_invoker = true) AS
SELECT
  id,
  company_name,
  company_logo,
  phone,
  email,
  address,
  instagram_url,
  facebook_url,
  twitter_url,
  youtube_url,
  whatsapp,
  created_at,
  updated_at
FROM public.site_contact;

GRANT SELECT ON public.site_contact_public TO anon, authenticated;

-- Underlying table must allow the view's SELECT for anon/authenticated. Add a
-- policy that only exposes the safe columns via the view by restricting
-- direct table reads to admins, and separately allow the view's internal read
-- via a security-definer function.
CREATE POLICY "Admins can read site contact"
ON public.site_contact
FOR SELECT
TO authenticated
USING (public.has_role(auth.uid(), 'admin'));

-- Since the view uses security_invoker, the caller needs SELECT on the base
-- table. Instead, switch the view to run as its owner (security definer view)
-- so anon can read only the exposed columns.
ALTER VIEW public.site_contact_public SET (security_invoker = false);

-- 3) site_settings: gate anon reads by an is_public flag
ALTER TABLE public.site_settings
  ADD COLUMN IF NOT EXISTS is_public boolean NOT NULL DEFAULT true;

DROP POLICY IF EXISTS "Public can read site settings" ON public.site_settings;

CREATE POLICY "Public can read public site settings"
ON public.site_settings
FOR SELECT
TO anon, authenticated
USING (is_public = true);
