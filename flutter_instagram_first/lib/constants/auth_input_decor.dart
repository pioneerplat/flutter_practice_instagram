//_text 라면 앞에 _를 빼주고 text라 써야 다른 파일에서도 접근할 수 있다.
import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';

InputDecoration textInputDecor(String hint) {
  return InputDecoration(
    hintText: hint,
    enabledBorder: activeInputBorder(),
    focusedBorder: activeInputBorder(),
    errorBorder: errorInputBorder(),
    focusedErrorBorder: errorInputBorder(),
    //필드 색지정
    filled: true,
    fillColor: Colors.grey[100],
  );
}

OutlineInputBorder errorInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.redAccent,
      ),
      borderRadius: BorderRadius.circular(common_s_gap));
}

OutlineInputBorder activeInputBorder() {
  return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[300],
      ),
      borderRadius: BorderRadius.circular(common_s_gap));
}