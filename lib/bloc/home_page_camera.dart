
import 'dart:io';
import 'camera_page.dart';
import 'package:plant_app/bloc/camera_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Foto Profil")),
      body: SafeArea(
        child: BlocConsumer<CameraBloc, CameraState>(
          listener: (context, state) {
            if (state is CameraReady && state.snackbarMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.snackbarMessage!)));
              context.read<CameraBloc>().add(ClearSnackbar());
            }
          },
          builder: (context, state) {
            final imageFile = state is CameraReady ? state.imageFile : null;

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          imageFile != null ? FileImage(imageFile) : null,
                      child:
                          imageFile == null
                              ? const Icon(Icons.person, size: 70)
                              : null,
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.folder),
                          label: const Text('Pilih dari Galeri'),
                          onPressed: () async {
                            context.read<CameraBloc>().add(
                              PickImageFromGallery(),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                            final file =
                                context.read<CameraBloc>().state is CameraReady
                                    ? (context.read<CameraBloc>().state
                                            as CameraReady)
                                        .imageFile
                                    : null;
                            if (file != null) Navigator.pop(context, file);
                          },
                        ),
                       
}

