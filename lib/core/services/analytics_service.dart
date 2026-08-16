/// Abstração para analytics futuros.
/// Implementações reais (Firebase Analytics, Mixpanel, etc.)
/// substituirão o NoOpAnalyticsService sem alterar a UI.
abstract class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? params});
  void logSearch(String query);
  void logContentView(String contentType, String contentId);
  void logFavorite(String contentType, String contentId);
  void logMapOpen();
  void logGuideOpen(String guideId);
  void logVideoWatch(String videoId);
}

/// Implementação vazia para desenvolvimento.
class NoOpAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, {Map<String, dynamic>? params}) {}
  @override
  void logSearch(String query) {}
  @override
  void logContentView(String contentType, String contentId) {}
  @override
  void logFavorite(String contentType, String contentId) {}
  @override
  void logMapOpen() {}
  @override
  void logGuideOpen(String guideId) {}
  @override
  void logVideoWatch(String videoId) {}
}
