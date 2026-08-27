/**
 * Global image resilience.
 *
 * Some browsers / networks (corporate proxies, ad-blockers, flaky CDNs) fail to
 * fetch remote images. Instead of leaving a broken-image icon, we retry once and
 * then swap in the local placeholder. This listens in the capture phase because
 * <img> error events do not bubble.
 */
const PLACEHOLDER = '/placeholder.svg';
const RETRY_FLAG = 'imgRetry';

export function installImageFallback() {
  if (typeof window === 'undefined') return;

  window.addEventListener(
    'error',
    (event) => {
      const target = event.target as HTMLImageElement | null;
      if (!target || target.tagName !== 'IMG') return;

      const src = target.getAttribute('src') || '';
      if (!src || src.endsWith(PLACEHOLDER)) return;

      // Drop a responsive srcset that may itself be the broken source.
      if (target.srcset) target.removeAttribute('srcset');

      if (!target.dataset[RETRY_FLAG]) {
        // One cache-busting retry handles transient network failures.
        target.dataset[RETRY_FLAG] = '1';
        const separator = src.includes('?') ? '&' : '?';
        target.src = `${src}${separator}_r=1`;
        return;
      }

      target.src = PLACEHOLDER;
      target.style.objectFit = 'contain';
    },
    true
  );
}
