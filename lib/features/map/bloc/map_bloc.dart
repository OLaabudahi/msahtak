import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_current_location_usecase.dart';
import '../domain/usecases/get_nearby_spaces_usecase.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocationUseCase getCurrentLocation;
  final GetNearbySpacesUseCase getNearbySpaces;

  MapBloc({
    required this.getCurrentLocation,
    required this.getNearbySpaces,
  }) : super(MapState.initial()) {
    on<MapStarted>(_onStarted);
    on<MapRadiusChanged>(_onRadiusChanged);
    on<MapMarkerTapped>(_onMarkerTapped);
  }

  Future<void> _onStarted(MapStarted event, Emitter<MapState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final center = await getCurrentLocation();
      final spaces = await getNearbySpaces(center: center, radiusKm: state.radiusKm);
      emit(state.copyWith(
        isLoading: false,
        center: center,
        spaces: spaces,
        selectedSpaceId: spaces.isNotEmpty ? spaces.first.id : null,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onRadiusChanged(MapRadiusChanged event, Emitter<MapState> emit) async {
    final center = state.center;
    if (center == null) {
      emit(state.copyWith(radiusKm: event.radiusKm));
      add(const MapStarted());
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, radiusKm: event.radiusKm));
    try {
      final spaces = await getNearbySpaces(center: center, radiusKm: event.radiusKm);
      emit(state.copyWith(
        isLoading: false,
        spaces: spaces,
        selectedSpaceId: spaces.isNotEmpty ? spaces.first.id : null,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onMarkerTapped(MapMarkerTapped event, Emitter<MapState> emit) {
    emit(state.copyWith(selectedSpaceId: event.spaceId));
  }
}