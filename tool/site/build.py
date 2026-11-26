#!/usr/bin/env python3
"""Writes the landing page in English, Spanish and Hindi into docs/.

    python3 tool/site/build.py

One template, three sets of words, so the pages cannot drift apart. The output is plain HTML
with no script; docs/style.css dresses it.
"""

from datetime import date
from pathlib import Path

DOCS = Path(__file__).resolve().parents[2] / "docs"
SITE = "https://calcumental.riverma.com"
AHIMSA = "https://github.com/riverma/ahimsa-design"
KHELO = "https://khelo-design.riverma.com"
REPO = "https://github.com/riverma/calcumental"
HOME = "https://riverma.com"
AGPL = "https://www.gnu.org/licenses/agpl-3.0.html"
TODAY = date.today()  # the date the site was last built
MONTHS = {
    "en": ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    "es": ["enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"],
    "hi": ["जनवरी", "फ़रवरी", "मार्च", "अप्रैल", "मई", "जून", "जुलाई", "अगस्त", "सितंबर", "अक्टूबर", "नवंबर", "दिसंबर"],
}


def fmt_date(code: str) -> str:
    m = MONTHS[code][TODAY.month - 1]
    return {"en": f"{m} {TODAY.day}, {TODAY.year}", "es": f"{TODAY.day} de {m} de {TODAY.year}", "hi": f"{TODAY.day} {m} {TODAY.year}"}[code]


APK = REPO + "/releases/latest/download/Calcumental.apk"
CERT_SHA256 = "1778ce35141d6c39bb23285e2a4ee854586fd4a5f107bb589209f7bc750757b1"  # as apksigner prints it
PLAY_RULE = "https://support.google.com/googleplay/android-developer/answer/14151465"
RELEASES = REPO + "/releases/latest"
APK_SIGN = "https://developer.android.com/studio/publish/app-signing"
APKSIGNER = "https://developer.android.com/tools/apksigner"
BUILD_TOOLS = "https://developer.android.com/tools/releases/build-tools"
HOW_TO = "https://android-developers.googleblog.com/2026/03/android-developer-verification.html"

# Platform marks for the buttons. Inline, so the page still fetches nothing else.
GLOBE = '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><g fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9.2"/><ellipse cx="12" cy="12" rx="4" ry="9.2"/><path d="M3 12h18"/></g></svg>'
APPLE = '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false" fill="currentColor"><path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701"/></svg>'
ANDROID = '<svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path fill="currentColor" fill-rule="evenodd" d="M5.5 17a6.5 6.5 0 0 1 13 0Z M10.5 13.6a.9.9 0 1 0-1.8 0 .9.9 0 0 0 1.8 0Z M15.3 13.6a.9.9 0 1 0-1.8 0 .9.9 0 0 0 1.8 0Z"/><path d="M8 6.4l1.5 2.3M16 6.4l-1.5 2.3" fill="none" stroke="currentColor" stroke-width="1.3" stroke-linecap="round"/></svg>' 

