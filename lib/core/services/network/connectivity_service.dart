import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Stream<bool> get onConnectionChanged =>
      _connectivity.onConnectivityChanged.asyncMap(_hasInternetFromResults);

  Future<bool> hasInternet() async {
    final results = await _connectivity.checkConnectivity();
    return _hasInternetFromResults(results);
  }

  Future<bool> _hasInternetFromResults(Object results) async {
    final hasNetwork = switch (results) {
      List<ConnectivityResult> list =>
        list.isNotEmpty && !list.contains(ConnectivityResult.none),
      ConnectivityResult value => value != ConnectivityResult.none,
      _ => false,
    };

    if (!hasNetwork) {
      return false;
    }

    try {
      final lookup = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 3));
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
