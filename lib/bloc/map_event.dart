part of 'map_bloc.dart';

abstract class MapEvent {
  const MapEvent();
}

class MapLoadStarted extends MapEvent {
  const MapLoadStarted();
}

class MapLocationPicked extends MapEvent {
  final LatLng latLng;

  const MapLocationPicked(this.latLng);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapLocationPicked && latLng == other.latLng;

  @override
  int get hashCode => latLng.hashCode;
}

class MapClearPicked extends MapEvent {
  const MapClearPicked();
}
