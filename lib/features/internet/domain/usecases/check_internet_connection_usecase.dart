import '../repos/internet_repo.dart';

class CheckInternetConnectionUseCase {
  final InternetRepo repo;

  const CheckInternetConnectionUseCase(this.repo);

  Future<bool> call() {
    return repo.hasInternet();
  }
}
