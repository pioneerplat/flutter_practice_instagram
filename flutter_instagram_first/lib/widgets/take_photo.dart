import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/widgets/my_progress_indicator.dart';

class TakePhoto extends StatefulWidget {
  const TakePhoto({
    Key key,
  }) : super(key: key);

  @override
  _TakePhotoState createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  CameraController _controller;
  Widget _progress = MyProgressIndicator();

  @override
  Widget build(BuildContext context) {
    //카메라 정보들을 List로해서 가지고 온다 (요즘은 카메라가 2개 3개씩있다)
    return FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.width,
                color: Colors.black,
                child: (snapshot.hasData) ? _getPreview(snapshot.data) : _progress,
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
        });
  }

  Widget _getPreview(List<CameraDescription> cameras) {
    //첫번째 카메라를 가져와서 , ResolutionPreset : 화질
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    //커멘드 클릭으로 들어가보면 이것도 future 타입 : 시간이 걸린다는 소리
    return FutureBuilder(
        future: _controller.initialize(), //initialize은  void이기때문에 넘어오는 값이 없다
        builder: (context, snapshot) {
          //해당 snapshot이 올때까지 기다려준다
          //ConnectionState.done이 되면 initialize가 끝난걸 알 수 있다
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return _progress;
          }
        });
  }
}
