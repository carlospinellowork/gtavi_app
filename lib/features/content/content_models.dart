/// Modelos do arquivo assets/content/content.json (mesmo formato do arquivo remoto).
library;

DateTime _date(Object? v) => DateTime.tryParse('${v ?? ''}') ?? DateTime(2000);
String _str(Object? v) => v?.toString() ?? '';
List<Map<String, dynamic>> _list(Object? v) =>
    (v as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();

class AppContent {
  final int version;
  final DateTime updatedAt;
  final DateTime releaseDate;
  final List<String> platforms;
  final List<NewsItem> news;
  final List<VideoItem> videos;
  final List<CharacterItem> characters;
  final List<PlaceItem> places;
  final List<FactItem> facts;
  final List<ChecklistGroup> checklist;

  const AppContent({
    required this.version,
    required this.updatedAt,
    required this.releaseDate,
    required this.platforms,
    required this.news,
    required this.videos,
    required this.characters,
    required this.places,
    required this.facts,
    required this.checklist,
  });

  factory AppContent.fromJson(Map<String, dynamic> json) {
    final release = _date(json['releaseDate']);
    final news = _list(json['news']).map(NewsItem.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return AppContent(
      version: (json['version'] as num?)?.toInt() ?? 0,
      updatedAt: _date(json['updatedAt']),
      // Meia-noite local do dia de lançamento.
      releaseDate: DateTime(release.year, release.month, release.day),
      platforms: (json['platforms'] as List<dynamic>? ?? const []).map(_str).toList(),
      news: news,
      videos: _list(json['videos']).map(VideoItem.fromJson).toList(),
      characters: _list(json['characters']).map(CharacterItem.fromJson).toList(),
      places: _list(json['places']).map(PlaceItem.fromJson).toList(),
      facts: _list(json['facts']).map(FactItem.fromJson).toList(),
      checklist: _list(json['checklist']).map(ChecklistGroup.fromJson).toList(),
    );
  }

  int get checklistTotal => checklist.fold(0, (sum, g) => sum + g.items.length);
}

class NewsItem {
  final String id, title, summary, source, url, tag;
  final DateTime date;

  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.url,
    required this.tag,
    required this.date,
  });

  factory NewsItem.fromJson(Map<String, dynamic> j) => NewsItem(
        id: _str(j['id']),
        title: _str(j['title']),
        summary: _str(j['summary']),
        source: _str(j['source']),
        url: _str(j['url']),
        tag: _str(j['tag']),
        date: _date(j['date']),
      );
}

class VideoItem {
  final String id, title, channel, youtubeId;
  final DateTime date;

  const VideoItem({
    required this.id,
    required this.title,
    required this.channel,
    required this.youtubeId,
    required this.date,
  });

  factory VideoItem.fromJson(Map<String, dynamic> j) => VideoItem(
        id: _str(j['id']),
        title: _str(j['title']),
        channel: _str(j['channel']),
        youtubeId: _str(j['youtubeId']),
        date: _date(j['date']),
      );

  String get url => 'https://www.youtube.com/watch?v=$youtubeId';
  String get thumbnailUrl => 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
}

class CharacterItem {
  final String id, name, role, description;

  const CharacterItem({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
  });

  factory CharacterItem.fromJson(Map<String, dynamic> j) => CharacterItem(
        id: _str(j['id']),
        name: _str(j['name']),
        role: _str(j['role']),
        description: _str(j['description']),
      );

  String get initials => name
      .split(' ')
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();
}

class PlaceItem {
  final String id, name, description;

  const PlaceItem({required this.id, required this.name, required this.description});

  factory PlaceItem.fromJson(Map<String, dynamic> j) => PlaceItem(
        id: _str(j['id']),
        name: _str(j['name']),
        description: _str(j['description']),
      );
}

class FactItem {
  final String question, answer;

  const FactItem({required this.question, required this.answer});

  factory FactItem.fromJson(Map<String, dynamic> j) =>
      FactItem(question: _str(j['q']), answer: _str(j['a']));
}

class ChecklistGroup {
  final String id, title, description;
  final List<ChecklistItem> items;

  const ChecklistGroup({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
  });

  factory ChecklistGroup.fromJson(Map<String, dynamic> j) => ChecklistGroup(
        id: _str(j['id']),
        title: _str(j['title']),
        description: _str(j['description']),
        items: _list(j['items']).map(ChecklistItem.fromJson).toList(),
      );
}

class ChecklistItem {
  final String id, title, note;

  const ChecklistItem({required this.id, required this.title, required this.note});

  factory ChecklistItem.fromJson(Map<String, dynamic> j) => ChecklistItem(
        id: _str(j['id']),
        title: _str(j['title']),
        note: _str(j['note']),
      );
}
