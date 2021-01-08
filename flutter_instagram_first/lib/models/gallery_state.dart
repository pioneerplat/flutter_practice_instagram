import 'package:flutter/foundation.dart';
import 'package:local_image_provider/local_image.dart';
import 'package:local_image_provider/local_image_provider.dart';

class GalleryState extends ChangeNotifier{
  LocalImageProvider _localImageProvider;
  bool _hasPermission;
  List<LocalImage> _images;

  Future<bool> initProvider() async {
    _localImageProvider = LocalImageProvider();
    _hasPermission = await _localImageProvider.initialize();
    if(_hasPermission){

      //디바이스에서 30개의 이미지를 가지고온다
      _images = await _localImageProvider.findLatest(30);

      //GalleryState 를 살펴보고 있는 위젯들 한테 이미지들 준부됐으니까 알아서 디스플레이 바꿔죠 하고 요청
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  List<LocalImage> get images => _images;
  LocalImageProvider get localImageProvider => _localImageProvider;
}

