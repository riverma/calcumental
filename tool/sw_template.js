// Mental Math's service worker. Hand-rolled, no build-time framework: the asset list and the
// cache name are injected by tool/build_sw.dart after each build.
// Everything the app needs is precached, so the app runs with the radio off, forever.
const VERSION = '__SW_VERSION__';
const CACHE = 'mental-math-' + VERSION;
const ASSETS = __SW_ASSETS__;

self.addEventListener('install', (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS)));
});

self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(keys.filter((k) => k !== CACHE && k.startsWith('mental-math-')).map((k) => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

// A new version waits for every tab to close and takes over on the next launch. Nothing
// announces it: version news is not something the person asked for.

// Cache first: an offline app should never wait on a network that may not be there.
// Navigations fall back to the cached shell, so any in-app route opens cold.
// `ignoreVary` matters: some static hosts answer with `Vary: Origin`, and without it a
// precached asset would never match the request the page actually makes.
const MATCH = { ignoreVary: true };

self.addEventListener('fetch', (e) => {
  const req = e.request;
  if (req.method !== 'GET' || new URL(req.url).origin !== self.location.origin) return;
  if (req.mode === 'navigate') {
    e.respondWith(caches.match('./', MATCH).then((r) => r || fetch(req)));
    return;
  }
  e.respondWith(
    caches.match(req, MATCH).then((hit) => hit || fetch(req).then((res) => {
      if (res.ok && res.type === 'basic') {
        const copy = res.clone();
        caches.open(CACHE).then((c) => c.put(req, copy));
      }
      return res;
    }).catch(() => caches.match('./', MATCH)))
  );
});
