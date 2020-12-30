import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool seletedLeft = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      ////CustomScrollView - slivers를 사용하는 이유는 그리드뷰 스크롤뷰를 같은 뷰에넣어 스크롤이 같이되게 하기 위함
      child: CustomScrollView(
        slivers: <Widget>[
          //SliverList는 list인데 Sliver로 감싼 list이다
          SliverList(
            delegate: SliverChildListDelegate([
              _username(),
              _userBio(),
              _editProfileBtn(),
              _tabButtons(),
              _selectedIndicator(),
            ]),
          )
        ],
      ),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      alignment: seletedLeft?Alignment.centerLeft:Alignment.centerRight,
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      curve: Curves.fastOutSlowIn,
    );
  }

  Row _tabButtons() {
    return Row(
      //아이콘들이 같은 공간을 차지하도록 공간을 준다 - 이 방법을 안쓰고 두 아이콘에 Expanded를 주면 같은 효과
      //spaceAround 를사용하면 클릭할 수 있는 공간이 아이콘만큼이지만 Expanded를 사용하면 클릭공간을 더 늘릴수있다
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/images/grid.png'),
              // A ? B : C A가 true이면 B, false이면 C
              color: seletedLeft ? Colors.black : Colors.black26,
            ),
            onPressed: () {
              setState(() {
                seletedLeft = true;
              });
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/images/saved.png'),
              color: seletedLeft ? Colors.black26 : Colors.black,
            ),
            onPressed: () {
              setState(() {
                seletedLeft = false;
              });
            },
          ),
        ),
      ],
    );
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
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
}
