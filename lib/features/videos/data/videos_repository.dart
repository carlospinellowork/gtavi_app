import '../domain/video_model.dart';

abstract class VideosRepository {
  Future<List<VideoModel>> getVideos({String? category, String? query});
  Future<VideoModel?> getVideoById(String id);
}

/// Thumbnail oficial do YouTube para um vídeo real — sempre disponível para
/// qualquer vídeo público, sem precisar de scraping ou de chave de API.
String _ytThumbnail(String videoId) => 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';

/// Vídeos reais sobre GTA VI (trailers oficiais + criadores de conteúdo),
/// verificados via a API oEmbed do YouTube antes de entrarem aqui: título e
/// canal vêm exatamente do que o oEmbed retornou (nada inventado). Duração e
/// contagem de views não são expostas pelo oEmbed sem uma chave de API do
/// YouTube — por isso ficam vazias/zeradas em vez de serem fabricadas.
class MockVideosRepository implements VideosRepository {
  final List<VideoModel> _videos = [
    VideoModel(
      id: 'v_trailer1',
      title: 'Grand Theft Auto VI Trailer 1',
      channelName: 'Rockstar Games',
      channelAvatarUrl: '',
      duration: '1:31',
      thumbnailUrl: _ytThumbnail('QdBZY2fkU-0'),
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 120)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_trailer2',
      title: 'Grand Theft Auto VI Trailer 2',
      channelName: 'Rockstar Games',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('VQRLujxTm3c'),
      youtubeVideoId: 'VQRLujxTm3c',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 30)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_trailer2_br',
      title: 'Grand Theft Auto VI | 2º Trailer',
      channelName: 'Rockstar Games Brasil',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('IpSDW3Mq-7E'),
      youtubeVideoId: 'IpSDW3Mq-7E',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 30)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_ign_trailer2',
      title: 'GTA 6 (Grand Theft Auto 6) - Official Trailer 2',
      channelName: 'IGN',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('yAi0MYo5Mzw'),
      youtubeVideoId: 'yAi0MYo5Mzw',
      category: 'Notícias',
      publishedAt: DateTime.now().subtract(const Duration(days: 29)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_flow_reage1',
      title: 'FLOW GAMES REAGE: TRAILER DUBLADO de GTA 6 #flowgames',
      channelName: 'Cortes do Flow Games',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('BsQDp1fVQSI'),
      youtubeVideoId: 'BsQDp1fVQSI',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 118)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_flow_reage2',
      title: 'FLOW GAMES REAGE: TRAILER 2 DE GTA 6!! #fgn',
      channelName: 'Cortes do Flow Games',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('NUPoKcEU-tw'),
      youtubeVideoId: 'NUPoKcEU-tw',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 28)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_flow_reage2b',
      title: 'FLOW GAMES REAGE DE NOVO: TRAILER 2 DE GTA 6!! #fgn',
      channelName: 'Cortes do Flow Games',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('0gdT-yMRiy0'),
      youtubeVideoId: '0gdT-yMRiy0',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 27)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_brksedu_vazamentos',
      title: 'BRKsEDU comenta os NOVOS VAZAMENTOS da HISTÓRIA de GTA 6',
      channelName: 'Cortes do BRKsEDU',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('TJpnEpbJLyI'),
      youtubeVideoId: 'TJpnEpbJLyI',
      category: 'Notícias',
      publishedAt: DateTime.now().subtract(const Duration(days: 90)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_brksedu_revolucao',
      title: 'GTA 6: Que tipo de REVOLUÇÃO podemos esperar no game? BRKsEDU comenta!',
      channelName: 'Cortes do BRKsEDU',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('yZsPEJtLLAk'),
      youtubeVideoId: 'yZsPEJtLLAk',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 85)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_brksedu_adiamento',
      title: 'Reação e opinião do BRKsEDU sobre ADIAMENTO de GTA 6!',
      channelName: 'Cortes do BRKsEDU',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('EcVDW1wNxHM'),
      youtubeVideoId: 'EcVDW1wNxHM',
      category: 'Notícias',
      publishedAt: DateTime.now().subtract(const Duration(days: 200)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_brksedu_online',
      title: 'GTA 6 deve ter MODO ONLINE no DIA DE LANÇAMENTO? BRKsEDU comenta!',
      channelName: 'Cortes do BRKsEDU',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('dFhPdpMPJ_Y'),
      youtubeVideoId: 'dFhPdpMPJ_Y',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 60)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_cellbit_impressionante',
      title: 'Esse novo trailer do GTA 6 tá IMPRESSIONANTE',
      channelName: 'Cellbit Lives',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('zUROhWGRz0c'),
      youtubeVideoId: 'zUROhWGRz0c',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 29)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_cellbit_real',
      title: 'A REAL sobre GTA 6 [Cellbit]',
      channelName: 'Cortes do Davy Jones [OFICIAL]',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('g_vJU4H5WSo'),
      youtubeVideoId: 'g_vJU4H5WSo',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 95)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_beloto_detalhes',
      title: 'BRASIL NO NOVO TRAILER DO GTA 6: DETALHES QUE NINGUÉM VIU + NOVAS IMAGENS ALÉM DA CAPA!',
      channelName: 'BelotoPlays',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('ksc8PkHyBWQ'),
      youtubeVideoId: 'ksc8PkHyBWQ',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 27)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_cupcortes_1',
      title: 'RELEMBRE O CAOS! YOUTUBERS REAGINDO AO 1º TRAILER DE GTA 6 PELA PRIMEIRA VEZ',
      channelName: 'CupCortesTV',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('FxHG3gzuPC4'),
      youtubeVideoId: 'FxHG3gzuPC4',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 110)),
      viewsCount: 0,
    ),
    VideoModel(
      id: 'v_cupcortes_2',
      title: 'NINGUÉM IMAGINAVA! YOUTUBERS REAGINDO AO 2º TRAILER DE GTA 6 PELA PRIMEIRA VEZ',
      channelName: 'CupCortesTV',
      channelAvatarUrl: '',
      duration: '',
      thumbnailUrl: _ytThumbnail('klYL5iDkWC8'),
      youtubeVideoId: 'klYL5iDkWC8',
      category: 'Reações',
      publishedAt: DateTime.now().subtract(const Duration(days: 25)),
      viewsCount: 0,
    ),
  ];

  @override
  Future<List<VideoModel>> getVideos({String? category, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var list = _videos;

    if (category != null && category.isNotEmpty && category != 'Todos') {
      list = list.where((v) => v.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((v) => v.title.toLowerCase().contains(q) || v.channelName.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<VideoModel?> getVideoById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _videos.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }
}
