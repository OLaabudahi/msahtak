abstract class InternetSource {
  Future<bool> hasInternet();

  Stream<bool> onConnectionChanged();
}
