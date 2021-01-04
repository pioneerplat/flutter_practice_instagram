import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/widgets/sign_in_form.dart';
import 'package:flutter_instagram_first/widgets/sign_up_form.dart';

class FadeStack extends StatefulWidget {
  final int selectedForm;

  const FadeStack({Key key, this.selectedForm}) : super(key: key);

  @override
  _FadeStackState createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  List<Widget> forms = [SignUpForm(), SignInForm()];

  @override
  void initState() {
    //this 는 SingleTickerProviderStateMixin 을 의미
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.forward();
    super.initState();
  }

  @override
  //AuthScreen의 oldWidget을 던져줘서 현재 Widget이랑 비교함
  void didUpdateWidget(covariant FadeStack oldWidget) {
    if (widget.selectedForm != oldWidget.selectedForm) {
      //FadeTransition을 사용을 하라는 의미 (애니메이션을 시작해라)
      _animationController.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: IndexedStack(
        //위에 final로 선언된걸 사용하기위해 widget.을 넣음
        index: widget.selectedForm,
        children: forms,
      ),
    );
  }
}
