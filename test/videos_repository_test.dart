import 'package:flutter_test/flutter_test.dart';
import 'package:gtavi_app/features/videos/data/videos_repository.dart';

void main() {
  group('MockVideosRepository', () {
    late MockVideosRepository repository;

    setUp(() {
      repository = MockVideosRepository();
    });

    test('retorna a lista completa de vídeos quando nenhum filtro é passado', () async {
      final videos = await repository.getVideos();
      expect(videos.length, equals(17));
    });

    test('ordena os vídeos do mais recente para o mais antigo', () async {
      final videos = await repository.getVideos();
      for (var i = 0; i < videos.length - 1; i++) {
        expect(videos[i].publishedAt.isAfter(videos[i + 1].publishedAt) || videos[i].publishedAt.isAtSameMomentAs(videos[i + 1].publishedAt), isTrue);
      }
    });

    test('filtra vídeos por categoria Gameplay', () async {
      final videos = await repository.getVideos(category: 'Gameplay');
      expect(videos.length, equals(1));
      expect(videos.first.id, equals('v_extended_look'));
    });

    test('filtra vídeos por busca de texto', () async {
      final videos = await repository.getVideos(query: 'Extended Look');
      expect(videos.length, equals(1));
      expect(videos.first.title, contains('Extended Look'));
    });

    test('retorna vídeo específico por ID', () async {
      final video = await repository.getVideoById('v_extended_look');
      expect(video, isNotNull);
      expect(video?.channelName, equals('Netflix Brasil'));
    });

    test('retorna null para ID inexistente', () async {
      final video = await repository.getVideoById('nao_existe');
      expect(video, isNull);
    });
  });
}
