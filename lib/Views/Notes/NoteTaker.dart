import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';

class NotePage extends StatefulWidget {
  final Note note;

  const NotePage({Key key, this.note}) : super(key: key);
  @override
  NotePageState createState() => NotePageState(note: note);
}

class NotePageState extends State<NotePage> {
  final Note note;
  ZefyrController _controller;
  FocusNode _focusNode;

  NotePageState({this.note});
  Delta originalDelta;
  @override
  void initState() {
    super.initState();
    _controller = new ZefyrController(note.doc);
    _focusNode = new FocusNode();
    originalDelta = _controller.document.toDelta();
    _controller.addListener(
      () {
        var delta = _controller.document.toDelta();
        if (delta != originalDelta &&
            _controller.lastChangeSource == ChangeSource.local) {
          originalDelta = delta;
          note.lastUpdated = DateTime.now();
          var json = delta.toJson();
          String text = jsonEncode(json);
          //var rule = new ResolveInlineFormatRule();
          if (getVerseIndex(text) > -1) {
            /* int index = getVerseIndex(text);
            var preVerse = text.replaceAll("John 2:1-3",
                " \"}, {\"insert\":\"John 2:1-3\",\"attributes\": {\"a\":\"https://bible.com\"}}, {\"insert\":\"");
            var post = jsonDecode(preVerse);
            var doc = NotusDocument.fromJson(post);
            var newDelta = Delta.fromJson(post); */
            var change = _controller.document.format(
                getVerseIndex(text),
                getVerseLength(text),
                NotusAttribute.link.fromString("https://bible.com"));
            /* _controller.formatText(getVerseIndex(text), getVerseLength(text),
                NotusAttribute.link.fromString("https://bible.com")); 
                */
            _controller.compose(change);
          }
          InheritedBlocs.of(context).notesBloc.addUpdateNote.add(note);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = new ZefyrThemeData(
      //textColor: Colors.white70,
      cursorColor: Colors.blue,
      toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
        color: Colors.grey.shade800,
        toggleColor: Colors.grey.shade900,
        iconColor: Colors.white,
        disabledIconColor: Colors.grey.shade500,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ZefyrScaffold(
          child: ZefyrTheme(
            data: theme,
            child: ZefyrEditor(
              controller: _controller,
              focusNode: _focusNode,
            ),
          ),
        ),
      ),
    );
  }

  int getVerseIndex(String text) {
    return text.indexOf("John 2:1-3");
  }

  int getVerseLength(String text) {
    return ("John 2:1-3").length;
  }
}
