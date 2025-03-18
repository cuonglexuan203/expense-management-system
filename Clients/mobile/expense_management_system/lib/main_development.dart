import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expense_management_system/start.dart';

import 'gen/assets.gen.dart';

Future<void> main() async {
  await dotenv.load(fileName: Assets.env.aEnvDevelopment);

  await start();
}
