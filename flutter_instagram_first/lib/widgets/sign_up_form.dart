import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  //formkey란 form위젯의 상태를 저장하는 key
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      //스크롤이 가능한 ListView를 넣어줌
      key: _formkey,
      child: ListView(
        children: [
          TextFormField(

          ),
          TextFormField(

          ),
          TextFormField(

          ),
        ],
      ),
    );
  }
}
