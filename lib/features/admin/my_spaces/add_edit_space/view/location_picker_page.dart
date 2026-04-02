import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:Msahtak/features/map/data/sources/location_service.dart';

/// طµظپط­ط© ط§ط®طھظٹط§ط± ط§ظ„ظ…ظˆظ‚ط¹ ظ…ظ† ط§ظ„ط®ط±ظٹط·ط© â€“ طھظڈط¹ظٹط¯ (lat, lng) ط¹ظ†ط¯ ط§ظ„طھط£ظƒظٹط¯
class LocationPickerPage extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const LocationPickerPage({super.key, this.initialLat, this.initialLng});

  /// ظپطھط­ ط§ظ„طµظپط­ط© ظˆط§ظ„ط§ظ†طھط¸ط§ط± ظ„ظ„ط­طµظˆظ„ ط¹ظ„ظ‰ ط§ظ„ظ…ظˆظ‚ط¹ ط§ظ„ظ…ط®طھط§ط±
  static Future<(double, double)?> show(
    BuildContext context, {
    double? lat,
    double? lng,
  }) {
    return Navigator.of(context).push<(double, double)>(
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(initialLat: lat, initialLng: lng),
      ),
    );
  }

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  static const double _fallbackLat = 31.511136495468655;
  static const double _fallbackLng = 34.45187681199389;

  LatLng? _picked;
  LatLng _center = const LatLng(_fallbackLat, _fallbackLng);
  bool _loading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initCenter();
  }

  Future<void> _initCenter() async {
    // ط¥ط°ط§ ظپظٹ ط¥ط­ط¯ط§ط«ظٹط§طھ ظ…ظڈظ…ط±ط±ط©طŒ ظ†ط¨ط¯ط£ ظ…ظ†ظ‡ط§
    if (widget.initialLat != null && widget.initialLng != null) {
      _picked = LatLng(widget.initialLat!, widget.initialLng!);
      _center = _picked!;
      setState(() => _loading = false);
      return;
    }
    // ظˆط¥ظ„ط§ ظ†ط¬ظٹط¨ ط§ظ„ظ…ظˆظ‚ط¹ ط§ظ„ط­ط§ظ„ظٹ
    final pos = await GeolocatorLocationService().getCurrentLocation();
    if (mounted) {
      setState(() {
        _center = LatLng(pos.lat, pos.lng);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          if (_picked != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                (_picked!.latitude, _picked!.longitude),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 15.0,
                onTap: (_, point) {
                  setState(() => _picked = point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.masahtak_app',
                ),
                if (_picked != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _picked!,
                        width: 48,
                        height: 48,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

          // طھط¹ظ„ظٹظ…ط§طھ ظپظٹ ط§ظ„ط£ط³ظپظ„
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.12),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _picked == null
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Tap on the map to pin a location',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_picked!.latitude.toStringAsFixed(5)}, '
                            '${_picked!.longitude.toStringAsFixed(5)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(
                            (_picked!.latitude, _picked!.longitude),
                          ),
                          child: const Text('Confirm'),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}


