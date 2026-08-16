/// Status de confiabilidade de um conteúdo.
enum ContentStatus {
  /// 🟢 Confirmado oficialmente pela Rockstar Games
  confirmed,

  /// 🔵 Descoberto pela comunidade (datamining, gameplay, etc.)
  community,

  /// 🟡 Reportado por fontes confiáveis (jornalistas, insiders)
  reported,

  /// 🔴 Rumor ou especulação sem confirmação
  rumor,
}

/// Extensão para obter emoji e label do status.
extension ContentStatusExt on ContentStatus {
  String get emoji {
    switch (this) {
      case ContentStatus.confirmed:
        return '🟢';
      case ContentStatus.community:
        return '🔵';
      case ContentStatus.reported:
        return '🟡';
      case ContentStatus.rumor:
        return '🔴';
    }
  }

  String get label {
    switch (this) {
      case ContentStatus.confirmed:
        return 'Confirmado';
      case ContentStatus.community:
        return 'Comunidade';
      case ContentStatus.reported:
        return 'Reportado';
      case ContentStatus.rumor:
        return 'Rumor';
    }
  }

  static ContentStatus fromString(String value) {
    return ContentStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ContentStatus.rumor,
    );
  }
}

/// Metadados de origem/confiabilidade de conteúdo.
class ContentMeta {
  final ContentStatus status;
  final String? source;
  final String? sourceUrl;
  final DateTime? verifiedAt;

  const ContentMeta({
    this.status = ContentStatus.rumor,
    this.source,
    this.sourceUrl,
    this.verifiedAt,
  });

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'source': source,
        'sourceUrl': sourceUrl,
        'verifiedAt': verifiedAt?.toIso8601String(),
      };

  factory ContentMeta.fromJson(Map<String, dynamic> json) {
    return ContentMeta(
      status: ContentStatusExt.fromString(json['status'] as String? ?? 'rumor'),
      source: json['source'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.tryParse(json['verifiedAt'] as String)
          : null,
    );
  }
}
