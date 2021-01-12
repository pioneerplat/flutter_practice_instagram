import 'package:cloud_firestore/cloud_firestore.dart';

class UserNetworkRepository {
  Future<void> sendData() {
    return Firestore.instance
        .collection('Users')
        .document('123123123')
        .setData({'email': 'testing@gmail.com', 'username': 'myUserName'});
  }

  void getData() {
    Firestore.instance
        .collection('Users')
        .document('123123123')
        .get()
        .then((docSnaphsot) => print(docSnaphsot.data));
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
