import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/map_bloc.dart';
import 'dart:async';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc()..add(MapLoadStarted()),
      child: const MapView(),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        if (state is MapLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is MapError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else if (state is MapLoaded) {
          final controller = Completer<GoogleMapController>();
          return Scaffold(
            appBar: AppBar(title: const Text("Pilih Alamat")),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.currentPosition.latitude,
                      state.currentPosition.longitude,
                    ),
                    zoom: 12,
                  ),
                  myLocationEnabled: true,
                  onMapCreated: (c) => controller.complete(c),
                  onTap: (latlng) {
                    context.read<MapBloc>().add(MapLocationPicked(latlng));
                  },
                  markers:
                      state.pickedLatLng != null
                          ? {
                            Marker(
                              markerId: const MarkerId('picked'),
                              position: state.pickedLatLng!,
                              infoWindow: InfoWindow(title: 'Dipilih'),
                            ),
                          }
                          : {},
                ),
                Positioned(
                  top: 25,
                  left: 50,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(state.currentAddress),
                  ),
                ),
                if (state.pickedAddress != null)
                  Positioned(
                    bottom: 120,
                    left: 16,
                    right: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(state.pickedAddress!),
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (state.pickedAddress != null)
                  FloatingActionButton.extended(
                    label: const Text("Pilih Alamat"),
                    onPressed: () {
                      Navigator.pop(context, state.pickedAddress);
                    },
                  ),
                const SizedBox(height: 8),
                if (state.pickedAddress != null)
                  FloatingActionButton.extended(
                    label: const Text("Hapus"),
                    onPressed: () {
                      context.read<MapBloc>().add(MapClearPicked());
                    },
                  ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
