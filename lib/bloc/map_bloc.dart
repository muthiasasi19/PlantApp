import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapLoading()) {
    on<MapLoadStarted>(_onLoad);
    on<MapLocationPicked>(_onPick);
    on<MapClearPicked>(_onClear);
  }

  Future<void> _onLoad(MapLoadStarted event, Emitter<MapState> emit) async {
    try {
      final pos = await _getLocationPermission();
      final placemark = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final address = _formatPlacemark(placemark.first);
      emit(MapLoaded(currentPosition: pos, currentAddress: address));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  Future<void> _onPick(MapLocationPicked event, Emitter<MapState> emit) async {
    if (state is MapLoaded) {
      try {
        final placemark = await placemarkFromCoordinates(
          event.latLng.latitude,
          event.latLng.longitude,
        );
        final address = _formatPlacemark(placemark.first);
        emit(
          (state as MapLoaded).copyWith(
            pickedLatLng: event.latLng,
            pickedAddress: address,
          ),
        );
      } catch (e) {
        emit(MapError(e.toString()));
      }
    }
  }

  void _onClear(MapClearPicked event, Emitter<MapState> emit) {
    if (state is MapLoaded) {
      emit(
        (state as MapLoaded).copyWith(pickedLatLng: null, pickedAddress: null),
      );
    }
  }

  Future<Position> _getLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Layanan lokasi tidak aktif';
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Izin lokasi ditolak';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }
    return await Geolocator.getCurrentPosition();
  }

  String _formatPlacemark(Placemark p) =>
      '${p.name}, ${p.street}, ${p.locality}, ${p.country}, ${p.postalCode}';
}
