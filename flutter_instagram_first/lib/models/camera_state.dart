import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier{
  CameraController _controller;
  CameraDescription _cameraDescription;
  bool _readyTakePhoto = false;

}