
REVOKE EXECUTE ON FUNCTION public.has_role(uuid, public.app_role) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.check_contact_rate_limit(text, integer, integer) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.check_newsletter_rate_limit(text, integer, integer) FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.get_spin_wheel_display_prizes() FROM PUBLIC;
REVOKE EXECUTE ON FUNCTION public.validate_coupon(text) FROM PUBLIC, anon;
