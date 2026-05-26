// Unregister self immediately - no caching at all
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.map(k => caches.delete(k))))
      .then(() => clients.claim())
      .then(() => clients.matchAll({ includeUncontrolled: true }))
      .then(clients => clients.forEach(c => c.postMessage('reload')))
  );
});
// Pass everything through - no interception whatsoever
