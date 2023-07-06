import 'package:auto_route/auto_route.dart';
import 'package:self_wallet/modules/login/views/login_page.dart';
import 'package:self_wallet/modules/setting/views/settings_page.dart';
import 'package:self_wallet/routing/auth_guard.dart';
import 'package:self_wallet/views/splash_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class RootRouter extends _$RootRouter {
  @override
  List<AutoRoute> get routes => [
        /// routes go here
        AutoRoute(page: SplashRouteRoute.page, path: '/splash', initial: true),
        AutoRoute(
            page: SettingsRoute.page, path: '/setting', guards: [AuthGuard()]),
        AutoRoute(page: LoginRoute.page, path: '/login'),
        AutoRoute(path: '*', page: LoginRoute.page)
      ];
}
