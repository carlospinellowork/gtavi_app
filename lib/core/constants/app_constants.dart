abstract class AppConstants {
  static const String appName = 'GTA VI Companion';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String keyFavorites = 'gtavi_favorites_v1';
  static const String keyCompletedItems = 'gtavi_completed_items_v1';
  static const String keyUserProfile = 'gtavi_user_profile_v1';
  static const String keyAuthToken = 'gtavi_auth_token_v1';

  // API Base Config (Ready for future Node.js backend)
  static const String apiBaseUrl = 'https://api.gtavi-companion.com/v1';
  static const int apiConnectTimeout = 10000;
  static const int apiReceiveTimeout = 10000;
}
