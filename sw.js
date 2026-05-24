// GolfSoc Service Worker
// iOS PWA: never cache HTML, always fetch fresh
const VERSION = 'v1.0.5';
const CACHE = 'golfsoc-assets-' + VERSION;

self.addEventListener('install', function(e) {
  self.skipWaiting();
});

self.addEventListener('activate', function(e) {
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
  var url = e.request.url;

  // NEVER cache HTML or navigation requests - always go to network
  if (e.request.mode === 'navigate' ||
      url.endsWith('.html') ||
      url.endsWith('/') ||
      url.indexOf('index') > -1) {
    e.respondWith(
      fetch(e.request, { cache: 'no-store' }).catch(function() {
        return caches.match(e.request);
      })
    );
    return;
  }

  // Cache fonts only
  if (url.indexOf('fonts.googleapis.com') > -1 || url.indexOf('fonts.gstatic.com') > -1) {
    e.respondWith(
      caches.match(e.request).then(function(cached) {
        return cached || fetch(e.request).then(function(response) {
          var clone = response.clone();
          caches.open(CACHE).then(function(c) { c.put(e.request, clone); });
          return response;
        });
      })
    );
    return;
  }

  // Everything else - network only
  e.respondWith(fetch(e.request));
});
