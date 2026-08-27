/**
 * Global image resilience.
 *
 * Some browsers / networks (corporate proxies, ad-blockers, strict DNS, flaky
 * CDNs) fail to fetch remote images — most often `images.unsplash.com`. Instead
 * of leaving a broken-image icon we walk a recovery chain:
 *
 *   1. one cache-busting retry (handles transient network failures)
 *   2. the same image through a neutral image proxy (handles blocked hosts)
 *   3. the local placeholder
 *
 * We listen in the capture phase because <img> error events do not bubble, and
 * we also sweep for images that never fire either event (stalled requests).
 */
const PLACEHOLDER = '/placeholder.svg';
const RETRY_FLAG = 'imgRetry';
const PROXY_FLAG = 'imgProxy';
const STALL_MS = 12000;

/** Route a remote URL through a neutral image proxy (weserv). */
export function proxiedImageUrl(src: string): string | null {
  try {
    const url = new URL(src, window.location.href);
    if (url.origin === window.location.origin) return null;
    if (url.hostname.endsWith('wsrv.nl') || url.hostname.endsWith('weserv.nl')) return null;
    return `https://wsrv.nl/?url=${encodeURIComponent(url.href.replace(/^https?:\/\//, ''))}&output=webp`;
  } catch {
    return null;
  }
}

function recover(target: HTMLImageElement) {
  const src = target.getAttribute('src') || '';
  if (!src || src.endsWith(PLACEHOLDER)) return;

  // Drop a responsive srcset that may itself be the broken source.
  if (target.srcset) target.removeAttribute('srcset');

  if (!target.dataset[RETRY_FLAG]) {
    target.dataset[RETRY_FLAG] = '1';
    const separator = src.includes('?') ? '&' : '?';
    target.src = `${src}${separator}_r=1`;
    return;
  }

  if (!target.dataset[PROXY_FLAG]) {
    target.dataset[PROXY_FLAG] = '1';
    const proxied = proxiedImageUrl(src.replace(/([?&])_r=1$/, ''));
    if (proxied) {
      target.referrerPolicy = 'no-referrer';
      target.src = proxied;
      return;
    }
  }

  target.src = PLACEHOLDER;
  target.style.objectFit = 'contain';
}

export function installImageFallback() {
  if (typeof window === 'undefined') return;

  window.addEventListener(
    'error',
    (event) => {
      const target = event.target as HTMLImageElement | null;
      if (!target || target.tagName !== 'IMG') return;
      recover(target);
    },
    true
  );

  // Stalled-request sweep: some networks hang the connection instead of
  // failing, so neither `load` nor `error` ever fires.
  const sweep = () => {
    document.querySelectorAll<HTMLImageElement>('img').forEach((img) => {
      if (img.complete && img.naturalWidth > 0) return;
      if (!img.getAttribute('src')) return;
      recover(img);
    });
  };
  window.setInterval(sweep, STALL_MS);
}
