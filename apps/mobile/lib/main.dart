import 'app/bootstrap.dart';
import 'core/config/app_config.dart';

/// Default entry point — uses dev config.
/// For other flavors use: main_dev.dart, main_staging.dart, main_prod.dart
void main() async {
  await bootstrap(AppConfig.dev());
}