T = {
    "en": dict(
        lang="en", prefix="", root="",
        title="Calcumental: arithmetic to practise at your own pace",
        desc="Calcumental is a free, open-source arithmetic app for iPhone and the web. Plus, minus, times and divide, at your own pace. No streaks, no scores, no timers, and it works offline.",
        og="Exercise your mental muscles. Take your time. Arithmetic puzzles with no streaks, no scores and no timers.",
        nav=[("#story", "Why"), ("#features", "Features"), ("#get", "Download"), ("#faq", "FAQ")],
        github="GitHub",
        icon_alt="The Calcumental icon: four tiles showing plus, minus, times and divide",
        tagline="Exercise your mental muscles.",
        lede="Four operations, three levels, three languages. Practise anywhere, even offline.",
        checks=["No ads", "No tracking", "No accounts"],
        play="Play online", store="iOS", soon="Coming soon for iPhone",
        fine='Free and <a href="%s">open source</a>. In English, Español and हिन्दी.' % REPO,
        hero_alt="A multiplication problem, 81 times 8, answered correctly, with a friendly 'That's it!' and a wide Next button",
        shot_tag="Screenshot", shot_mark="SCREENSHOT", shot_note="This is a screenshot of the app.", shot_try="Try the real thing online.",
        why="Why Calcumental",
        why1="Calcumental was made for a young girl in Mexico who loved numbers and wanted more arithmetic to practise.",
        why2="So the idea of the app was born. It asks one question at a time, waits as long as you like, and does not judge how you did.",
        inside="What&rsquo;s inside",
        inside_sub="Four operations, three levels, and a few small kindnesses that make mental arithmetic easier.",
        tiles=[
            ("±", "Arithmetic operations", "Plus, minus, multiply, divide, or mixed mode, which mixes them all together."),
            ("3", "Easy, Medium, Hard", "From single-digit tables to three-digit sums. Practise exactly what you want."),
            ("≈", "Close enough, if you like", "Turn on &ldquo;close enough&rdquo; to practise estimating: an answer within 5% counts."),
            ("↻", "A wrong answer is just a go", "Start typing a new answer straight away, press Try again, or choose Show me. There is no penalty."),
            ("✈", "Works offline", "Everything runs on your device. No network requests, no analytics, no ads and no accounts."),
            ("☮", "Follows the Ahimsa design principles", 'Calm by design: no streaks, scores, timers or red marks. <a href="%s">Read about Ahimsa</a>.' % AHIMSA),
        ],
        look="Look and feel",
        look_sub='Built on the <a href="%s">Khelo design system</a>: warm paper, ink outlines, big friendly buttons and block lettering.' % KHELO,
        caps=[
            ("1-menu", "Choose what to practise, or just press Let&rsquo;s play."),
            ("2-asking", "One problem at a time, and a big Check button for your thumb."),
            ("3-not-quite", "A wrong answer is just another go."),
            ("4-right", "It waits for you. Move on when you&rsquo;re ready."),
            ("raat", "Raat, the dark look, for the evening."),
        ],
        alts=["The menu with Let's play, Customize and a choice of operations", "A problem waiting for an answer, with a large Check button", "A gentle 'Not quite. Have another go.' with Try again and Show me side by side", "A correct answer and a wide Next button", "The problem screen in the dark look, Raat"],
        how="How it works",
        steps=[("Pick", "Press Let&rsquo;s play, or Customize to choose the operation, level and how many problems."), ("Solve", "Type your answer and press Check. If it&rsquo;s not quite right, have another go."), ("Take your time", "Nothing is timed or scored. When the set ends, you see what you did, and you can start another.")],
        get="Download Calcumental", get_sub="Free, with no ads and no in-app purchases.",
        store_long="Download for iOS", soon_long="Coming soon for iPhone and iPad", priv="Privacy policy",
android="Android", android_small="Free APK download", instructions="Instructions", updated="Last updated", android_long="Download for Android", android_long_small="APK, Android 7 or later",
        and_note='Not on Google Play. <a href="%s">Steps to install it, from Google</a>.' % HOW_TO,
        get_fine="The web version runs in your browser and works offline once it has loaded. You can add it to your Home Screen.",
        faq="Frequently asked questions",
        qa=[
            ("Does it collect any data?", 'No. There are no accounts, no analytics and no ads, and the app makes no network requests. It remembers only your choices (language, look, what to practise), on your own device. Read the <a href="privacy/#en">privacy policy</a>.'),
            ("Why no streaks or scores?", "Calcumental is for practising without pressure. It never times you, ranks you or tells you how you compare, so the only person you&rsquo;re working with is you."),
            ("Does it work offline?", "Yes. Everything runs on your device, and it needs no connection at all."),
            ("What does &ldquo;close enough&rdquo; mean?", "It&rsquo;s a way to practise estimating. Instead of needing the exact answer, anything within 5% of it counts (never less than 1 away)."),
            ("Is it open source?", 'Yes, under the AGPL-3.0-or-later. The code is on <a href="%s">GitHub</a>. Its fonts are under the SIL Open Font License.' % REPO),
            ("Why isn't it on Google Play?", 'Calcumental is free and open source, and Google Play asks new personal developer accounts to run a <a href="%s">closed test with at least 12 testers for 14 days</a> before an app can be published. That is a lot of overhead and too taxing for me to do for every release, so the Android version is a direct download instead. It is the same app, and the code is open for anyone to check.' % PLAY_RULE),
            ('How can I verify the Android download?', '<p>Verifying is optional. Either check shows the file is the one published, and doing both is best. Google explains how Android <a href="%s">signs apps</a>.</p><p class="opt">Check the file</p><ol><li>Download <code>Calcumental.apk</code> from the <a href="%s">latest release</a>.</li><li>Get its SHA-256 checksum. On Mac or Linux, run <code>shasum -a 256 Calcumental.apk</code>. On Windows, run <code>certutil -hashfile Calcumental.apk SHA256</code>.</li><li>Check that it matches the checksum in the release notes.</li></ol><p class="opt">Check who signed it</p><ol><li>Get <a href="%s">apksigner</a>, which comes with the Android <a href="%s">SDK Build-Tools</a>.</li><li>Run <code>apksigner verify --print-certs Calcumental.apk</code>.</li><li>Check that the &ldquo;certificate SHA-256 digest&rdquo; line shows <code>%s</code>.</li></ol><p>If anything doesn&rsquo;t match, don&rsquo;t install it.</p>' % (APK_SIGN, RELEASES, APKSIGNER, BUILD_TOOLS, CERT_SHA256)),
        ],
        foot='Built by <a href="%s">Rishi Verma</a>. Free software under the <a href="%s">AGPL-3.0-or-later</a>.' % (HOME, AGPL),
        source="Source on GitHub", privacy_anchor="privacy/#en",
    ),
    "es": dict(
        lang="es", prefix="es/", root="../",
        title="Calcumental: aritmética para practicar a tu ritmo",
        desc="Calcumental es una app de aritmética gratuita y de código abierto para iPhone y la web. Sumas, restas, multiplicaciones y divisiones, a tu ritmo. Sin rachas, sin puntajes, sin cronómetros, y funciona sin conexión.",
        og="Ejercita tu mente. Tómate tu tiempo. Acertijos de aritmética sin rachas, sin puntajes y sin cronómetros.",
        nav=[("#story", "Por qué"), ("#features", "Qué incluye"), ("#get", "Descargar"), ("#faq", "FAQ")],
        github="GitHub",
        icon_alt="El ícono de Calcumental: cuatro fichas con suma, resta, multiplicación y división",
        tagline="Ejercita tu mente.",
        lede="Cuatro operaciones, tres niveles, tres idiomas. Practica donde sea, incluso sin conexión.",
        checks=["Sin anuncios", "Sin rastreo", "Sin cuentas"],
        play="Jugar en línea", store="iOS", soon="Próximamente para iPhone",
        fine='Gratis y de <a href="%s">código abierto</a>. En English, Español y हिन्दी.' % REPO,
        hero_alt="Una multiplicación, 81 por 8, respondida correctamente, con un amable mensaje y un botón Siguiente ancho",
        shot_tag="Captura de pantalla", shot_mark="CAPTURA", shot_note="Esta es una captura de pantalla de la app.", shot_try="Pruébala de verdad en línea.",
        why="Por qué Calcumental",
        why1="Calcumental se hizo para una niña en México a quien le encantaban los números y quería practicar más aritmética.",
        why2="Así nació la idea de la app. Hace una pregunta a la vez, espera todo el tiempo que quieras y no juzga cómo te fue.",
        inside="Qué incluye",
        inside_sub="Cuatro operaciones, tres niveles y pequeños detalles que hacen más fácil el cálculo mental.",
        tiles=[
            ("±", "Operaciones aritméticas", "Suma, resta, multiplicación, división, o el modo mixto, que las combina todas."),
            ("3", "Fácil, medio, difícil", "De las tablas de un dígito a las sumas de tres dígitos. Practica justo lo que quieras."),
            ("≈", "Más o menos, si quieres", "Activa &ldquo;más o menos&rdquo; para practicar la estimación: cuenta una respuesta a menos del 5%."),
            ("↻", "Una respuesta incorrecta es solo otro intento", "Empieza a escribir otra respuesta de inmediato, pulsa Otra vez o elige Muéstramelo. No hay penalización."),
            ("✈", "Funciona sin conexión", "Todo se ejecuta en tu dispositivo. Sin conexiones de red, sin analíticas, sin anuncios y sin cuentas."),
            ("☮", "Sigue los principios de diseño Ahimsa", 'Tranquila por diseño: sin rachas, puntajes, cronómetros ni marcas rojas. <a href="%s">Conoce Ahimsa</a>.' % AHIMSA),
        ],
        look="Aspecto",
        look_sub='Hecha con el <a href="%s">sistema de diseño Khelo</a>: papel cálido, contornos de tinta, botones grandes y amables, y letras de bloque.' % KHELO,
        caps=[
            ("1-menu", "Elige qué practicar, o solo pulsa A jugar."),
            ("2-asking", "Un problema a la vez, y un botón Comprobar grande para tu pulgar."),
            ("3-not-quite", "Una respuesta incorrecta es solo otro intento."),
            ("4-right", "Te espera. Sigue cuando estés listo."),
            ("raat", "Raat, el aspecto oscuro, para la noche."),
        ],
        alts=["El menú con A jugar, Personalizar y una elección de operaciones", "Un problema esperando respuesta, con un botón Comprobar grande", "Un amable 'Todavía no' con Otra vez y Muéstramelo lado a lado", "Una respuesta correcta y un botón Siguiente ancho", "La pantalla del problema en el aspecto oscuro, Raat"],
        how="Cómo funciona",
        steps=[("Elige", "Pulsa A jugar, o Personalizar para elegir la operación, el nivel y cuántos problemas."), ("Resuelve", "Escribe tu respuesta y pulsa Comprobar. Si todavía no es correcta, prueba otra vez."), ("Tómate tu tiempo", "Nada se mide ni se puntúa. Cuando termina la serie, ves lo que hiciste y puedes empezar otra.")],
        get="Descarga Calcumental", get_sub="Gratis, sin anuncios y sin compras dentro de la app.",
        store_long="Descargar para iOS", soon_long="Próximamente para iPhone y iPad", priv="Política de privacidad",
android="Android", android_small="APK gratis", instructions="Instrucciones", updated="Última actualización", android_long="Descargar para Android", android_long_small="APK, Android 7 o posterior",
        and_note='No está en Google Play. <a href="%s">Pasos para instalarla, de Google</a> (en inglés).' % HOW_TO,
        get_fine="La versión web se ejecuta en tu navegador y funciona sin conexión una vez cargada. Puedes añadirla a tu pantalla de inicio.",
        faq="Preguntas frecuentes",
        qa=[
            ("¿Recoge algún dato?", 'No. No hay cuentas, ni analíticas, ni anuncios, y la app no hace conexiones de red. Solo recuerda tus elecciones (idioma, aspecto, qué practicar), en tu propio dispositivo. Lee la <a href="../privacy/#es">política de privacidad</a>.'),
            ("¿Por qué sin rachas ni puntajes?", "Calcumental es para practicar sin presión. Nunca te cronometra, te clasifica ni te compara, así que la única persona con la que trabajas eres tú."),
            ("¿Funciona sin conexión?", "Sí. Todo se ejecuta en tu dispositivo y no necesita conexión alguna."),
            ("¿Qué significa &ldquo;más o menos&rdquo;?", "Es una forma de practicar la estimación. En vez de exigir la respuesta exacta, cuenta cualquier valor a menos del 5% (nunca a menos de 1)."),
            ("¿Es de código abierto?", 'Sí, con la licencia AGPL-3.0-or-later. El código está en <a href="%s">GitHub</a>. Sus tipos de letra están bajo la SIL Open Font License.' % REPO),
            ("¿Por qué no está en Google Play?", 'Calcumental es gratuito y de código abierto, y Google Play pide a las cuentas de desarrollador personales nuevas una <a href="%s">prueba cerrada con al menos 12 probadores durante 14 días</a> antes de publicar una app. Es mucha carga y demasiado agotador para mí hacerlo con cada versión, así que la versión para Android es una descarga directa. Es la misma app, y el código está abierto para que cualquiera lo revise.' % PLAY_RULE),
            ('¿Cómo puedo verificar la descarga de Android?', '<p>Verificar es opcional. Cualquiera de las dos comprobaciones muestra que el archivo es el que se publicó, y lo mejor es hacer ambas. Google explica cómo Android <a href="%s">firma las apps</a> (en inglés).</p><p class="opt">Comprueba el archivo</p><ol><li>Descarga <code>Calcumental.apk</code> de la <a href="%s">última versión</a>.</li><li>Obtén su suma SHA-256. En Mac o Linux, ejecuta <code>shasum -a 256 Calcumental.apk</code>. En Windows, ejecuta <code>certutil -hashfile Calcumental.apk SHA256</code>.</li><li>Comprueba que coincide con la suma de las notas de la versión.</li></ol><p class="opt">Comprueba quién la firmó</p><ol><li>Consigue <a href="%s">apksigner</a>, que viene con las <a href="%s">SDK Build-Tools</a> de Android (en inglés).</li><li>Ejecuta <code>apksigner verify --print-certs Calcumental.apk</code>.</li><li>Comprueba que la línea &ldquo;certificate SHA-256 digest&rdquo; muestra <code>%s</code>.</li></ol><p>Si algo no coincide, no la instales.</p>' % (APK_SIGN, RELEASES, APKSIGNER, BUILD_TOOLS, CERT_SHA256)),
        ],
        foot='Hecha por <a href="%s">Rishi Verma</a>. Software libre bajo la <a href="%s">AGPL-3.0-or-later</a>.' % (HOME, AGPL),
        source="Código en GitHub", privacy_anchor="../privacy/#es",
    ),
    "hi": dict(
        lang="hi", prefix="hi/", root="../",
        title="कैल्कुमेंटल: अपनी रफ़्तार से अंकगणित का अभ्यास",
        desc="कैल्कुमेंटल iPhone और वेब के लिए मुफ़्त, ओपन-सोर्स अंकगणित ऐप है। जोड़, घटाना, गुणा और भाग, अपनी रफ़्तार से। न स्ट्रीक, न स्कोर, न टाइमर, और ऑफ़लाइन चलता है।",
        og="अपने दिमाग़ की कसरत करें। आराम से। न स्ट्रीक, न स्कोर, न टाइमर वाली अंकगणित की पहेलियाँ।",
        nav=[("#story", "क्यों"), ("#features", "क्या है अंदर"), ("#get", "डाउनलोड"), ("#faq", "FAQ")],
        github="GitHub",
        icon_alt="कैल्कुमेंटल का आइकन: जोड़, घटाना, गुणा और भाग दिखाती चार टाइलें",
        tagline="अपने दिमाग़ की कसरत करें।",
        lede="चार क्रियाएँ, तीन स्तर, तीन भाषाएँ। कहीं भी अभ्यास करें, ऑफ़लाइन भी।",
        checks=["कोई विज्ञापन नहीं", "कोई ट्रैकिंग नहीं", "कोई खाता नहीं"],
        play="ऑनलाइन खेलें", store="iOS", soon="iPhone के लिए जल्द आ रहा है",
        fine='मुफ़्त और <a href="%s">ओपन सोर्स</a>। English, Español और हिन्दी में।' % REPO,
        hero_alt="गुणा का एक सवाल, 81 × 8, सही हल किया हुआ, एक दोस्ताना संदेश और चौड़े 'अगला' बटन के साथ",
        shot_tag="स्क्रीनशॉट", shot_mark="स्क्रीनशॉट", shot_note="यह ऐप का स्क्रीनशॉट है।", shot_try="असली ऐप ऑनलाइन आज़माएँ।",
        why="कैल्कुमेंटल क्यों",
        why1="कैल्कुमेंटल मेक्सिको की एक छोटी लड़की के लिए बनाया गया था, जिसे संख्याओं से प्यार था और जो अंकगणित का और अभ्यास करना चाहती थी।",
        why2="इसी तरह इस ऐप का विचार जन्मा। यह एक बार में एक सवाल पूछता है, जितनी देर चाहें इंतज़ार करता है, और यह नहीं आँकता कि आपने कैसा किया।",
        inside="अंदर क्या है",
        inside_sub="चार क्रियाएँ, तीन स्तर, और कुछ छोटी-छोटी बातें जो मन ही मन गणित को आसान बनाती हैं।",
        tiles=[
            ("±", "अंकगणित की क्रियाएँ", "जोड़, घटाना, गुणा, भाग, या मिला-जुला मोड, जो सबको एक साथ मिला देता है।"),
            ("3", "आसान, मध्यम, कठिन", "एक अंक के पहाड़ों से लेकर तीन अंकों के जोड़ तक। जो चाहें वही अभ्यास करें।"),
            ("≈", "लगभग सही भी चलेगा", "अंदाज़ा लगाने के अभ्यास के लिए &ldquo;लगभग सही&rdquo; चालू करें: 5% के भीतर का जवाब सही गिना जाता है।"),
            ("↻", "ग़लत जवाब बस एक और कोशिश है", "तुरंत नया जवाब लिखना शुरू करें, &lsquo;फिर से&rsquo; दबाएँ, या &lsquo;जवाब दिखाएँ&rsquo; चुनें। कोई जुर्माना नहीं।"),
            ("✈", "ऑफ़लाइन चलता है", "सब कुछ आपके डिवाइस पर चलता है। न नेटवर्क अनुरोध, न एनालिटिक्स, न विज्ञापन, न खाते।"),
            ("☮", "अहिंसा डिज़ाइन सिद्धांतों पर चलता है", 'डिज़ाइन से ही शांत: न स्ट्रीक, न स्कोर, न टाइमर, न लाल निशान। <a href="%s">अहिंसा के बारे में पढ़ें</a>।' % AHIMSA),
        ],
        look="रूप और अनुभव",
        look_sub='<a href="%s">खेलो डिज़ाइन सिस्टम</a> पर बना: गर्म कागज़ जैसा रंग, स्याही की रेखाएँ, बड़े दोस्ताना बटन और ब्लॉक अक्षर।' % KHELO,
        caps=[
            ("1-menu", "क्या अभ्यास करना है चुनें, या बस &lsquo;चलो खेलें&rsquo; दबाएँ।"),
            ("2-asking", "एक बार में एक सवाल, और आपके अँगूठे के लिए बड़ा &lsquo;जाँचें&rsquo; बटन।"),
            ("3-not-quite", "ग़लत जवाब बस एक और कोशिश है।"),
            ("4-right", "यह आपका इंतज़ार करता है। तैयार हों तब आगे बढ़ें।"),
            ("raat", "रात, गहरा रूप, शाम के लिए।"),
        ],
        alts=["चलो खेलें, अपना खेल चुनें और क्रियाओं के चुनाव वाला मेन्यू", "जवाब का इंतज़ार करता एक सवाल, बड़े &lsquo;जाँचें&rsquo; बटन के साथ", "&lsquo;अभी नहीं&rsquo; का नरम संदेश, &lsquo;फिर से&rsquo; और &lsquo;जवाब दिखाएँ&rsquo; साथ-साथ", "सही जवाब और चौड़ा &lsquo;अगला&rsquo; बटन", "गहरे रूप, रात, में सवाल की स्क्रीन"],
        how="यह कैसे काम करता है",
        steps=[("चुनें", "&lsquo;चलो खेलें&rsquo; दबाएँ, या &lsquo;अपना खेल चुनें&rsquo; से क्रिया, स्तर और सवालों की संख्या चुनें।"), ("हल करें", "अपना जवाब लिखें और &lsquo;जाँचें&rsquo; दबाएँ। अगर अभी सही नहीं है, तो एक बार और कोशिश करें।"), ("आराम से", "कुछ भी समय या अंकों से नहीं नापा जाता। सेट पूरा होने पर आप देखते हैं कि आपने क्या किया, और दूसरा सेट शुरू कर सकते हैं।")],
        get="कैल्कुमेंटल डाउनलोड करें", get_sub="मुफ़्त, बिना विज्ञापन और बिना इन-ऐप ख़रीद के।",
        store_long="iOS के लिए डाउनलोड करें", soon_long="iPhone और iPad के लिए जल्द आ रहा है", priv="गोपनीयता नीति",
android="Android", android_small="मुफ़्त APK डाउनलोड", instructions="निर्देश", updated="अंतिम अपडेट", android_long="Android के लिए डाउनलोड करें", android_long_small="APK, Android 7 या उसके बाद",
        and_note='Google Play पर नहीं है। <a href="%s">इंस्टॉल करने के चरण, Google की ओर से</a> (अंग्रेज़ी में)।' % HOW_TO,
        get_fine="वेब संस्करण आपके ब्राउज़र में चलता है और एक बार लोड होने के बाद ऑफ़लाइन भी चलता है। आप इसे अपनी होम स्क्रीन पर जोड़ सकते हैं।",
        faq="अक्सर पूछे जाने वाले सवाल",
        qa=[
            ("क्या यह कोई डेटा इकट्ठा करता है?", 'नहीं। कोई खाता नहीं, कोई एनालिटिक्स नहीं, कोई विज्ञापन नहीं, और ऐप कोई नेटवर्क अनुरोध नहीं करता। यह सिर्फ़ आपकी पसंद (भाषा, रूप, क्या अभ्यास करना है) आपके अपने डिवाइस पर याद रखता है। <a href="../privacy/#hi">गोपनीयता नीति</a> पढ़ें।'),
            ("स्ट्रीक या स्कोर क्यों नहीं?", "कैल्कुमेंटल बिना दबाव के अभ्यास के लिए है। यह कभी आपका समय नहीं नापता, आपको रैंक नहीं देता और दूसरों से तुलना नहीं करता, इसलिए आप सिर्फ़ अपने साथ काम करते हैं।"),
            ("क्या यह ऑफ़लाइन चलता है?", "हाँ। सब कुछ आपके डिवाइस पर चलता है, और किसी कनेक्शन की ज़रूरत नहीं है।"),
            ("&ldquo;लगभग सही&rdquo; का क्या मतलब है?", "यह अंदाज़ा लगाने के अभ्यास का तरीक़ा है। सटीक जवाब की जगह, उसके 5% के भीतर कोई भी जवाब सही गिना जाता है (1 से कम दूरी पर कभी नहीं)।"),
            ("क्या यह ओपन सोर्स है?", 'हाँ, AGPL-3.0-or-later के तहत। कोड <a href="%s">GitHub</a> पर है। इसके फ़ॉन्ट SIL Open Font License के तहत हैं।' % REPO),
            ("यह Google Play पर क्यों नहीं है?", 'Calcumental मुफ़्त और ओपन सोर्स है, और Google Play नए निजी डेवलपर खातों से ऐप प्रकाशित करने से पहले <a href="%s">कम से कम 12 परीक्षकों के साथ 14 दिन का बंद परीक्षण</a> चलवाता है। यह काफ़ी झंझट है और हर रिलीज़ के लिए इसे करना मेरे लिए बहुत थकाऊ है, इसलिए Android संस्करण सीधे डाउनलोड के रूप में दिया गया है। यह वही ऐप है, और कोड कोई भी जाँचने के लिए खुला है।' % PLAY_RULE),
            ('मैं Android डाउनलोड को कैसे सत्यापित करूँ?', '<p>सत्यापन वैकल्पिक है। दोनों में से कोई भी जाँच दिखाती है कि फ़ाइल वही है जो प्रकाशित हुई, और दोनों करना सबसे अच्छा है। Google बताता है कि Android <a href="%s">ऐप कैसे साइन करता है</a> (अंग्रेज़ी में)।</p><p class="opt">फ़ाइल जाँचें</p><ol><li><a href="%s">नवीनतम रिलीज़</a> से <code>Calcumental.apk</code> डाउनलोड करें।</li><li>उसका SHA-256 चेकसम निकालें। Mac या Linux पर <code>shasum -a 256 Calcumental.apk</code> चलाएँ। Windows पर <code>certutil -hashfile Calcumental.apk SHA256</code> चलाएँ।</li><li>जाँचें कि वह रिलीज़ नोट्स के चेकसम से मिलता है।</li></ol><p class="opt">जाँचें कि किसने साइन किया</p><ol><li><a href="%s">apksigner</a> लें, जो Android के <a href="%s">SDK Build-Tools</a> के साथ आता है (अंग्रेज़ी में)।</li><li><code>apksigner verify --print-certs Calcumental.apk</code> चलाएँ।</li><li>जाँचें कि &ldquo;certificate SHA-256 digest&rdquo; वाली पंक्ति में <code>%s</code> दिखता है।</li></ol><p>अगर कुछ भी न मिले, तो इंस्टॉल न करें।</p>' % (APK_SIGN, RELEASES, APKSIGNER, BUILD_TOOLS, CERT_SHA256)),
        ],
        foot='<a href="%s">Rishi Verma</a> द्वारा बनाया गया। <a href="%s">AGPL-3.0-or-later</a> के तहत मुक्त सॉफ़्टवेयर।' % (HOME, AGPL),
        source="GitHub पर स्रोत", privacy_anchor="../privacy/#hi",
    ),
}

