import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraState extends ChangeNotifier {
  CameraController _controller;
  CameraDescription _cameraDescription;
  bool _readyTakePhoto = false;

  void dispose() {
    if (_controller != null) _controller.dispose();
    _controller = null;
    _cameraDescription = null;
    _readyTakePhoto = false;
    notifyListeners();
  }

  //future 데이터를 받을때 async와 await를 같이 써야 한
  void getReadyToTakePhoto() async {
    //유저 스마트폰에 어떤 카메라들이 있는지 가져온다
    List<CameraDescription> cameras = await availableCameras();

    if (cameras != null && cameras.isNotEmpty) {
      print(cameras);
      print(cameras.isNotEmpty);
      setCameraDescription(cameras[0]);
    }

    bool init = false;
    while (!init) {
      init = await initailize();
    }
    _readyTakePhoto = true;
    //provider를 통해서 해당 데이터를 전달해 줄 때 리스너들에게 변화된 값을 전달한다
    notifyListeners();
  }

  void setCameraDescription(CameraDescription cameraDescription) {
    _cameraDescription = cameraDescription;
    _controller = CameraController(_cameraDescription, ResolutionPreset.medium);
  }

  Future<bool> initailize() async {
    try {
      await _controller.initialize();
      return true;
    } catch (e) {
      return false;
    }
  }

  // 안에있는 controller, description, isReadyToTakePhoto 를 바로접근해서
  // 건드리지 못하게 하기위해 private로 방어를 해놓고 데이터를 가지고 가서 사용만 할 수 있도록 한다
  CameraController get controller => _controller;

  CameraDescription get description => _cameraDescription;

  bool get isReadyToTakePhoto => _readyTakePhoto;
}
