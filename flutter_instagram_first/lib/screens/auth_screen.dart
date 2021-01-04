import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/screens/profile_screens.dart';
import 'package:flutter_instagram_first/widgets/fade_stack.dart';
import 'package:flutter_instagram_first/widgets/sign_in_form.dart';
import 'package:flutter_instagram_first/widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

//한가지 애니메이션을 사용할때 SingleTickerProviderStateMixin 사용한다.
class _AuthScreenState extends State<AuthScreen> {


  int selectedForm = 0;






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            FadeStack(
              selectedForm: selectedForm,
            ),
            Container(
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    //if( <instance> is <class>){} 타입비교
                    if (selectedForm == 0) {
                      selectedForm = 1;
                    } else {
                      selectedForm = 0;
                    }
                  });

                },
                child: Text('go to Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
