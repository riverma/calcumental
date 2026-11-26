import 'package:flutter/widgets.dart';

import 'app.dart';
import 'design/icons.dart';
import 'game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await warmIcons();
  runApp(MathApp(game: await Game.boot(DeviceSettings())));
}
