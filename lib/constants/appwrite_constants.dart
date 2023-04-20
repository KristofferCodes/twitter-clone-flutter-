class AppWriteConstants {
  static const String databaseId = '643e520eda0ebdbb0d6b';
  static const String projectId = '643dfbfad3dfcf6249d8';
  static const String endpoint = 'http://localhost:80/v1';

  static const String usersCollection = '643f45df83fbf87205a7';
  static const String tweetsCollection = '64402ce7f34523c523ad';

  static const String imagesBucket = '6440ca499b16ce54079b';

  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
