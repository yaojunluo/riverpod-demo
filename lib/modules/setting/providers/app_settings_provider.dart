import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:self_wallet/modules/setting/services/app_settings_service.dart';

final appSettingsServiceProvider = Provider((ref) => AppSettingsService());
