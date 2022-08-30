class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  // static const String baseUrl = 'http://192.168.29.112:8080';
  // static const String baseUrl = 'http://localhost:8080';

  static const String homeUrl = '/home';
  static String getTrendUrl(int trendId) => '/trend?id=$trendId';

  static String getArticleDetailUrl(String articleId) {
    return '/article?id=$articleId';
  }
}
