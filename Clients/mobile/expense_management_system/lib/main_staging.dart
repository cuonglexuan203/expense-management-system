import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expense_management_system/gen/assets.gen.dart';
import 'package:expense_management_system/start.dart';

Future<void> main() async {
  await dotenv.load(fileName: Assets.env.aEnvStaging);

  await start();
}
