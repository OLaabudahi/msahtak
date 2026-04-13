import '../../domain/repos/internet_repo.dart';
import '../sources/internet_source.dart';

class InternetRepoImpl implements InternetRepo {
  final InternetSource source;

  InternetRepoImpl(this.source);

  @override
  Future<bool> hasInternet() {
    return source.hasInternet();
  }

  @override
  Stream<bool> watchConnection() {
    return source.onConnectionChanged();
  }
}
