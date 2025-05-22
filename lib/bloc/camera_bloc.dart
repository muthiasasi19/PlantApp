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
  