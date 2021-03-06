import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

class ChaperText extends IChapterElement {
  final String text;
  ChaperText({this.text}) : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        ''' ${this.text.trim()} ''',
        style: new TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    //var reg = RegExp("\s[.!?\\-]", caseSensitive: false);
    //var text = this.text.replaceAllMapped(reg, (Match m) => "${m[1]}");

    var span = TextSpan(
      children: [
        TextSpan(
          text: '''${this.text}''',
          style: Theme.of(context).textTheme.body2,
        )
      ],
    );
    return span;
  }
}
