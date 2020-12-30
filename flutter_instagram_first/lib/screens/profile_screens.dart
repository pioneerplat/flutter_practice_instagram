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
          children: [
            _appbar(),
            _username(),
          ],
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text('username', style: TextStyle(fontWeight: FontWeight.bold),),
    );
  }

  Row _appbar() {
    return Row(
            children: [
              //Text 가 중앙으로 가게하기 위해 SizedBox로 공간을 채워준다.
              SizedBox(
                width: 50,
              ),
              Expanded(child: Text('The Pioneerplat', textAlign: TextAlign.center,)),
              IconButton(
                icon: Icon(Icons.menu),
                //onPressed로 지정해 주면 아이콘이 검정색으로 변한다.
                onPressed: (){},
              )
            ],
          );
  }
}
