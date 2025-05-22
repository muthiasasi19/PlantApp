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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapLoaded &&
          currentPosition == other.currentPosition &&
          currentAddress == other.currentAddress &&
          pickedLatLng == other.pickedLatLng &&
          pickedAddress == other.pickedAddress;

  @override
  int get hashCode =>
      currentPosition.hashCode ^
      currentAddress.hashCode ^
      pickedLatLng.hashCode ^
      pickedAddress.hashCode;
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MapError && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
