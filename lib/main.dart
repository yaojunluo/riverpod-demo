import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:self_wallet/constants/locales.dart';
import 'package:self_wallet/models/logger_message_model.dart';
import 'package:self_wallet/models/store_model.dart';
import 'package:self_wallet/providers/app_state_provider.dart';
import 'package:self_wallet/providers/release_info_provider.dart';
import 'package:self_wallet/routing/router.dart';
import 'package:self_wallet/services/logger_service.dart';
import 'package:self_wallet/utils/app_theme.dart';
import 'package:self_wallet/views/upgrade_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Isar数据库
  await loadDb();
  await initApp();

  runApp(ProviderScope(
      child: EasyLocalization(
          supportedLocales: locales,
          path: translationsPath,
          useFallbackTranslations: true,
          fallbackLocale: locales.first,
          child: const WalletApp())));
  // runApp(const ProviderScope(child: WalletApp()));
}

/// 初始化app
Future<void> initApp() async {
  await EasyLocalization.ensureInitialized();

  LoggerService();

  var log = Logger("WallerErrorLogger");
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(details.toString(), details, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe(error.toString(), error, stack);
    return true;
  };
}

/// 加载Isar数据库
Future<Isar> loadDb() async {
  final dir = await getApplicationDocumentsDirectory();
  Isar db = await Isar.open(
    [StoreValueSchema, LoggerMessageSchema],
    directory: dir.path,
    maxSizeMiB: 256,
  );
  Store.init(db);
  return db;
}

class WalletApp extends ConsumerStatefulWidget {
  const WalletApp({Key? key}) : super(key: key);

  @override
  WalletAppState createState() => WalletAppState();
}

class WalletAppState extends ConsumerState<WalletApp>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // debugPrint("AppLifecycleState: $state");
    // 生命周期变化
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint("[APP STATE] resumed");
        ref.watch(appStateProvider.notifier).state = AppStateEnum.resumed;
        ref.watch(releaseInfoProvider.notifier).checkReleaseInfo();
        break;

      case AppLifecycleState.inactive:
        debugPrint("[APP STATE] inactive");
        ref.watch(appStateProvider.notifier).state = AppStateEnum.inactive;
        LoggerService().flush();

        break;

      case AppLifecycleState.paused:
        debugPrint("[APP STATE] paused");
        ref.watch(appStateProvider.notifier).state = AppStateEnum.paused;
        break;

      case AppLifecycleState.detached:
        debugPrint("[APP STATE] detached");
        ref.watch(appStateProvider.notifier).state = AppStateEnum.detached;
        break;
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final _rootRouter = RootRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            routerConfig: _rootRouter.config(),
            title: "Self Wallet",
            themeMode: ref.watch(appThemeProvider),
            darkTheme: appDarkTheme,
            theme: appLightTheme,
            builder: (context, router) {
              EasyLoading.init();
              return Stack(
                children: <Widget>[
                  router ?? Container(),
                  const UpgradeOverlay()
                ],
              );
            },
          );
        });
  }
}
