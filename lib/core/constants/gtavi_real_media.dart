/// URLs reais e verificadas de imagens oficiais de GTA VI, usadas como
/// `imageUrl` em vez de arte gerada por IA. Carregadas via rede com cache
/// (ver [AppNetworkImage]) — nada disso é empacotado no repositório.
///
/// Fontes:
/// - `trailer1Thumbnail`/`trailer2Thumbnail`: thumbnail oficial do YouTube
///   (i.ytimg.com) dos trailers do canal verificado "Rockstar Games".
/// - Demais: screenshots oficiais liberados pela Rockstar em maio/2025,
///   espelhados em rockstarintel.com (o domínio oficial rockstargames.com
///   não pôde ser acessado diretamente por ferramentas de busca no momento
///   da curadoria — vale reavaliar se rockstargames.com passa a responder).
abstract class GtaViRealMedia {
  static const trailer1Thumbnail = 'https://i.ytimg.com/vi/QdBZY2fkU-0/maxresdefault.jpg';
  static const trailer2Thumbnail = 'https://i.ytimg.com/vi/VQRLujxTm3c/maxresdefault.jpg';

  /// "Grand Theft Auto VI: An Extended Look" — 27 minutos de gameplay real
  /// exibidos pela Netflix/Rockstar em 27/08/2026. Thumbnail oficial do
  /// upload da Netflix Brasil (id verificado via oEmbed do YouTube).
  static const extendedLookThumbnail = 'https://i.ytimg.com/vi/LIfPlBFrk0o/hqdefault.jpg';

  /// Data oficial de lançamento confirmada pela Rockstar Games (2º adiamento).
  static final releaseDate = DateTime(2026, 11, 19);

  static const viceCitySign = 'https://rockstarintel.com/wp-content/uploads/2025/05/Vice_City_01-scaled.jpg';
  static const viceCityAerial = 'https://rockstarintel.com/wp-content/uploads/2025/05/Vice_City_03-scaled.jpg';
  static const viceCityBeach = 'https://rockstarintel.com/wp-content/uploads/2025/05/Vice_City_05-scaled.jpg';

  static const luciaGym = 'https://rockstarintel.com/wp-content/uploads/2025/05/Lucia_Caminos_01-scaled.jpg';
  static const luciaPool = 'https://rockstarintel.com/wp-content/uploads/2025/05/Lucia_Caminos_02-1024x576.jpg';
  static const jasonMotorcycle = 'https://rockstarintel.com/wp-content/uploads/2025/05/Jason_Duval_01-scaled.jpg';
}
