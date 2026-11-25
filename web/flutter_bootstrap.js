// Starts Matheos with everything served from here: the CanvasKit engine from canvaskit/,
// and the fallback fonts from fonts/fallback/. Flutter's defaults would fetch both from
// Google; these settings are why it never does.
{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
    fontFallbackBaseUrl: 'fonts/fallback/',
  },
});

// The app's own service worker (tool/build_sw.dart), so it opens with the radio off.
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => navigator.serviceWorker.register('sw.js').catch(() => {}));
}
