import 'package:flutter/material.dart';
import 'package:flutter_instagram_first/constants/common_size.dart';
import 'package:flutter_instagram_first/models/firestore/comment_model.dart';
import 'package:flutter_instagram_first/models/firestore/user_model.dart';
import 'package:flutter_instagram_first/models/user_model_state.dart';
import 'package:flutter_instagram_first/widgets/comment.dart';
import 'package:provider/provider.dart';
import 'package:flutter_instagram_first/repo/comment_network_repository.dart';

class CommentsScreen extends StatefulWidget {
  final String postKey;

  const CommentsScreen(this.postKey, {Key key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
                child: StreamProvider<List<CommentModel>>.value(
                    value: commentNetworkRepository
                        .fetchAllComments(widget.postKey),
                    child: Consumer<List<CommentModel>>(
                      builder: (BuildContext context,
                          List<CommentModel> comments, Widget child) {
                        return ListView.separated(

                          //각 각의 comment들 사이에 얼마만큼의 공간을 줄거냐
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return SizedBox(height: common_xxs_gap,);
                          },

                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(common_xxs_gap),
                              child: Comment(
                                username: comments[index].username,
                                text: comments[index].comment,
                                dateTime: comments[index].commentTime,
                                showImage: true,
                              ),
                            );
                          },
                          itemCount: comments == null ? 0 : comments.length,
                        );
                      },
                    ))),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[500],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: common_gap),
                    child: TextFormField(
                      controller: _textEditingController,
                      cursorColor: Colors.black54,
                      autofocus: true,
                      decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: InputBorder.none),
                      //textField에 적은 글을 value로 받아서 검사한다
                      validator: (String value) {
                        if (value.isEmpty)
                          return 'Input something';
                        else
                          return null;
                      },
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      UserModel usermodel = Provider
                          .of<UserModelState>(context, listen: false)
                          .userModel;
                      Map<String, dynamic> newComment = CommentModel
                          .getMapForNewComment(
                          usermodel.userKey, usermodel.username, _textEditingController.text);
                     await commentNetworkRepository.createNewComment(widget.postKey, newComment);
                     //comment가 등록되고 나면 textField를 비워줘야 한다
                     _textEditingController.clear();
                    }
                  },
                  child: Text("Post"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
