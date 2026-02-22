import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../space_details/view/space_details_page.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../data/repos/map_repo_impl.dart';
import '../data/sources/location_service.dart';
import '../data/sources/nearby_spaces_data_source.dart';
import '../domain/entities/geo_point_entity.dart';
import '../domain/usecases/get_current_location_usecase.dart';
import '../domain/usecases/get_nearby_spaces_usecase.dart';
import '../widgets/map_radius_badge.dart';
import '../widgets/nearby_space_card.dart';
import '../widgets/nearby_space_bottom_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  static Widget withBloc() {
    final repo = MapRepoImpl(
      locationService: DummyLocationService(
        fixed: const GeoPointEntity(
          lat: 31.511136495468655,
          lng: 34.45187681199389,
        ),
      ),
      dataSource: DummyNearbySpacesDataSource(),
    );

    return BlocProvider(
      create: (_) => MapBloc(
        getCurrentLocation: GetCurrentLocationUseCase(repo),
        getNearbySpaces: GetNearbySpacesUseCase(repo),
      )..add(const MapStarted()),
      child: const MapPage(),
    );
  }

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const _primary = Color(0xFFFBAD20);
  static const _secondary = Color(0xFF5682AF);

  final MapController _mapController = MapController();
  bool _mapReady = false;
  double _currentZoom = 14.2;
  LatLng? _pendingMove;

  void _moveTo(LatLng target) {
    if (!_mapReady) {
      _pendingMove = target;
      return;
    }
    _mapController.move(target, _currentZoom);
  }

  double _zoomForRadius(double radiusKm) {
    // تقريب بسيط: نصف كم أقرب => زوم أعلى
    if (radiusKm <= 0.5) return 15.0;
    return 14.2;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<MapBloc, MapState>(
          listenWhen: (p, c) => p.selectedSpaceId != c.selectedSpaceId,
          listener: (_, state) {
            final s = state.selectedSpace;
            if (s == null) return;
            _moveTo(LatLng(s.location.lat, s.location.lng));
          },
          builder: (context, state) {
            final center = state.center;

            return Stack(
              children: [
                // Map
                Positioned.fill(
                  child: center == null
                      ? const SizedBox()
                      : FlutterMap(
                          mapController: _mapController,

                          options: MapOptions(
                            initialCenter: LatLng(center.lat, center.lng),
                            initialZoom: _zoomForRadius(state.radiusKm),
                            onTap: (_, __) => FocusScope.of(context).unfocus(),
                            onMapReady: () {
                              setState(() => _mapReady = true);

                              // لو كان فيه حركة مؤجلة (جت من Bloc listener)
                              if (_pendingMove != null) {
                                _mapController.move(
                                  _pendingMove!,
                                  _currentZoom,
                                );
                                _pendingMove = null;
                              }
                            },

                            onPositionChanged: (pos, _) {
                              // نحفظ آخر زوم بدل camera
                              final z = pos.zoom;
                              if (z != null) _currentZoom = z;
                            },
                          ),
                          children: [
                            // OpenStreetMap tiles
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.masahtak_app', // غيّريه لباكيدجك
                            ),

                            // دائرة الراديوس
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: LatLng(center.lat, center.lng),
                                  radius: state.radiusKm * 1000.0,
                                  // بالمتر
                                  useRadiusInMeter: true,
                                  color: _secondary.withOpacity(0.22),
                                  borderStrokeWidth: 0,
                                ),
                              ],
                            ),

                            // Markers
                            MarkerLayer(
                              markers: [
                                // Marker للمركز
                                Marker(
                                  point: LatLng(center.lat, center.lng),
                                  width: 44,
                                  height: 44,
                                  child: const Icon(
                                    Icons.my_location,
                                    color: _primary,
                                    size: 30,
                                  ),
                                ),
                                ...state.spaces.map((s) {
                                  final isSelected =
                                      s.id == state.selectedSpaceId;
                                  return Marker(
                                    point: LatLng(
                                      s.location.lat,
                                      s.location.lng,
                                    ),
                                    width: 48,
                                    height: 48,
                                    child: GestureDetector(
                                      onTap: () => context.read<MapBloc>().add(
                                        MapMarkerTapped(s.id),
                                      ),
                                      child: Icon(
                                        Icons.location_pin,
                                        size: isSelected ? 42 : 36,
                                        color: isSelected
                                            ? _primary
                                            : _secondary,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                ),

                // Top bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,

                  child: _TopBar(
                    title: 'Look Nearly By Map',
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),

                // Loading / Error
                if (state.isLoading)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                if (!state.isLoading && state.error != null)
                  Positioned(
                    top: 90,
                    left: 16,
                    right: 16,
                    child: _ErrorBanner(
                      text: state.error!,
                      onRetry: () =>
                          context.read<MapBloc>().add(const MapStarted()),
                    ),
                  ),

                // Bottom area
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomInset, // ✅ يرفع فوق أزرار النظام
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      MapRadiusBadge(radiusKm: state.radiusKm),
                      const SizedBox(height: 8),
                      _RadiusChips(
                        selected: state.radiusKm,
                        onChanged: (v) =>
                            context.read<MapBloc>().add(MapRadiusChanged(v)),
                        primary: _primary,
                        secondary: _secondary,
                      ),
                      const SizedBox(height: 10),

                      if (state.spaces.isNotEmpty)
                        SizedBox(
                          height: 160, // ✅ ثابت ومناسب للكارد الجديد
                          child: PageView.builder(
                            controller: PageController(viewportFraction: 0.92),
                            itemCount: state.spaces.length,
                            onPageChanged: (index) {
                              final id = state.spaces[index].id;
                              context.read<MapBloc>().add(
                                MapMarkerTapped(id),
                              ); // ✅ تحديد تلقائي
                            },
                            itemBuilder: (context, index) {
                              final space = state.spaces[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: NearbySpaceBottomCard(
                                  space: space,
                                  onView: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SpaceDetailsPage.withBloc(
                                              spaceId: space.id,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 18,
                                offset: Offset(0, 8),
                                color: Color(0x22000000),
                              ),
                            ],
                          ),
                          child: const Text(
                            'لا توجد نتائج ضمن هذا النطاق.',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 2),
            color: Color(0x11000000),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 26),
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _RadiusChips extends StatelessWidget {
  final double selected;
  final ValueChanged<double> onChanged;
  final Color primary;
  final Color secondary;

  const _RadiusChips({
    required this.selected,
    required this.onChanged,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(double v) {
      final isSelected = (selected - v).abs() < 0.001;
      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onChanged(v),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? secondary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? secondary : const Color(0xFFE7E7E7),
            ),
          ),
          child: Text(
            '${v.toStringAsFixed(1)} Km',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          chip(0.5),
          const SizedBox(width: 10),
          chip(1.0),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Nearby',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.text, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(14),
      color: const Color(0xFFFFF3F3),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
