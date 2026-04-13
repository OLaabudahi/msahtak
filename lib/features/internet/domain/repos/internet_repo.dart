abstract class InternetRepo {
  Future<bool> hasInternet();

  Stream<bool> watchConnection();
}
