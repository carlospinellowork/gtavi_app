import '../domain/news_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/ai_feed_agent.dart';

abstract class NewsRepository {
  Future<List<NewsModel>> getNews({String? category, String? query});
  Future<NewsModel?> getNewsById(String id);
}

class MockNewsRepository implements NewsRepository {
  final ApiClient? apiClient;
  final GtaViAiFeedAgent aiAgent;

  MockNewsRepository({this.apiClient, GtaViAiFeedAgent? aiAgent})
      : aiAgent = aiAgent ?? GtaViAiFeedAgent();

  @override
  Future<List<NewsModel>> getNews({String? category, String? query}) async {
    var list = await aiAgent.fetchLiveUpdates();

    if (category != null && category.isNotEmpty && category != 'Todas') {
      list = list.where((n) => n.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list.where((n) => n.title.toLowerCase().contains(q) || n.summary.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  @override
  Future<NewsModel?> getNewsById(String id) async {
    final list = await aiAgent.fetchLiveUpdates();
    try {
      return list.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }
}
