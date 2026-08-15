class VideoModel {
  final String id;
  final String title;
  final String channelName;
  final String channelAvatarUrl;
  final String duration;
  final String thumbnailUrl;
  final String? localThumbnailAsset;
  final String youtubeVideoId;
  final String category;
  final DateTime publishedAt;
  final int viewsCount;

  const VideoModel({
    required this.id,
    required this.title,
    required this.channelName,
    required this.channelAvatarUrl,
    required this.duration,
    required this.thumbnailUrl,
    this.localThumbnailAsset,
    required this.youtubeVideoId,
    required this.category,
    required this.publishedAt,
    required this.viewsCount,
  });
}
