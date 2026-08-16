/// Tipo global de entidade do knowledge base.
/// Usado para busca global, favoritos tipados e relações.
enum EntityType {
  character,
  vehicle,
  location,
  mission,
  weapon,
  business,
  activity,
  collectible,
  easterEgg,
  radio,
  guide,
  news,
  video,
  media,
  cheat,
}

extension EntityTypeExt on EntityType {
  String get label {
    switch (this) {
      case EntityType.character:
        return 'Personagem';
      case EntityType.vehicle:
        return 'Veículo';
      case EntityType.location:
        return 'Local';
      case EntityType.mission:
        return 'Missão';
      case EntityType.weapon:
        return 'Arma';
      case EntityType.business:
        return 'Negócio';
      case EntityType.activity:
        return 'Atividade';
      case EntityType.collectible:
        return 'Colecionável';
      case EntityType.easterEgg:
        return 'Easter Egg';
      case EntityType.radio:
        return 'Rádio';
      case EntityType.guide:
        return 'Guia';
      case EntityType.news:
        return 'Notícia';
      case EntityType.video:
        return 'Vídeo';
      case EntityType.media:
        return 'Mídia';
      case EntityType.cheat:
        return 'Macete';
    }
  }

  String get emoji {
    switch (this) {
      case EntityType.character:
        return '👤';
      case EntityType.vehicle:
        return '🚗';
      case EntityType.location:
        return '📍';
      case EntityType.mission:
        return '🎯';
      case EntityType.weapon:
        return '🔫';
      case EntityType.business:
        return '💰';
      case EntityType.activity:
        return '🎮';
      case EntityType.collectible:
        return '⭐';
      case EntityType.easterEgg:
        return '🕵️';
      case EntityType.radio:
        return '📻';
      case EntityType.guide:
        return '📚';
      case EntityType.news:
        return '📰';
      case EntityType.video:
        return '🎬';
      case EntityType.media:
        return '🖼️';
      case EntityType.cheat:
        return '🎮';
    }
  }

  static EntityType fromString(String value) {
    return EntityType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EntityType.guide,
    );
  }
}
