import '../../../../core/services/network/connectivity_service.dart';
import 'internet_source.dart';

class InternetSourceConnectivity implements InternetSource {
  final ConnectivityService service;

  InternetSourceConnectivity(this.service);

  @override
  Future<bool> hasInternet() {
    return service.hasInternet();
  }

  @override
  Stream<bool> onConnectionChanged() {
    return service.onConnectionChanged;
  }
}
