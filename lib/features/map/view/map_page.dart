import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../core/i18n/app_i18n.dart';
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
      locationService: GeolocatorLocationService(),
      dataSource: FirebaseNearbySpacesDataSource(),
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
  static const _primary = AppColors.primary;
  static const _secondary = AppColors.dotInactive;

  final MapController _mapController = MapController();
  final PageController _pageController = PageController(viewportFraction: 0.92);
  bool _mapReady = false;
  double _currentZoom = 14.2;
  LatLng? _pendingMove;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveTo(LatLng target) {
    if (!_mapReady) {
      _pendingMove = target;
      return;
    }
    _mapController.move(target, _currentZoom);
  }

  void _scrollToSpace(List spaces, String? selectedId) {
    if (spaces.isEmpty || selectedId == null) return;
    final index = spaces.indexWhere((s) => s.id == selectedId);
    if (index < 0) return;
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  double _zoomForRadius(double radiusKm) {
    if (radiusKm <= 0.1) return 17.0;
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
            _scrollToSpace(state.spaces, state.selectedSpaceId);
          },
          builder: (context, state) {
            final center = state.center;

            return Stack(
              children: [
                
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

                              
                              if (_pendingMove != null) {
                                _mapController.move(
                                  _pendingMove!,
                                  _currentZoom,
                                );
                                _pendingMove = null;
                              }
                            },

                            onPositionChanged: (pos, _) {
                              
                              final z = pos.zoom;
                              if (z != null) _currentZoom = z;
                            },
                          ),
                          children: [
                            
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.masahtak_app', 
                            ),

                            
                            CircleLayer(
                              circles: [
                                CircleMarker(
                                  point: LatLng(center.lat, center.lng),
                                  radius: state.radiusKm * 1000.0,
                                  
                                  useRadiusInMeter: true,
                                  color: _secondary.withOpacity(0.22),
                                  borderStrokeWidth: 0,
                                ),
                              ],
                            ),

                            
                            MarkerLayer(
                              markers: [
                                
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

                
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,

                  child: _TopBar(
                    title: context.t('mapTitle'),
                    onBack: () => Navigator.of(context).pop(),
                  ),
                ),

                
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

                
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomInset, 
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      if (!state.showAll) MapRadiusBadge(radiusKm: state.radiusKm),
                      const SizedBox(height: 8),
                      _RadiusChips(
                        selected: state.radiusKm,
                        showAll: state.showAll,
                        onChanged: (v) =>
                            context.read<MapBloc>().add(MapRadiusChanged(v)),
                        onShowAll: () =>
                            context.read<MapBloc>().add(const MapShowAllToggled()),
                        primary: _primary,
                        secondary: _secondary,
                      ),
                      const SizedBox(height: 10),

                      if (state.spaces.isNotEmpty)
                        SizedBox(
                          height: 160, 
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: state.spaces.length,
                            onPageChanged: (index) {
                              final id = state.spaces[index].id;
                              context.read<MapBloc>().add(
                                MapMarkerTapped(id),
                              ); 
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
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                                color: AppColors.shadowLight,
                              ),
                            ],
                          ),
                          child: Text(
                            context.t('mapNoResults'),
                            style: const TextStyle(fontWeight: FontWeight.w700),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 2),
            color: AppColors.shadowLight,
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
  final bool showAll;
  final ValueChanged<double> onChanged;
  final VoidCallback onShowAll;
  final Color primary;
  final Color secondary;

  const _RadiusChips({
    required this.selected,
    required this.showAll,
    required this.onChanged,
    required this.onShowAll,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    Widget chip(double v) {
      final isSelected = !showAll && (selected - v).abs() < 0.001;
      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onChanged(v),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? secondary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? secondary : AppColors.borderLight,
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
          chip(0.1),
          const SizedBox(width: 10),
          chip(0.5),
          const SizedBox(width: 10),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onShowAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: showAll ? primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: showAll ? primary : AppColors.borderLight,
                ),
              ),
              child: Text(
                context.t('mapShowAll'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: showAll ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              context.t('mapNearby'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
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
      color: AppColors.rejectedBg,
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
