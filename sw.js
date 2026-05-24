// Service Worker — GolfSoc PWA
// Bump this version number every time you push an update
const VERSION = 'v1.0.3';
const CACHE = 'golfsoc-' + VERSION;

self.addEventListener('install', function(e) {
  // Skip waiting so new SW activates immediately
  self.skipWaiting();
});

self.addEventListener('activate', function(e) {
  // Delete all old caches
  e.waitUntil(
    caches.keys().then(function(keys) {
      return Promise.all(
        keys.filter(function(k) { return k !== CACHE; }).map(function(k) {
          return caches.delete(k);
        })
      );
    }).then(function() {
      return self.clients.claim();
    })
  );
});

self.addEventListener('fetch', function(e) {
  // Network first for HTML — always get latest version
  if (e.request.url.endsWith('.html') || e.request.url.endsWith('/') || e.request.mode === 'navigate') {
    e.respondWith(
      fetch(e.request).catch(function() {
        return caches.match(e.request);
      })
    );
    return;
  }
  // Cache first for everything else (fonts, icons)
  e.respondWith(
    caches.match(e.request).then(function(cached) {
      return cached || fetch(e.request).then(function(response) {
        var clone = response.clone();
        caches.open(CACHE).then(function(cache) { cache.put(e.request, clone); });
        return response;
      });
    })
  );
});
