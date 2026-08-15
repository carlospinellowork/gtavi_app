import 'dart:async';
import '../../features/news/domain/news_model.dart';

class GtaViAiFeedAgent {
  final StreamController<List<NewsModel>> _newsStreamController = StreamController<List<NewsModel>>.broadcast();

  Stream<List<NewsModel>> get newsStream => _newsStreamController.stream;

  bool isAgentScanning = false;
  DateTime lastScanTime = DateTime.now();

  Future<List<NewsModel>> fetchLiveUpdates() async {
    isAgentScanning = true;
    await Future.delayed(const Duration(milliseconds: 400));

    final liveNews = [
      NewsModel(
        id: 'ai_1',
        title: 'IA FEED: Novo Teaser de Vice City Capturado pela Inteligência',
        summary: 'O agente automatizado identificou atualização oficial com imagem das praias de Vice City e detalhes da iluminação noturna.',
        source: 'Agente IA • Rockstar Feed',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 10)),
        url: 'https://www.rockstargames.com/VI',
        imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
        isFeatured: true,
      ),
      NewsModel(
        id: 'n1',
        title: 'GTA VI Trailer Official #1 Breakdowns & Segredos',
        summary: 'Lucia e Jason em Vice City! Análise quadro a quadro de todas as cenas, praias, veículos e detalhes revelados pela Rockstar Games.',
        source: 'Rockstar Newswire',
        category: 'Trailer',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        url: 'https://www.rockstargames.com/VI',
        imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800',
        videoUrl: 'https://www.youtube.com/watch?v=QdBZY2fkU-0',
        isFeatured: true,
      ),
      NewsModel(
        id: 'n2',
        title: 'Lucia & Jason: Tudo sobre a dupla de protagonistas',
        summary: 'Como funcionará a dinâmica no estilo Bonnie & Clyde, troca de personagens no meio dos golpes e sistema de inventário compartilhado.',
        source: 'IGN Vice City Special',
        category: 'Destaque',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
        url: 'https://ign.com',
        imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800',
        isFeatured: true,
      ),
      NewsModel(
        id: 'n3',
        title: 'Vazamentos indicam sistema de IA policial ultra realista',
        summary: 'Documentos e dados minerados indicam que a polícia de Vice City usará táticas de cerco com helicópteros, bloqueios e reconhecimento facial.',
        source: 'GTA Forums',
        category: 'Vazamento',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        url: 'https://gtaforums.com',
        imageUrl: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800',
        isFeatured: false,
      ),
    ];

    isAgentScanning = false;
    lastScanTime = DateTime.now();
    _newsStreamController.add(liveNews);
    return liveNews;
  }
}
