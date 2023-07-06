import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:self_wallet/providers/release_info_provider.dart';

class UpgradeOverlay extends HookConsumerWidget {
  const UpgradeOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onAcknowledgeTapped() {
      ref.watch(releaseInfoProvider.notifier).skipCurrentVersion();
    }

    return ValueListenableBuilder<bool>(
        valueListenable:
            UpgradeOverlayController.appLoader.loaderShowingNotifier,
        builder: (context, shouldShow, child) {
          return shouldShow
              ? Scaffold(
                  backgroundColor: Colors.black38,
                  body: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 307),
                      child: Wrap(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "version_announcement_overlay_title",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'WorkSans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                    ),
                                  ).tr(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'WorkSans',
                                          color: Colors.black87,
                                          height: 1.2,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                'version_announcement_overlay_text_1'
                                                    .tr(),
                                          ),
                                          const TextSpan(
                                            text: ' Immich ',
                                            style: TextStyle(
                                              fontFamily: "SnowBurstOne",
                                              color: Colors.indigo,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "version_announcement_overlay_text_2"
                                                    .tr(),
                                          ),
                                          TextSpan(
                                            text:
                                                "version_announcement_overlay_release_notes"
                                                    .tr(),
                                            style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {},
                                          ),
                                          TextSpan(
                                            text:
                                                "version_announcement_overlay_text_3"
                                                    .tr(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: const StadiumBorder(),
                                        visualDensity: VisualDensity.standard,
                                        backgroundColor: Colors.indigo,
                                        foregroundColor: Colors.grey[50],
                                        elevation: 2,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 25,
                                        ),
                                      ),
                                      onPressed: () {
                                        onAcknowledgeTapped();
                                      },
                                      child: const Text(
                                        "version_announcement_overlay_ack",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ).tr(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox();
        });
  }
}

class UpgradeOverlayController {
  static final UpgradeOverlayController appLoader = UpgradeOverlayController();
  ValueNotifier<bool> loaderShowingNotifier = ValueNotifier(false);
  ValueNotifier<String> loaderTextNotifier = ValueNotifier('error message');

  void show() {
    loaderShowingNotifier.value = true;
  }

  void hide() {
    loaderShowingNotifier.value = false;
  }
}
