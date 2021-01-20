import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

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
            if (snapshot.hasData) {
              return SafeArea(
                child: Consumer<UserModelState>(
                  builder: (BuildContext context,
                      UserModelState myUserModelState, Widget child) {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          // 다른 유저
                          UserModel otherUser = snapshot.data[index];
                          bool amIFollowing = myUserModelState
                              .amIFollowingThisUser(otherUser.userKey);
                          return ListTile(
                            onTap: () {
                              setState(() {
                                //  followings[index] = !followings[index];
                                amIFollowing
                                    ? userNetworkRepository.unfollowUser(
                                        myUserKey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey)
                                    : userNetworkRepository.followUser(
                                        myUserKey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey);
                              });
                            },
                            //leading ListTile에서 왼쪽에 있는 것
                            leading: RoundedAvatar(),
                            title: Text(otherUser.username),
                            subtitle: Text(
                                'this is user bio of ${otherUser.username}'),
                            trailing: Container(
                              height: 30,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: amIFollowing
                                    ? Colors.blue[50]
                                    : Colors.red[50],
                                border: Border.all(
                                    color:
                                        amIFollowing ? Colors.blue : Colors.red,
                                    width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // FittedBox 가용범위 안에서 사이즈를 알아서 조절한다
                              child: FittedBox(
                                child: Text(
                                  amIFollowing ? 'following' : 'not follow',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                          );
                        },
                        itemCount: snapshot.data.length);
                  },
                ),
              );
            } else {
              return MyProgressIndicator();
            }
          }),
    );
  }
}
