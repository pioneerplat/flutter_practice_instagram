import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_instagram_first/repo/helper/image_helper.dart';

class ImageNetworkRepository {
  Future<StorageTaskSnapshot> uploadImage(File originImage, {@required String postKey}) async {
    try {
      final File resized = await compute(getResizedImage, originImage);
      //postKey를 받아와서 reference를 형성을 한다
      final StorageReference storageReference =
      FirebaseStorage().ref().child(_getImagePathByPostKey(postKey));
      //업로드
      final StorageUploadTask uploadTask = storageReference.putFile(resized);
      //uploadTask를 다 마치면 StorageTaskSnapshot을 리턴한다
      return uploadTask.onComplete;
    } catch (e) {
      print(e);
      return null;
    }
      /*
    originImage.length().then((value) => print('original image size: $value'));
    resized.length().then((value) => print('resized image size: $value'));
    //3초 딜레이
    await Future.delayed(Duration(seconds: 3));
     */

  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';

  //다운로드
  Future<dynamic> getPostImageUrl(String postKey){
    return FirebaseStorage().ref().child(_getImagePathByPostKey(postKey)).getDownloadURL();
  }
}

ImageNetworkRepository imageNetworkRepository = ImageNetworkRepository();