
ALTER VIEW public.site_contact_public SET (security_invoker = true);

-- Re-allow anon SELECT via RLS, but restrict which columns they can read
CREATE POLICY "Public can view safe site contact"
ON public.site_contact
FOR SELECT
TO anon, authenticated
USING (true);

REVOKE SELECT ON public.site_contact FROM anon, authenticated;
GRANT SELECT (
  id, company_name, company_logo, phone, email, address,
  instagram_url, facebook_url, twitter_url, youtube_url, whatsapp,
  created_at, updated_at
) ON public.site_contact TO anon, authenticated;
