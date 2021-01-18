import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';

class Transformers{

  final toUser = StreamTransformer<DocumentSnapshot, UserModel>.fromHandlers(
    handleData: (snapshot, sink) async{
      sink.add(UserModel.fromSnapshot(snapshot));
    }
  );
  final toUsersExceptMe = StreamTransformer<QuerySnapshot, List<UserModel>>.fromHandlers(
    handleData: (snapshot, sink) async{
      int a = 1;

      List<UserModel> users = [];
      // 현재 유저(나)
      FirebaseUser _firebaseUser = await FirebaseAuth.instance.currentUser();
      snapshot.documents.forEach((documentSnapshot) {
        //내 아이디를 제외한 유저들을 가지고 오기 위해

        if(_firebaseUser.uid != documentSnapshot.documentID) {
          //UserModel로 변경해서 list로 넣어준다
          a = a + 1;
          users.add(UserModel.fromSnapshot(documentSnapshot));
        }
      });
      //QuerySnapshot이 도착할 때마다 유저리스트를 생성해서 싱크대를 통해서 나가게 되어있다.
      print(a);
      sink.add(users);
    }
  );
}