import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:self_wallet/models/store_model.dart';
import 'package:self_wallet/views/upgrade_overlay.dart';

class ReleaseInfoNotifier extends StateNotifier<String> {
  ReleaseInfoNotifier() : super("1.0.0");

  /// 检查版本更新
  void checkReleaseInfo() async {
    state = "1.0.0";
    final String? localReleaseVersion = Store.tryGet(StoreKey.releaseInfo);
    debugPrint("localReleaseVersion: $localReleaseVersion");
    // UpgradeOverlayController.appLoader.show();
  }

  /// 确认跳过当前版本
  void skipCurrentVersion() async {
    state = "1.0.0";
    Store.put(StoreKey.releaseInfo, state);
    UpgradeOverlayController.appLoader.hide();
  }
}

final releaseInfoProvider = StateNotifierProvider<ReleaseInfoNotifier, String>(
  (ref) => ReleaseInfoNotifier(),
);
