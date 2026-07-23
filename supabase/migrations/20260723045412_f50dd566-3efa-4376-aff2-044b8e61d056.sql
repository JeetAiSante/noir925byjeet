
-- Revoke EXECUTE from anon/authenticated on internal SECURITY DEFINER functions
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.cleanup_old_rate_limits() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.update_updated_at_column() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.generate_order_number() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.enforce_single_loyalty_setting() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.validate_contact_message() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.validate_order_notes() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.atomic_decrement_stock(uuid, integer) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.atomic_rollback_stock(uuid, integer) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.atomic_use_coupon(text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.atomic_rollback_coupon(text) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.check_checkout_rate_limit(integer, integer) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.earn_loyalty_points(uuid, integer, integer) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.redeem_loyalty_points(uuid, integer) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.perform_spin(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.redeem_spin_prize(uuid) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.use_lucky_discount_claim(uuid) FROM PUBLIC, anon;

-- Drop broad public SELECT policies on storage.objects for public buckets to prevent listing.
-- Files remain accessible via public object URLs (that path bypasses RLS).
DROP POLICY IF EXISTS "Public can view product images" ON storage.objects;
DROP POLICY IF EXISTS "Public can view banner images" ON storage.objects;
DROP POLICY IF EXISTS "Avatar images are publicly accessible" ON storage.objects;
