import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/widgets/rounded_avatar.dart';

import '../models/firestore/user_model.dart';
import '../repo/user_network_repository.dart';
import '../widgets/my_progress_indicator.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  //List<bool> followings = List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follow/Unfollow'),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: userNetworkRepository.getAllUsersWithoutMe(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return SafeArea(

              child: ListView.separated(
                  itemBuilder: (context, index) {
                    UserModel userModel = snapshot.data[index];
                    return ListTile(
                      onTap: () {
                        setState(() {
                        //  followings[index] = !followings[index];
                        });
                      },
                      //leading ListTile에서 왼쪽에 있는 것
                      leading: RoundedAvatar(),
                      title: Text(userModel.username),
                      subtitle: Text('this is user bio of ${userModel.username}'),
                      trailing: Container(
                        height: 30,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(color: Colors.blue, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'following',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemCount: snapshot.data.length),
            );
          } else {
            return MyProgressIndicator();
          }
        }
      ),
    );
  }
}
