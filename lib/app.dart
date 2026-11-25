// The shell: Khelo's theme, the page ground, and whichever screen is showing. Four screens,
// switched by the person's own presses; there is no navigation stack to get lost in.

import 'package:flutter/widgets.dart';

import 'design/ground.dart';
import 'design/theme.dart';
import 'design/typography.dart';
import 'game.dart';
import 'l10n/strings.dart';
import 'screens/about.dart';
import 'screens/ending.dart';
import 'screens/menu.dart';
import 'screens/play.dart';

class Scope extends InheritedNotifier<Game> {
  const Scope({super.key, required Game game, required super.child}) : super(notifier: game);

  static Game of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Scope>()!.notifier!;
}

extension Words on BuildContext {
  S get s => S.of(Scope.of(this).settings.lang);
}

class MathApp extends StatelessWidget {
  const MathApp({super.key, required this.game});
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scope(
      game: game,
      child: ListenableBuilder(
        listenable: game,
        builder: (context, _) => WidgetsApp(
          title: S.of(game.settings.lang).appTitle,
          color: const Color(0xfff5a300),
          debugShowCheckedModeBanner: false,
          locale: Locale(game.settings.lang.name),
          supportedLocales: const [Locale('en'), Locale('es'), Locale('hi')],
          textStyle: const TextStyle(fontFamily: baloo),
          pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) =>
              PageRouteBuilder<T>(settings: settings, pageBuilder: (context, _, _) => builder(context)),
          home: const _Root(),
        ),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    return KhScope(
      look: game.settings.look,
      lang: game.settings.lang,
      child: Builder(
        builder: (context) {
          final kh = Kh.of(context);
          final mq = MediaQuery.of(context);
          return ColoredBox(
            color: kh.c.sunk,
            // Full width up to maxWidth and full height, so the ground covers the whole page
            // however little is on it.
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: mq.size.width < maxWidth ? mq.size.width : maxWidth,
                height: double.infinity,
                child: KhGround(
                  child: DefaultTextStyle(
                    style: kh.t.body,
                    child: Padding(
                      // The keyboard takes the bottom of the screen; the page makes room.
                      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                      child: switch (game.screen) {
                        Screen.menu => const MenuScreen(),
                        Screen.play => const PlayScreen(),
                        Screen.end => const EndingScreen(),
                        Screen.about => const AboutScreen(),
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
