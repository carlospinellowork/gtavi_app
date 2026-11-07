abstract class AppConstants {
  /// Nome nas lojas e na tela. Sem "GTA" no nome: as lojas barram marca de terceiros.
  static const String appName = 'Neon Guide';
  static const String appTagline = 'Guia de fã não oficial para o GTA 6';

  /// Arquivo de conteúdo remoto. Precisa estar num repositório PÚBLICO.
  /// Enquanto não existir, o app usa a cópia embutida em assets/content/content.json.
  static const String contentUrl =
      'https://raw.githubusercontent.com/carlospinellowork/neon-guide-content/main/content.json';

  static const String privacyPolicyUrl =
      'https://github.com/carlospinellowork/neon-guide-content/blob/main/PRIVACY.md';

  static const String disclaimer =
      'Neon Guide é um app de fã, não oficial. Não tem ligação com a Rockstar Games '
      'nem com a Take-Two Interactive. Grand Theft Auto e GTA são marcas das '
      'respectivas donas, citadas aqui só para identificar o jogo.';

  // Chaves de armazenamento local
  static const String keyContentCache = 'content_cache_v1';
  static const String keyChecklistDone = 'checklist_done_v1';
}
