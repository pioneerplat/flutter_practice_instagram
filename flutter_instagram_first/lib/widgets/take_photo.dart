import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/models/camera_state.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  //CameraController _controller;
  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    //카메라 정보들을 List로해서 가지고 온다 (요즘은 카메라가 2개 3개씩있다)
    //return FutureBuilder<List<CameraDescription>>(
    //future: availableCameras(),
    //builder: (context, snapshot) {
    return Consumer<CameraState>(
      builder: (BuildContext context, CameraState cameraState, Widget child) {
        return Column(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.width,
              color: Colors.black,
              child:
                  //(snapshot.hasData) ? _getPreview(snapshot.data) : _progress,
                  (cameraState.isReadyToTakePhoto)
                      ? _getPreview(cameraState)
                      : _progress,
            ),
            Expanded(
              //컨테이너 전체가 버튼
              //InkWell로 감싸고 onTap을 넣어주면 버튼이 된다
              // child: InkWell(
              //   onTap: (){},
              //   child: Padding(
              //     padding: const EdgeInsets.all(common_s_gap),
              //     child: Container(
              //       decoration: ShapeDecoration(
              //           shape: CircleBorder(side: BorderSide(color: Colors.black12,width: 20))),
              //     ),
              //   ),
              // ),

              //shape만 버튼
              child: OutlineButton(
                onPressed: () {},
                shape: CircleBorder(),
                borderSide: BorderSide(color: Colors.black12, width: 20),
              ),
            ),
          ],
        );
      },
    );
    //});
  }

  Widget _getPreview(CameraState cameraState) {
    //첫번째 카메라를 가져와서 , ResolutionPreset : 화질
    //_controller = CameraController(cameras[0], ResolutionPreset.medium);
    //커멘드 클릭으로 들어가보면 이것도 future 타입 : 시간이 걸린다는 소리
    //return FutureBuilder(
    //future: _controller.initialize(), //initialize은  void이기때문에 넘어오는 값이 없다
    //builder: (context, snapshot) {
    //해당 snapshot이 올때까지 기다려준다
    //ConnectionState.done이 되면 initialize가 끝난걸 알 수 있다
    //if (snapshot.connectionState == ConnectionState.done) {

    //3. 마지막으로 ClipRect위젯으로 감싸서 OverflowBox로인해 화면바깥으로 나간 화면은 잘준다
    return ClipRect(
        //1.OverflowBox : 해당 child위젯이 부모 위젯의 사이즈 밖으로 나갈 수 있도록 하는 위젯
        child: OverflowBox(
      alignment: Alignment.center,
      //2.FittedBox를 이용해 가로길이에 맞춰 화면을 주었다. 대신 OverflowBox로 늘어난 화면은 화면바깥으로 남아있다
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Container(
          width: size.width,
          //가로길이를 카메라의 원래 비율로 나누어준다
          height: size.width / cameraState.controller.value.aspectRatio,
          child: CameraPreview(
            cameraState.controller,
          ),
        ),
      ),
    ));
    //} else {
    //  return _progress;
    //}
// });
  }
}
