abstract class AppConstants {
  /// Nome nas lojas e na tela. Sem "GTA" no nome: as lojas barram marca de terceiros.
  static const String appName = 'Leonida Hub';
  static const String appTagline = 'Guia de fã não oficial para o GTA 6';

  /// Arquivo de conteúdo remoto: o mesmo assets/content/content.json deste repositório
  /// (público), atualizado pelo robô a cada 30 min. Sem internet, o app usa a cópia embutida.
  static const String contentUrl =
      'https://raw.githubusercontent.com/carlospinellowork/gtavi_app/main/assets/content/content.json';

  static const String privacyPolicyUrl =
      'https://github.com/carlospinellowork/gtavi_app/blob/main/PRIVACY.md';

  static const String disclaimer =
      'Leonida Hub é um app de fã, não oficial. Não tem ligação com a Rockstar Games '
      'nem com a Take-Two Interactive. Grand Theft Auto e GTA são marcas das '
      'respectivas donas, citadas aqui só para identificar o jogo.';

  // Chaves de armazenamento local
  static const String keyContentCache = 'content_cache_v1';
  static const String keyChecklistDone = 'checklist_done_v1';
}
