import '../domain/video_model.dart';

abstract class VideosRepository {
  Future<List<VideoModel>> getVideos({String? category, String? query});
  Future<VideoModel?> getVideoById(String id);
}

class MockVideosRepository implements VideosRepository {
  final List<VideoModel> _videos = [
    VideoModel(
      id: 'v_trailer1',
      title: 'Grand Theft Auto VI Trailer 1 (Oficial)',
      channelName: 'Rockstar Games',
      channelAvatarUrl: '',
      duration: '1:31',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/gtavi_lucia_jason.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 120)),
      viewsCount: 195000000,
    ),
    VideoModel(
      id: 'v_flow1',
      title: 'TUDO SOBRE GTA VI! Análise do Trailer, Mapa e Gráficos RAGE 9',
      channelName: 'Flow Games',
      channelAvatarUrl: '',
      duration: '45:20',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_downtown.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      viewsCount: 420000,
    ),
    VideoModel(
      id: 'v_flow2',
      title: 'GTA VI VAZOU MAIS INFORMAÇÕES! IA Policial e Detalhes de Vice City',
      channelName: 'Flow Games',
      channelAvatarUrl: '',
      duration: '32:15',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_beach.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      viewsCount: 310000,
    ),
    VideoModel(
      id: 'v_brksedu',
      title: 'REAGINDO AO TRAILER DO GTA 6! O JOGO MAIS ESPERADO DA HISTÓRIA!',
      channelName: 'BRKsEDU',
      channelAvatarUrl: '',
      duration: '18:40',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/splash_vice_city.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      viewsCount: 890000,
    ),
    VideoModel(
      id: 'v_ignbr',
      title: 'GTA 6: 25 Segredos e Detalhes Escondidos no Trailer',
      channelName: 'IGN Brasil',
      channelAvatarUrl: '',
      duration: '12:05',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_cars.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 15)),
      viewsCount: 650000,
    ),
    VideoModel(
      id: 'v_cellbit',
      title: 'GTA VI — A EVOLUÇÃO GRÁFICA DE VICE CITY (2002 vs 2026)',
      channelName: 'Cellbit',
      channelAvatarUrl: '',
      duration: '28:12',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_downtown.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 8)),
      viewsCount: 1200000,
    ),
    VideoModel(
      id: 'v_guinas',
      title: 'LUCIA É A MELHOR PROTAGONISTA DE GTA? Análise da Personagem',
      channelName: 'MrGuinas',
      channelAvatarUrl: '',
      duration: '22:50',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/lucia_portrait.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 12)),
      viewsCount: 780000,
    ),
    VideoModel(
      id: 'v_flow3',
      title: 'OS CARROS MAIS INSANOS DO GTA VI! Superesportivos e Muscle Cars',
      channelName: 'Flow Games',
      channelAvatarUrl: '',
      duration: '38:05',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_cars.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      viewsCount: 520000,
    ),
    VideoModel(
      id: 'v_trailer_fan',
      title: 'GTA VI Trailer 2 CONCEPT — Fan Made (4K Ultra Realistic)',
      channelName: 'Vice City Studios',
      channelAvatarUrl: '',
      duration: '2:45',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/vice_city_beach.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 20)),
      viewsCount: 3500000,
    ),
    VideoModel(
      id: 'v_mapa',
      title: 'O MAPA COMPLETO DO GTA VI FOI DESCOBERTO! Análise e Comparações',
      channelName: 'Flow Games',
      channelAvatarUrl: '',
      duration: '51:30',
      thumbnailUrl: '',
      localThumbnailAsset: 'assets/images/gtavi_map_3d.png',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      viewsCount: 680000,
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
