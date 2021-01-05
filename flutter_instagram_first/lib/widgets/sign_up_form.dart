import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  //formkey란 form위젯의 상태를 저장하는 key
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //TextFormField 위젯을 사용할 때 필요한 것
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  TextEditingController _cpwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    _cpwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(common_gap),
      child: Form(
        //스크롤이 가능한 ListView를 넣어줌
        key: _formkey,
        child: ListView(
          children: [
            SizedBox(
              height: common_l_gap,
            ),
            Image.asset('assets/images/insta_text_logo.png'),
            TextFormField(
              controller: _emailController,
              cursorColor: Colors.black54,
              decoration: _textInputDecor('Email'),
              validator: (text) {
                if (text.isNotEmpty && text.contains("@")) {
                  return null;
                } else {
                  return '정확한 이메일을 주소를 입력해주세요.';
                }
              },
            ),
            SizedBox(height: common_xs_gap),
            TextFormField(
              controller: _pwController,
              cursorColor: Colors.black54,
              //비밀번호 암호화
              obscureText: true,
              decoration: _textInputDecor('Password'),
              validator: (text) {
                if (text.isNotEmpty && text.length > 5) {
                  return null;
                } else {
                  return '제대로 된 비밀번호를 입력해 주세요.';
                }
              },
            ),
            SizedBox(height: common_xs_gap),
            TextFormField(
              controller: _cpwController,
              cursorColor: Colors.black54,
              decoration: _textInputDecor('Confirm Password'),
              validator: (text) {
                if (text.isNotEmpty && _pwController.text == text) {
                  return null;
                } else {
                  return '입력한 값이 비밀번호와 일치하지 않습니다.';
                }
              },
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                // 위 3개의 validator 가 전부 null을 반환하면 true가 오고 그렇지 않으면 false가 온다
                if (_formkey.currentState.validate()) {
                  print('Validation success!!');
                }
              },
              child: Text(
                'Join',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _textInputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300],
          ),
          borderRadius: BorderRadius.circular(common_s_gap)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(common_s_gap)),

      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
          borderRadius: BorderRadius.circular(common_s_gap)),
      //필드 색지정
      filled: true,
      fillColor: Colors.grey[100],
    );
  }
}
