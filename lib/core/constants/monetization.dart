/// Tudo o que gera dinheiro, num lugar só.
///
/// Os IDs abaixo são os de TESTE do Google (mostram anúncios de exemplo, não pagam).
/// Antes de publicar, trocar pelos do seu AdMob — e também o App ID em
/// android/app/src/main/AndroidManifest.xml e ios/Runner/Info.plist (GADApplicationIdentifier).
abstract class Monetization {
  static const bannerAndroid = 'ca-app-pub-3940256099942544/9214589741';
  static const bannerIos = 'ca-app-pub-3940256099942544/2435281174';
  static const interstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const interstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  /// Tela cheia: no máximo uma a cada X, e nunca nos primeiros X de uso.
  static const interstitialMinInterval = Duration(minutes: 3);

  /// Produto "compra única" criado no Play Console / App Store Connect com este ID.
  static const removeAdsProductId = 'remover_anuncios';

  /// Seu ID de afiliado da Amazon (ex.: 'leonidahub-20'). Vazio = links sem comissão.
  static const amazonTag = '';
}
