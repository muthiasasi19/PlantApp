import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/bloc/camera_page.dart';
import 'package:plant_app/bloc/storage/Storage_Helper.dart'; // buat simpan foto, sesuaikan pathnya

part 'camera_event.dart';
part 'camera_state.dart';

class UpdateImageFile extends CameraEvent {
  final File file;
  UpdateImageFile(this.file);
}

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  late final List<CameraDescription> _cameras;

  CameraBloc() : super(CameraInitial()) {
    on<InitializeCamera>(_onInit);
    
    });

    

  Future<void> _onInit(
    InitializeCamera event,
    Emitter<CameraState> emit,
  ) async {
    _cameras = await availableCameras();
    await _setupController(0, emit);
  }

  Future<void> _onSwitch(SwitchCamera event, Emitter<CameraState> emit) async {
    if (state is! CameraReady) return;
    final s = state as CameraReady;
    final next = (s.selectedIndex + 1) % _cameras.length;
    await _setupController(next, emit, previous: s);
  }
Future<void> _onTakePicture(
  TakePicture event,
  Emitter<CameraState> emit,
) async {
  if (state is! CameraReady) return;
  final s = state as CameraReady;

  if (!s.controller.value.isInitialized) {
    emit(s.copyWith(snackbarMessage: "Kamera belum siap"));
    return;
  }

  try {
    final file = await s.controller.takePicture();
    event.onPictureTaken(File(file.path));
  } catch (e) {
    emit(s.copyWith(snackbarMessage: "Gagal mengambil gambar: $e"));
  }
}

 Future<void> _onPickGallery(
  PickImageFromGallery event,
  Emitter<CameraState> emit,
) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked == null) return;
  final file = File(picked.path);
  emit(
    (state as CameraReady).copyWith(
      imageFile: file,
      snackbarMessage: 'Berhasil memilih dari galeri',
    ),
  );
}

on<SaveImageAsProfile>((event, emit) async {
  if (state is! CameraReady) return;

  final current = state as CameraReady;
  final imageFile = current.imageFile;
  if (imageFile == null) return;

  try {
    final savedFile = await StorageHelper.saveImage(imageFile, 'profile_');

    emit(
      current.copyWith(
        imageFile: savedFile,
        snackbarMessage: 'Foto profil berhasil disimpan!',
      ),
    );
  } catch (e) {
    emit(current.copyWith(snackbarMessage: 'Gagal menyimpan foto: $e'));
  }
});


  Future<void> _onDeleteImage(
  DeleteImage event,
  Emitter<CameraState> emit,
) async {
  if (state is! CameraReady) return;
  final s = state as CameraReady;
  await s.imageFile?.delete();
  emit(
    CameraReady(
      controller: s.controller,
      selectedIndex: s.selectedIndex,
      flashMode: s.flashMode,
      imageFile: null,
      snackbarMessage: 'Gambar dihapus',
    ),
  );
}


  

 
 

  Future<void> _setupController(
    int index,
    Emitter<CameraState> emit, {
    CameraReady? previous,
  }) async {
    await previous?.controller.dispose();
    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.max,
      enableAudio: false,
    );
    await controller.initialize();
    await controller.setFlashMode(previous?.flashMode ?? FlashMode.off);

    emit(
      CameraReady(
        controller: controller,
        selectedIndex: index,
        flashMode: previous?.flashMode ?? FlashMode.off,
        imageFile: previous?.imageFile,
        snackbarMessage: null,
      ),
    );
  }
