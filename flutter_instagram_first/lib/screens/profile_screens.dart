import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _appbar(),
            //CustomScrollView - slivers를 사용하는 이유는 그리드뷰 스크롤뷰를 같은 뷰에넣어 스크롤이 같이 되도록 하기 위
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  //SliverList는 list인데 Sliver로 감싼 list이다
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _username(),
                      _userBio(),
                      _editProfileBtn(),
                    ]),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: null,
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Edit Profile',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'username',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        'this is what i believe!!',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  Row _appbar() {
    return Row(
      children: [
        //Text 가 중앙으로 가게하기 위해 SizedBox로 공간을 채워준다.
        SizedBox(
          width: 50,
        ),
        Expanded(
            child: Text(
          'The Pioneerplat',
          textAlign: TextAlign.center,
        )),
        IconButton(
          icon: Icon(Icons.menu),
          //onPressed로 지정해 주면 아이콘이 검정색으로 변한다.
          onPressed: () {},
        )
      ],
    );
  }
}
