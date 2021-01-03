import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/constants/screen_size.dart';
import 'package:flutter_instagram_first/screens/profile_screens.dart';
import 'package:flutter_instagram_first/widgets/rounded_avatar.dart';

class ProfileBody extends StatefulWidget {
  final Function onMenuChanged;

  const ProfileBody({Key key, this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}
// SingleTickerProviderStateMixin 클래스는 애니메이션을 처리하기 위한 헬퍼 클래스
// 상속에 포함시키지 않으면 컨트롤러를 생성할 수 없다.
// mixin은 다중 상속에서 코드를 재사용하기 위한 한 가지 방법으로 with 키워드와 함께 사용
//extends는 상속을 하는 거라면 with 는 자체를 가져와서 사용하는 것
class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagePageMargin = size.width;
  AnimationController _iconAnimationController;

  //해당 State가 새로 생성되었을때 initState가 실행
  //Controller는 initState에서 생성해줘야 하는가?
  @override
  void initState() {
    //this는 _ProfileBodyState 클래스의 인스턴스를 의미함
    // SingleTickerProviderStateMixin를 상속 받아서
    // vsync에 this 형태로 전달해야 애니메이션이 정상 처리된다.
    _iconAnimationController =
        AnimationController(vsync: this, duration: duration);
    super.initState();
  }

  //해당 State가 버려질때 dispose가 실행
  @override
  void dispose() {
    //dispose해줘야 메모리 누수(memory leak)을 해결할 수 있다.
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appbar(),
          Expanded(
            ////CustomScrollView - slivers를 사용하는 이유는 그리드뷰 스크롤뷰를 같은 뷰에넣어 스크롤이 같이되게 하기 위함
            child: CustomScrollView(
              slivers: <Widget>[
                //SliverList는 list인데 Sliver로 감싼 list이다
                //SliverList뷰
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: RoundedAvatar(
                            size: 80,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: common_gap),
                            child: Table(
                              children: [
                                TableRow(children: [
                                  _valueText('123123'),
                                  _valueText('33'),
                                  _valueText('44'),
                                ]),
                                TableRow(children: [
                                  _labelText('Post'),
                                  _labelText('Followers'),
                                  _labelText('Following'),
                                ])
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    _username(),
                    _userBio(),
                    _editProfileBtn(),
                    _tabButtons(),
                    _selectedIndicator(),
                  ]),
                ),

                imagesPager()
              ],
            ),
          ),
        ],
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
          icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _iconAnimationController),
          //onPressed로 지정해 주면 아이콘이 검정색으로 변한다.
          onPressed: () {
            // StatefulWidget 해당 위젯의 값에 접근하고 싶으면 widget.값 하면 된다
            widget.onMenuChanged();
            // completed:끝지점, dismissed:시작지점, forward:시작에서 끝으로 가는 중간, reverse: 끝에서 시작으로 가는 중간
            _iconAnimationController.status == AnimationStatus.completed
                ? _iconAnimationController.reverse()
                : _iconAnimationController.forward();
          },
        )
      ],
    );
  }

  Text _valueText(String value) => Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      );

  Text _labelText(String label) => Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 11),
      );

  SliverToBoxAdapter imagesPager() {
    //일반적인 뷰를 Sliver처럼 사용하려면 SliverToBoxAdapter로 감싸줘야 한다.
    //SliverGrid를 사용하면 SliverToBoxAdapter로 감싸지 않아도 된다.
    return SliverToBoxAdapter(
      child: Stack(children: [
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
        AnimatedContainer(
          duration: duration,
          transform: Matrix4.translationValues(_rightImagePageMargin, 0, 0),
          curve: Curves.fastOutSlowIn,
          child: _images(),
        ),
      ]),
    );
  }

  GridView _images() {
    return GridView.count(
      //스크롤 뷰 안에 스크롤뷰가 있는 상태라서 안에 있는 GridView는 스크롤을 받지 않겠다는 코드
      physics: NeverScrollableScrollPhysics(),
      //shrinkWrap:true로 주면 그리드뷰가 유효한 만큼만 자리를 차지한다.
      shrinkWrap: true,
      //Grid뷰 3칸 사용
      crossAxisCount: 3,
      //가로 세로 비율
      childAspectRatio: 1,
      children: List.generate(
          30,
          (index) => CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "https://picsum.photos/id/$index/200/200",
              )),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      duration: duration,
      // 가독성을 위해 true false로 하지않고 열거형을 이용해 left , right 로 사용
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
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
              color: _selectedTab == SelectedTab.left
                  ? Colors.black
                  : Colors.black26,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.left);
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: ImageIcon(
              AssetImage('assets/images/saved.png'),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black26
                  : Colors.black,
            ),
            onPressed: () {
              _tabSelected(SelectedTab.right);
            },
          ),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagePageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagePageMargin = 0;
          break;
      }
    });
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

enum SelectedTab { left, right }
