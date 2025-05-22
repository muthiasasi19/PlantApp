part of 'map_bloc.dart';

abstract class MapState {
  const MapState();
}

class MapLoading extends MapState {
  const MapLoading();
}

class MapLoaded extends MapState {
  final Position currentPosition;
  final String currentAddress;
  final LatLng? pickedLatLng;
  final String? pickedAddress;

  const MapLoaded({
    required this.currentPosition,
    required this.currentAddress,
    this.pickedLatLng,
    this.pickedAddress,
  });

  MapLoaded copyWith({LatLng? pickedLatLng, String? pickedAddress}) {
    return MapLoaded(
      currentPosition: currentPosition,
      currentAddress: currentAddress,
      pickedLatLng: pickedLatLng,
      pickedAddress: pickedAddress,
    );
  }
}
