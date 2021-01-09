import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/auth_input_decor.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/home_page.dart';
import 'package:flutter_instagram_first/models/firebase_auth_state.dart';
import 'package:flutter_instagram_first/widgets/or_divider.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  //formkey란 form위젯의 상태를 저장하는 key
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //TextFormField 위젯을 사용할 때 필요한 것
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //입력창이 밑쪽에 있어 키보드에 가려지는걸 방지하기 위해 키보드 위로 올라오도록 리사이징 한다
      //resizeToAvoidBottomInset기능을 쓰기위해 Scaffold로 감싸줌
      resizeToAvoidBottomInset: true,
      body: Padding(
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
                decoration: textInputDecor('Email'),
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
                decoration: textInputDecor('Password'),
                validator: (text) {
                  if (text.isNotEmpty && text.length > 1) {
                    return null;
                  } else {
                    return '제대로 된 비밀번호를 입력해 주세요.';
                  }
                },
              ),

              FlatButton(
                onPressed: () {},
                // 부모클래스에 Align 위젯이 없을때 사용할 수 있다
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Forgotten Password?',
                      style: TextStyle(color: Colors.blue)),
                ),
              ),

              SizedBox(
                height: common_s_gap,
              ),

              //Sign in FlatButton
              _submitButton(context),
              SizedBox(
                height: common_s_gap,
              ),
              OrDivider(),
              //ImageIcon 나의 Image를 이용하여 아이콘을 만듬
              FlatButton.icon(
                  onPressed: () {
                    //클릭으로 바꿔줄게 없기 때문에 listen: false
                    Provider.of<FirebaseAuthState>(context, listen: false)
                        .changeFirebaseAuthStatus(FirebaseAuthStatus.signin);
                  },
                  //textColor에 Icon과 Text 모두 포함
                  textColor: Colors.blue,
                  icon: ImageIcon(AssetImage('assets/images/facebook.png')),
                  label: Text("Login with Facebook")),
            ],
          ),
        ),
      ),
    );
  }

  FlatButton _submitButton(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: () {
        // 위 3개의 validator 가 전부 null을 반환하면 true가 오고 그렇지 않으면 false가 온다
        if (_formkey.currentState.validate()) {
          print('Validation success!!');

          //클릭으로 바꿔줄게 없기 때문에 listen: false
          Provider.of<FirebaseAuthState>(context, listen: false)
              .changeFirebaseAuthStatus(FirebaseAuthStatus.signin);
        }
      },
      child: Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}
