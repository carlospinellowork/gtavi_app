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
      channelAvatarUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=200',
      duration: '1:31',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Trailers',
      publishedAt: DateTime.now().subtract(const Duration(days: 120)),
      viewsCount: 195000000,
    ),
    VideoModel(
      id: 'v_flow1',
      title: 'TUDO SOBRE GTA VI! Análise do Trailer, Mapa e Gráficos RAGE 9',
      channelName: 'Flow Games',
      channelAvatarUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=200',
      duration: '45:20',
      thumbnailUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      viewsCount: 420000,
    ),
    VideoModel(
      id: 'v_flow2',
      title: 'GTA VI VAZOU MAIS INFORMAÇÕES! IA Policial e Detalhes de Vice City',
      channelName: 'Flow Games',
      channelAvatarUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=200',
      duration: '32:15',
      thumbnailUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Flow Games',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      viewsCount: 310000,
    ),
    VideoModel(
      id: 'v_brksedu',
      title: 'REAGINDO AO TRAILER DO GTA 6! O JOGO MAIS ESPERADO DA HISTÓRIA!',
      channelName: 'BRKsEDU',
      channelAvatarUrl: 'https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=200',
      duration: '18:40',
      thumbnailUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 10)),
      viewsCount: 890000,
    ),
    VideoModel(
      id: 'v_ignbr',
      title: 'GTA 6: 25 Segredos e Detalhes Escondidos no Trailer',
      channelName: 'IGN Brasil',
      channelAvatarUrl: 'https://images.unsplash.com/photo-1579373903781-fd5c0c30c4cd?w=200',
      duration: '12:05',
      thumbnailUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
      youtubeVideoId: 'QdBZY2fkU-0',
      category: 'Análises',
      publishedAt: DateTime.now().subtract(const Duration(days: 15)),
      viewsCount: 650000,
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
