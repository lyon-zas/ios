import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/pages/notes/controller/NotePage.dart';

class MyStaggeredTile extends StatefulWidget {
  final Notes note;

  MyStaggeredTile(this.note);

  @override
  _MyStaggeredTileState createState() => _MyStaggeredTileState();
}

class _MyStaggeredTileState extends State<MyStaggeredTile> {
  String _content;
  double _fontSize;
  Color tileColor;
  String title;

  @override
  Widget build(BuildContext context) {
    _content = widget.note.content;
    _fontSize = _determineFontSizeForContent();
    tileColor = widget.note.noteColor;
    title =
        '${widget.note.course}: ${widget.note.lesson} @ ${widget.note.time}';

    return InkWell(
      onTap: () {
        print('tapped note');
        _noteTapped(context);
      },
      child: Container(
        decoration: BoxDecoration(
            border: tileColor == Colors.white
                ? Border.all(color: CentralStation.borderColor)
                : null,
            color: tileColor,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: EdgeInsets.all(8),
        child: constructChild(),
      ),
    );
  }

  void _noteTapped(BuildContext ctx) {
    print('Note Tapped');
    CentralStation.updateNeeded = false;
    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => NotePage(widget.note)));
  }

  Widget constructChild() {
    List<Widget> contentsOfTiles = [];

    if (widget.note.course?.length != 0) {
      contentsOfTiles.add(
        AutoSizeText(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold,),
          maxLines:
          ('${widget.note.course}: ${widget.note.lesson} @ ${widget.note.time}')
              .length ==
              0
              ? 1
              : 4,
          textScaleFactor: 1.5,
        ),
      );
      contentsOfTiles.add(
        Divider(
          color: Colors.grey,
          height: 6,
        ),
      );
    }

    contentsOfTiles.add(AutoSizeText(
      _content,
      style: TextStyle(fontSize: _fontSize),
      maxLines: 10,
      textScaleFactor: 1.5,
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: contentsOfTiles);
  }

  double _determineFontSizeForContent() {
    int charCount = _content.length +
        ('${widget.note.course} ${widget.note.section} ${widget.note.lesson} @ ${widget.note.time}')
            .length;
    double fontSize = 20;
    if (charCount > 110) {
      fontSize = 12;
    } else if (charCount > 80) {
      fontSize = 14;
    } else if (charCount > 50) {
      fontSize = 16;
    } else if (charCount > 20) {
      fontSize = 18;
    }

    return fontSize;
  }
}
