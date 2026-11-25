// Every word the app says, in English, Spanish and Hindi.
//
// Khelo's voice: warm, plain and a little playful, in sentence case. Each language cheers in
// its own words: शाबाश belongs to Hindi, not sprinkled into the others. An exclamation mark may
// cheer something the person just did; it never summons them. Nothing counts, ranks or
// scolds. Hindi sits beside English as a peer. Digits stay Western in all three, as they are
// on Indian price tags and phone screens.

import '../core/problems.dart';
import '../core/session.dart';
import '../core/settings.dart';

class S {
  const S._(this.lang, this._t);
  final Lang lang;
  final Map<String, String> _t;

  factory S.of(Lang lang) => S._(lang, _all[lang]!);

  String _f(String key, [Map<String, Object> args = const {}]) {
    var s = _t[key]!;
    args.forEach((k, v) => s = s.replaceAll('{$k}', '$v'));
    return s;
  }

  String get appTitle => _f('appTitle');
  String get lead => _f('lead');
  String get letsPlay => _f('letsPlay');
  String get chooseOwn => _f('chooseOwn');
  String get practise => _f('practise');
  String get level => _f('level');
  String get howClose => _f('howClose');
  String get howMany => _f('howMany');
  String get apply => _f('apply');
  String get language => _f('language');
  String get look => _f('look');
  String version(String v) => _f('version').replaceAll('{v}', v);

  String get donate => _f('donate');
  String get privacyPolicy => _f('privacyPolicy');
  String get about => _f('about');
  String get back => _f('back');
  String get aboutStory => _f('aboutStory');
  String get aboutSharp => _f('aboutSharp');
  String get stop => _f('stop');
  String get yourAnswer => _f('yourAnswer');
  String get check => _f('check');
  String get notQuite => _f('notQuite');
  String get tryAgain => _f('tryAgain');
  String get showMe => _f('showMe');
  String get next => _f('next');
  String get finish => _f('finish');
  String get rest => _f('rest');
  String get whatYouDid => _f('whatYouDid');
  String get anotherSet => _f('anotherSet');
  String get menu => _f('menu');

  String mode(Mode m) => _f('mode.${m.name}');
  String levelName(Level l) => _f('level.${l.name}');
  String scoring(Scoring s) => _f('scoring.${s.name}');
  String lookName(Look l) => _f('look.${l.name}');

  String steps(int n, int total) => _f('steps', {'n': n, 'total': total});
  String problemOf(int n, int total) => _f('problemOf', {'n': n, 'total': total});
  String right(Problem p) => _f('right', {'p': p.text, 'a': p.answer});
  String closeEnough(Problem p) => _f('closeEnough', {'a': p.answer});
  String shown(Problem p) => _f('shown', {'p': p.text, 'a': p.answer});
  String allDone(int total) => _f('allDone', {'n': total});
  String stoppedAfter(int n, int total) => n == 0 ? _f('stoppedBefore') : _f('stoppedAfter', {'n': n, 'total': total});
  String youSaid(int g) => _f('youSaid', {'g': g});
  String outcome(Outcome o) => _f('outcome.${o.name}');

  /// The language's own name for itself, for the switcher.
  static const langLabel = {Lang.en: 'EN', Lang.es: 'ES', Lang.hi: 'हिं'};
  static const langName = {Lang.en: 'English', Lang.es: 'Español', Lang.hi: 'हिन्दी'};
}

