//ignore_for_file: public_member_api_docs
import 'package:auto_route/auto_route.dart';
import 'package:self_wallet/routing/router.dart';

// mock auth state
var isAuthenticated = true;

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    print("check auth $isAuthenticated");
    if (!isAuthenticated) {
      // ignore: unawaited_futures
      router.push(
        const SplashRouteRoute(),
      );
    } else {
      resolver.next(true);
    }
  }
}
