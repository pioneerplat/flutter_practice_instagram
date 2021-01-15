import 'dart:io';
import 'package:image/image.dart'; //직접 손으로 import

File getResizedImage(File originImage) {
  //file을 바이트로 읽어와 이미지 오브젝트로 변환
  Image image = decodeImage(originImage.readAsBytesSync());

  //image를 주고 정사각형 가로세로 300 사이즈로 변환
  Image resizedImage = copyResizeCropSquare(image, 300);

  //png파일을 jpg로 바꾸기
  //이미지이름.png png가 3자리니까 0에서 시작해서 3자리만큼 빼고 가지고 와서 jpg를 붙여준다
  File resizedFile =
      File(originImage.path.substring(0, originImage.path.length - 3) + "jgp");

  //resized 이미지를 jpg로 인코딩해 준다 (이미지, 퀄리티50프로로 줄이기)
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50));

  return resizedFile;
}
