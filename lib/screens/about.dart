// About: why the app exists, which version this is, and a way to give if you want to.
// The offer is a button and nothing more: no ask, no nudge, no count of who has given.

import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app.dart';
import '../design/components.dart';
import '../design/ground.dart';
import '../design/theme.dart';
import '../design/tokens.dart';
import '../game.dart';

/// Opens in the browser, never inside the app; nothing is sent until the person pays there.
final donateUrl = Uri.parse('https://buy.stripe.com/9B6eVe8Gf4Bt21I6HFgrS00');

/// The privacy policy, served with the web build. App Store guideline 5.1.1 wants it reachable
/// from inside the app, so it is offered on every platform.
final privacyUrl = Uri.parse('https://math.riverma.com/privacy/');

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Scope.of(context);
    final s = context.s;
    final kh = Kh.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Kangura(),
            Padding(
              padding: EdgeInsets.fromLTRB(kh.gutter, Space.s6, kh.gutter, Space.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Semantics(header: true, child: Text(s.about, style: kh.t.h2)),
                  const SizedBox(height: Space.s4),
                  Text(s.aboutStory, style: kh.t.body),
                  const SizedBox(height: Space.s3),
                  Text(s.aboutSharp, style: kh.t.body),
                  const SizedBox(height: Space.s5),
                  Text(s.version(appVersion), style: kh.t.caption),
                  const SizedBox(height: Space.s3),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: KhButton(
                      s.privacyPolicy,
                      size: KhButtonSize.sm,
                      kind: KhButtonKind.ghost,
                      onPressed: () => launchUrl(privacyUrl, mode: LaunchMode.externalApplication),
                    ),
                  ),
                  if (game.offersDonate) ...[
                    const SizedBox(height: Space.s3),
                    // The quietest button Khelo has: small, on paper, no loud fill.
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: KhButton(
                        s.donate,
                        size: KhButtonSize.sm,
                        kind: KhButtonKind.ghost,
                        onPressed: () => launchUrl(donateUrl, mode: LaunchMode.externalApplication),
                      ),
                    ),
                  ],
                  const SizedBox(height: Space.s6),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: KhButton(s.back, kind: KhButtonKind.ghost, onPressed: game.menu),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