const _all = <Lang, Map<String, String>>{
  Lang.en: {
    'appTitle': 'Matheos',
    'lead': 'Exercise your mental muscles. Take your time.',
    'letsPlay': 'Let’s play',
    'chooseOwn': 'Customize',
    'practise': 'What to practice',
    'mode.multiply': 'Multiply',
    'mode.add': 'Plus',
    'mode.subtract': 'Minus',
    'mode.divide': 'Divide',
    'mode.mixed': 'Mixed',
    'level': 'Level',
    'level.easy': 'Easy',
    'level.medium': 'Medium',
    'level.hard': 'Hard',
    'howClose': 'How close',
    'scoring.exact': 'Exact',
    'scoring.rough': 'Close enough',
    'howMany': 'How many',
    'apply': 'Apply',
    'language': 'Language',
    'look': 'Look',
    'look.auto': 'Auto',
    'look.mela': 'Mela',
    'look.raat': 'Raat',
    'version': 'Version: {v}',
    'donate': 'Donate',
    'privacyPolicy': 'Privacy',
    'about': 'About',
    'back': 'Back',
    'aboutStory':
        'Matheos was made for a young girl in Mexico who loved numbers and wanted more arithmetic to practice.',
    'aboutSharp': 'It turns out a lot of people could use it. A little practice keeps the mind sharp.',
    'stop': 'Stop',
    'steps': '{n} of {total}',
    'problemOf': 'Problem {n} of {total}',
    'yourAnswer': 'Your answer',
    'check': 'Check',
    'right': 'That’s it! {p} = {a}',
    'closeEnough': 'Close enough. It’s {a}.',
    'notQuite': 'Not quite. Have another go.',
    'tryAgain': 'Try again',
    'showMe': 'Show me',
    'shown': 'Here it is: {p} = {a}',
    'next': 'Next',
    'finish': 'Finish',
    'allDone': 'That’s all {n}. Nice work.',
    'stoppedAfter': 'You stopped after {n} of {total}.',
    'stoppedBefore': 'You stopped before the first one.',
    'rest': 'A new set is ready whenever you are.',
    'whatYouDid': 'What you did',
    'youSaid': 'you said {g}',
    'outcome.first': 'first go',
    'outcome.retried': 'after another go',
    'outcome.shown': 'shown',
    'anotherSet': 'Another set',
    'menu': 'Back to the menu',
  },
  Lang.es: {
    'appTitle': 'Matheos',
    'lead': 'Ejercita tus músculos mentales. Sin prisa.',
    'letsPlay': 'A jugar',
    'chooseOwn': 'Personalizar',
    'practise': 'Qué practicar',
    'mode.multiply': 'Multiplicar',
    'mode.add': 'Sumar',
    'mode.subtract': 'Restar',
    'mode.divide': 'Dividir',
    'mode.mixed': 'Mezcla',
    'level': 'Nivel',
    'level.easy': 'Fácil',
    'level.medium': 'Medio',
    'level.hard': 'Difícil',
    'howClose': 'Qué tan exacto',
    'scoring.exact': 'Exacto',
    'scoring.rough': 'Más o menos',
    'howMany': 'Cuántos',
    'apply': 'Aplicar',
    'language': 'Idioma',
    'look': 'Aspecto',
    'look.auto': 'Auto',
    'look.mela': 'Mela',
    'look.raat': 'Raat',
    'version': 'Versión: {v}',
    'donate': 'Donar',
    'privacyPolicy': 'Privacidad',
    'about': 'Acerca de',
    'back': 'Volver',
    'aboutStory':
        'Matheos se hizo para una niña en México a quien le encantaban los números y quería practicar más aritmética.',
    'aboutSharp': 'Resulta que a mucha gente le sirve. Un poco de práctica mantiene la mente ágil.',
    'stop': 'Parar',
    'steps': '{n} de {total}',
    'problemOf': 'Problema {n} de {total}',
    'yourAnswer': 'Tu respuesta',
    'check': 'Comprobar',
    'right': '¡Eso es! {p} = {a}',
    'closeEnough': 'Casi exacto. Es {a}.',
    'notQuite': 'Todavía no. Prueba otra vez.',
    'tryAgain': 'Otra vez',
    'showMe': 'Muéstramelo',
    'shown': 'Aquí está: {p} = {a}',
    'next': 'Siguiente',
    'finish': 'Terminar',
    'allDone': 'Ya están los {n}. Buen trabajo.',
    'stoppedAfter': 'Paraste después de {n} de {total}.',
    'stoppedBefore': 'Paraste antes del primero.',
    'rest': 'Hay otra tanda lista cuando quieras.',
    'whatYouDid': 'Lo que hiciste',
    'youSaid': 'dijiste {g}',
    'outcome.first': 'a la primera',
    'outcome.retried': 'en otro intento',
    'outcome.shown': 'mostrada',
    'anotherSet': 'Otra tanda',
    'menu': 'Volver al menú',
  },
  Lang.hi: {
    'appTitle': 'Matheos',
    'lead': 'अपने दिमाग़ की कसरत करें। आराम से।',
    'letsPlay': 'चलो खेलें',
    'chooseOwn': 'अपना खेल चुनें',
    'practise': 'किसका अभ्यास',
    'mode.multiply': 'गुणा',
    'mode.add': 'जोड़',
    'mode.subtract': 'घटाना',
    'mode.divide': 'भाग',
    'mode.mixed': 'मिला-जुला',
    'level': 'स्तर',
    'level.easy': 'आसान',
    'level.medium': 'मध्यम',
    'level.hard': 'कठिन',
    'howClose': 'कितना सटीक',
    'scoring.exact': 'बिल्कुल सही',
    'scoring.rough': 'लगभग सही',
    'howMany': 'कितने सवाल',
    'apply': 'लागू करें',
    'language': 'भाषा',
    'look': 'रूप',
    'look.auto': 'अपने-आप',
    'look.mela': 'मेला',
    'look.raat': 'रात',
    'version': 'संस्करण: {v}',
    'donate': 'दान करें',
    'privacyPolicy': 'गोपनीयता',
    'about': 'परिचय',
    'back': 'वापस',
    'aboutStory':
        'Matheos मेक्सिको की एक छोटी लड़की के लिए बनाया गया था, जिसे संख्याओं से प्यार था और जो अंकगणित का और अभ्यास करना चाहती थी।',
    'aboutSharp': 'पता चला कि यह बहुत से लोगों के काम आ सकता है। थोड़ा-सा अभ्यास दिमाग़ को तेज़ रखता है।',
    'stop': 'रुकें',
    'steps': '{total} में से {n}',
    'problemOf': '{total} में से सवाल {n}',
    'yourAnswer': 'आपका जवाब',
    'check': 'जाँचें',
    'right': 'शाबाश! {p} = {a}',
    'closeEnough': 'लगभग सही। जवाब {a} है।',
    'notQuite': 'अभी नहीं। एक बार और कोशिश करें।',
    'tryAgain': 'फिर से',
    'showMe': 'जवाब दिखाएँ',
    'shown': 'यह रहा: {p} = {a}',
    'next': 'अगला',
    'finish': 'पूरा करें',
    'allDone': 'सभी {n} हो गए। बहुत बढ़िया।',
    'stoppedAfter': 'आप {total} में से {n} के बाद रुके।',
    'stoppedBefore': 'आप पहले सवाल से पहले रुके।',
    'rest': 'जब मन करे, नया सेट तैयार है।',
    'whatYouDid': 'आपने क्या किया',
    'youSaid': 'आपने कहा {g}',
    'outcome.first': 'पहली बार में',
    'outcome.retried': 'दोबारा कोशिश में',
    'outcome.shown': 'दिखाया गया',
    'anotherSet': 'एक और सेट',
    'menu': 'मेन्यू पर लौटें',
  },
};
