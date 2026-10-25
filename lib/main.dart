import 'package:flutter/widgets.dart';

import 'app.dart';
import 'game.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MathApp(game: await Game.boot(DeviceSettings())));
}
