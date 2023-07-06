import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:self_wallet/utils/app_theme.dart';

@RoutePage()
class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("setting page"),
          ),
          ElevatedButton(
              onPressed: () {
                // context.router.pop();
                context.router.replaceNamed("/login");
              },
              child: Text("返回")),
          // 切换主题
          ElevatedButton(
              onPressed: () {
                ref.read(appThemeProvider.notifier).state =
                    ref.read(appThemeProvider.notifier).state == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
              child: Text("切换主题")),
        ],
      ),
    );
  }
}
