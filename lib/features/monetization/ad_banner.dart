import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'monetization.dart';

/// Banner fixo (adaptativo) acima das abas. Some se não há anúncio ou se a pessoa comprou "Remover anúncios".
class AdBanner extends ConsumerStatefulWidget {
  const AdBanner({super.key});

  @override
  ConsumerState<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends ConsumerState<AdBanner> {
  BannerAd? _ad;
  bool _loading = false;

  Future<void> _load(BuildContext context) async {
    if (_loading || _ad != null) return;
    _loading = true;
    final width = MediaQuery.sizeOf(context).width.truncate();
    final size =
        await AdSize.getLargeAnchoredAdaptiveBannerAdSizeWithOrientation(
          MediaQuery.orientationOf(context),
          width,
        );
    if (size == null || !mounted) return;
    BannerAd(
      adUnitId: bannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) =>
            mounted ? setState(() => _ad = ad as BannerAd) : ad.dispose(),
        onAdFailedToLoad: (ad, _) {
          ad.dispose();
          _loading = false;
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = ref.watch(adsProvider.select((s) => s.ready));
    final premium = ref.watch(premiumProvider);
    if (!ready || premium) return const SizedBox.shrink();
    final ad = _ad;
    if (ad == null) {
      _load(context);
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: AdWidget(ad: ad),
      ),
    );
  }
}
