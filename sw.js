const CACHE_VERSION = 'golfsoc-v1.0.8';

self.addEventListener('install', e => {
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE_VERSION).map(k => caches.delete(k)))
    ).then(() => clients.claim())
  );
});

self.addEventListener('fetch', e => {
  // Let ALL requests pass through natively — no SW interference
  // Only cache fonts
  if (e.request.url.includes('fonts.googleapis') || e.request.url.includes('fonts.gstatic')) {
    e.respondWith(
      caches.open(CACHE_VERSION).then(cache =>
        cache.match(e.request).then(r => {
          if (r) return r;
          return fetch(e.request).then(res => {
            cache.put(e.request, res.clone());
            return res;
          }).catch(() => r);
        })
      )
    );
    return;
  }
  // Everything else — just fetch, no SW involvement
  // Don't call e.respondWith() at all — let browser handle it natively
});

self.addEventListener('message', e => {
  if (e.data === 'skipWaiting') self.skipWaiting();
});
