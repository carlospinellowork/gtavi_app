import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../app/providers.dart';
import '../../core/constants/monetization.dart';

/// Anúncios e compra só existem no Android e no iOS (no web e nos testes ficam desligados).
bool get monetizationSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

bool get _isIos => defaultTargetPlatform == TargetPlatform.iOS;

String get bannerUnitId =>
    _isIos ? Monetization.bannerIos : Monetization.bannerAndroid;
String get _interstitialUnitId =>
    _isIos ? Monetization.interstitialIos : Monetization.interstitialAndroid;

/// Coloca o ID de afiliado em links da Amazon.
String affiliateUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null ||
      Monetization.amazonTag.isEmpty ||
      !uri.host.contains('amazon.')) {
    return url;
  }
  return uri
      .replace(
        queryParameters: {
          ...uri.queryParameters,
          'tag': Monetization.amazonTag,
        },
      )
      .toString();
}

// ─── Anúncios ────────────────────────────────────────────────────────────────

class AdsState {
  /// SDK iniciado e consentimento resolvido: pode pedir anúncio.
  final bool ready;

  /// A pessoa pode (e deve poder) rever a escolha de privacidade.
  final bool privacyOptionsRequired;

  const AdsState({this.ready = false, this.privacyOptionsRequired = false});

  AdsState copyWith({bool? ready, bool? privacyOptionsRequired}) => AdsState(
    ready: ready ?? this.ready,
    privacyOptionsRequired:
        privacyOptionsRequired ?? this.privacyOptionsRequired,
  );
}

class AdsController extends Notifier<AdsState> {
  bool _started = false;
  InterstitialAd? _interstitial;
  DateTime _lastInterstitial = DateTime.now();

  @override
  AdsState build() => const AdsState();

  /// Chamado uma vez no main(): consentimento (LGPD/GDPR) → SDK → pré-carrega tela cheia.
  void init() {
    if (!monetizationSupported) return;
    final info = ConsentInformation.instance;
    info.requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      await ConsentForm.loadAndShowConsentFormIfRequired(
        (_) => _startIfAllowed(),
      );
      final status = await info.getPrivacyOptionsRequirementStatus();
      state = state.copyWith(
        privacyOptionsRequired:
            status == PrivacyOptionsRequirementStatus.required,
      );
    }, (_) => _startIfAllowed());
    // Consentimento de uma sessão anterior já vale: não espera o formulário.
    _startIfAllowed();
  }

  Future<void> _startIfAllowed() async {
    if (_started || !await ConsentInformation.instance.canRequestAds()) return;
    _started = true;
    await MobileAds.instance.initialize();
    state = state.copyWith(ready: true);
    _loadInterstitial();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  /// Mostra tela cheia se já passou o intervalo mínimo (ex.: ao sair de um vídeo).
  void maybeShowInterstitial() {
    final ad = _interstitial;
    if (!state.ready || ref.read(premiumProvider) || ad == null) return;
    if (DateTime.now().difference(_lastInterstitial) <
        Monetization.interstitialMinInterval) {
      return;
    }
    _interstitial = null;
    _lastInterstitial = DateTime.now();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadInterstitial();
      },
    );
    ad.show();
  }

  Future<void> showPrivacyOptions() =>
      ConsentForm.showPrivacyOptionsForm((_) {});
}

final adsProvider = NotifierProvider<AdsController, AdsState>(
  AdsController.new,
);

// ─── Remover anúncios (compra única) ─────────────────────────────────────────

const _keyAdsRemoved = 'ads_removed_v1';

enum PurchaseResult { started, unavailable, error }

class PremiumController extends Notifier<bool> {
  StreamSubscription<List<PurchaseDetails>>? _sub;

  @override
  bool build() {
    ref.onDispose(() => _sub?.cancel());
    return ref.watch(sharedPreferencesProvider).getBool(_keyAdsRemoved) ??
        false;
  }

  /// Escuta compras (inclusive as que terminam depois de fechar o app).
  void init() {
    if (!monetizationSupported || _sub != null) return;
    _sub = InAppPurchase.instance.purchaseStream.listen(
      _onPurchases,
      onError: (_) {},
    );
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID == Monetization.removeAdsProductId &&
          (p.status == PurchaseStatus.purchased ||
              p.status == PurchaseStatus.restored)) {
        await ref.read(sharedPreferencesProvider).setBool(_keyAdsRemoved, true);
        state = true;
      }
      if (p.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(p);
      }
    }
  }

  /// Preço formatado pela loja (ex.: "R$ 9,90"), ou null se a loja não respondeu.
  Future<ProductDetails?> product() async {
    if (!monetizationSupported || !await InAppPurchase.instance.isAvailable()) {
      return null;
    }
    final res = await InAppPurchase.instance.queryProductDetails({
      Monetization.removeAdsProductId,
    });
    return res.productDetails.firstOrNull;
  }

  Future<PurchaseResult> buy() async {
    try {
      final details = await product();
      if (details == null) return PurchaseResult.unavailable;
      await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(productDetails: details),
      );
      return PurchaseResult.started;
    } catch (_) {
      return PurchaseResult.error;
    }
  }

  Future<void> restore() async {
    if (monetizationSupported) await InAppPurchase.instance.restorePurchases();
  }
}

final premiumProvider = NotifierProvider<PremiumController, bool>(
  PremiumController.new,
);
