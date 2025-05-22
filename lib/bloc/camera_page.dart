import 'package:camera/camera.dart';
import 'package:plant_app/bloc/camera_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<CameraBloc>();
    bloc.add(RequestPermissions());
    //bloc.add(InitializeCamera());
  }

  IconData _flasIcon(FlashMode mode) {
    return switch (mode) {
      FlashMode.auto => Icons.flash_auto,
      FlashMode.always => Icons.flash_on,
      _ => Icons.flash_off,
    };
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return ClipOval(
      child: Material(
        color: Colors.white24,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraReady && state.snackbarMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.snackbarMessage!)));
            context.read<CameraBloc>().add(ClearSnackbar());
          }
        },
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            if (state is! CameraReady) {
              return const Center(child: CircularProgressIndicator());
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTapDown: (details) {
                        context.read<CameraBloc>().add(
                          TapToFocus(
                            details.localPosition,
                            constraints.biggest,
                          ),
                        );
                      },
                      child: CameraPreview(state.controller),
                    ),
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Column(
                        children: [
                          _circleButton(Icons.flip_camera_android, () {
                            context.read<CameraBloc>().add(SwitchCamera());
                          }),
                          const SizedBox(height: 12),
                          _circleButton(_flasIcon(state.flashMode), () {
                            context.read<CameraBloc>().add(ToggleFlash());
                          }),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            context.read<CameraBloc>().add(
                              TakePicture((file) {
                                // update BLoC langsung juga
                                context.read<CameraBloc>().add(
                                  UpdateImageFile(file),
                                );
                                Navigator.pop(context, file);
                              }),
                            );
                          },

                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