LANGS = [("en", "English", ""), ("es", "Español", "es/"), ("hi", "हिन्दी", "hi/")]


def page(code: str) -> str:
    t = T[code]
    r = t["root"]  # path back to docs/
    here = t["prefix"]

    nav = "\n        ".join(f'<a href="{h}">{l}</a>' for h, l in t["nav"])
    def switch_link(c: str, n: str, p: str) -> str:
        href = (r + p) if r else (p or "./")
        current = ' aria-current="page"' if c == code else ""
        return f'<a href="{href}" lang="{c}"{current}>{n}</a>'

    switch = " ".join(switch_link(c, n, p) for c, n, p in LANGS)
    alt = "\n  ".join(
        f'<link rel="alternate" hreflang="{c}" href="{SITE}/{p}">' for c, _, p in LANGS
    ) + f'\n  <link rel="alternate" hreflang="x-default" href="{SITE}/">'
    tiles = "\n          ".join(
        f'<div class="tile"><div class="sign" aria-hidden="true">{s}</div><h3>{h}</h3><p>{p}</p></div>'
        for s, h, p in t["tiles"]
    )
    shots = []
    for (key, cap), a in zip(t["caps"], t["alts"]):
        name = f"{code}-raat-2-asking" if key == "raat" else f"{code}-mela-{key}"
        shots.append(
            f'<figure><div class="phone"><img src="{r}assets/screens/{name}.png" alt="{a}" width="540" height="1168" decoding="async" draggable="false"></div><figcaption>{cap}</figcaption></figure>'
        )
    shots = "\n          ".join(shots)
    steps = "\n          ".join(f"<li><h3>{h}</h3><p>{p}</p></li>" for h, p in t["steps"])
    qa = "\n          ".join(f"<details><summary>{q}</summary>{a if a.startswith('<p>') else '<p>' + a + '</p>'}</details>" for q, a in t["qa"])
    checks = "".join(f"<li>{c}</li>" for c in t["checks"])
    play = f"{r}play/" if r else "play/"
    privacy = t["privacy_anchor"]
    return f"""<!doctype html>
<html lang="{t['lang']}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- Generated by tool/site/build.py. No scripts, and nothing fetched from anywhere else. -->
  <meta http-equiv="Content-Security-Policy"
        content="default-src 'none'; img-src 'self'; font-src 'self'; style-src 'self'; base-uri 'none'; form-action 'none'">
  <title>{t['title']}</title>
  <meta name="description" content="{t['desc']}">
  <meta name="color-scheme" content="light dark">
  <link rel="icon" href="{r}assets/icon-512.png" type="image/png">
  <link rel="apple-touch-icon" href="{r}assets/icon-512.png">
  <link rel="stylesheet" href="{r}style.css">
  {alt}
  <meta property="og:title" content="Calcumental">
  <meta property="og:description" content="{t['og']}">
  <meta property="og:image" content="{SITE}/assets/icon-512.png">
  <meta property="og:url" content="{SITE}/{here}">
  <meta name="twitter:card" content="summary">
</head>
<body>
  <div class="kangura" aria-hidden="true"></div>
  <header>
    <div class="wrap">
      <a class="brand" href="#top"><img src="{r}assets/icon-512.png" alt="" width="34" height="34">Calcumental</a>
      <nav aria-label="Sections">
        {nav}
      </nav>
      <div class="lang" role="navigation" aria-label="Language">{switch}</div>
    </div>
  </header>

  <main id="top">
    <section class="hero">
      <div class="wrap hero-grid">
        <div>
          <img class="icon" src="{r}assets/icon-512.png" alt="{t['icon_alt']}" width="112" height="112">
          <h1>{'कैल्कुमेंटल' if code == 'hi' else 'Calcumental'}</h1>
          <p class="tagline">{t['tagline']}</p>
          <p class="lede">{t['lede']}</p>
          <ul class="checks inline">{checks}</ul>
          <div class="actions">
            <a class="btn btn-primary" href="{play}">{GLOBE}<span>{t['play']}</span></a>
            <span class="btn" aria-disabled="true" role="link">{APPLE}<span>{t['store']}<small>{t['soon']}</small></span></span>
            <span class="btn android"><span class="ic">{ANDROID}</span><span><a class="stretch" href="{APK}">{t['android']}</a><small>{t['android_small']} &middot; <a class="inst" href="{HOW_TO}">{t['instructions']}</a></small></span></span>
          </div>
          <p class="fine">{t['fine']}</p>
        </div>
        <div class="hero-shot">
          <div class="phone"><span class="mark" aria-hidden="true"><span>{t['shot_mark']}</span></span><img src="{r}assets/screens/{code}-mela-4-right.png" alt="{t['shot_tag']}: {t['hero_alt']}" width="540" height="1168" draggable="false"></div>
          <p class="shot-note">{t['shot_note']} <a href="{play}">{t['shot_try']}</a></p>
        </div>
      </div>
    </section>

    <section id="story" class="story">
      <div class="wrap">
        <div class="narrow">
          <h2>{t['why']}</h2>
          <p>{t['why1']}</p>
          <p class="big">{t['why2']}</p>
        </div>
      </div>
    </section>

    <section id="features">
      <div class="wrap">
        <h2>{t['inside']}</h2>
        <p class="soft narrow">{t['inside_sub']}</p>
        <div class="grid">
          {tiles}
        </div>
      </div>
    </section>

    <section id="screens" style="padding-top:0">
      <div class="wrap">
        <h2>{t['look']}</h2>
        <p class="soft narrow">{t['look_sub']}</p>
        <div class="shots">
          {shots}
        </div>
      </div>
    </section>

    <section id="how" style="padding-top:0">
      <div class="wrap">
        <h2>{t['how']}</h2>
        <ol class="steps">
          {steps}
        </ol>
      </div>
    </section>

    <section id="get" class="get">
      <div class="wrap">
        <h2>{t['get']}</h2>
        <p class="soft narrow">{t['get_sub']}</p>
        <div class="actions">
          <a class="btn btn-primary" href="{play}">{GLOBE}<span>{t['play']}</span></a>
          <span class="btn" aria-disabled="true" role="link">{APPLE}<span>{t['store_long']}<small>{t['soon_long']}</small></span></span>
          <a class="btn" href="{APK}">{ANDROID}<span>{t['android_long']}<small>{t['android_long_small']}</small></span></a>
          <a class="btn" href="{privacy}">{t['priv']}</a>
        </div>
        <p class="fine">{t['and_note']}</p>
        <p class="fine">{t['get_fine']}</p>
      </div>
    </section>

    <section id="faq">
      <div class="wrap">
        <h2>{t['faq']}</h2>
        <div class="faq">
          {qa}
        </div>
      </div>
    </section>
  </main>

  <footer>
    <div class="wrap">
      <p>{t['foot']}</p>
      <p><a href="{privacy}">{t['priv']}</a> · <a href="{REPO}">{t['source']}</a> · <a href="{play}">{t['play']}</a></p>
      <p class="fine">{t['updated']}: <time datetime="{TODAY.isoformat()}">{fmt_date(code)}</time></p>
    </div>
  </footer>
</body>
</html>
"""


for code in T:
    out = DOCS / T[code]["prefix"] / "index.html"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(page(code), encoding="utf-8")
    print("wrote", out.relative_to(DOCS.parent))
