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

  @override
  void dispose() {
    _emailController.dispose();
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
              decoration: InputDecoration(
                hintText: 'Email',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey[300],
                    ),
                    borderRadius: BorderRadius.circular(common_s_gap)),
                //필드 색지정
                filled: true,
                fillColor: Colors.grey[100],
              ),

              validator: (text){
                if(text.isNotEmpty && text.contains("@")){
                  return null;
                }else{
                  return '정확한 이메일을 주소를 입력해주세요~';
                }
              },
            ),
            TextFormField(),
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
