import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tritek_lms/blocs/notes.bloc.dart';
import 'package:tritek_lms/blocs/user.bloc.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/pages/notes/views/StaggeredTiles.dart';

import 'HomePage.dart';

class StaggeredGridPage extends StatefulWidget {
  final notesViewType;

  const StaggeredGridPage({Key key, this.notesViewType}) : super(key: key);

  @override
  _StaggeredGridPageState createState() => _StaggeredGridPageState();
}

class _StaggeredGridPageState extends State<StaggeredGridPage> {
  //a map which will be used in inflating our staggered grid view
  List<Notes> _allNotesInQueryResult = [];
  viewType notesViewType;
  Users _user = Users();

  @override
  void initState() {
    super.initState();
    this.notesViewType = widget.notesViewType;

    if (_user != null && _user.id == null) {
      userBloc.userSubject.listen((value) {
        if (!mounted) {
          return;
        }

        setState(() {
          _user = value != null ? value.results : null;
        });
      });

      userBloc.getUser();
    }
    noteBloc.subject.listen((value) {
      if (!mounted) {
        return;
      }

      if (value != null) {
        setState(() {
          _allNotesInQueryResult = value;
        });
      }
    });

    noteBloc.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    // noteBloc.getNotes();
    final _key = GlobalKey();
    // return Container(
    //     child: Padding(
    //     padding: _paddingForView(context),
    //     child:
    //       StreamBuilder<List<Notes>>(
    //       stream: noteBloc.subject.stream,
    //         builder: (context, AsyncSnapshot<List<Notes>> snapshot) {
    //           return new StaggeredGridView.count(
    //             physics: new BouncingScrollPhysics(),
    //               crossAxisSpacing: 6,
    //               mainAxisSpacing: 6,
    //             crossAxisCount: _colForStaggeredView(context),
    //             children: snapshot.hasData ? getList(snapshot.data) : getList([]),
    //             staggeredTiles: _tilesForView()
    //           );
    //         }
    //       ),
    //     )
    // );
    if (_allNotesInQueryResult.length < 1)
      return Center(
        child: AutoSizeText(
          _user == null
              ? 'Login to Sync Notes'
              : Column(children: [
                Text('Theres nothing here (yet)'),
                SizedBox(height:5),
                Text("Explore available courses and"),
                Text("start your learning!"),
                 SizedBox(height:5),
              ],),
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 18.0,
            fontFamily: 'Signika Negative',
            fontWeight: FontWeight.w700,
          ),
        ),
      );

    if (widget.notesViewType == viewType.List)
      return Container(
          child: Padding(
        padding: _paddingForView(context),
        child: StaggeredGridView.count(
          key: _key,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          crossAxisCount: _colForStaggeredView(context),
          children:
              // _allNotesInQueryResult.map((i) { return _tileGenerator(i)}),;
              List.generate(_allNotesInQueryResult.length, (i) {
                return _tileGenerator(i);
              }),
              staggeredTiles: _tilesForView(),
            ),
          ));

    return Container(
        child: Padding(
          padding: _paddingForView(context),
          child: StaggeredGridView.count(
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            crossAxisCount: _colForStaggeredView(context),
            children:
            // _allNotesInQueryResult.map((i) { return _tileGenerator(i)}),;
            List.generate(_allNotesInQueryResult.length, (i) {
              return _tileGenerator(i);
            }),
            staggeredTiles: _tilesForView(),
          ),
        ));
  }

  int _colForStaggeredView(BuildContext context) {
    if (widget.notesViewType == viewType.List) return 1;
    // for width larger than 600 on grid mode, return 3 irrelevant of the orientation to accommodate more notes horizontally
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }

  List<StaggeredTile> _tilesForView() {
    // Generate staggered tiles for the view based on the current preference.
    return List.generate(_allNotesInQueryResult.length, (index) {
      return StaggeredTile.fit(1);
    });
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double topBottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(
        left: padding, right: padding, top: topBottom, bottom: topBottom);
  }

//gets the values of the notes for each of the fields in the grid
  MyStaggeredTile _tileGenerator(int n) {
    return MyStaggeredTile(_allNotesInQueryResult.elementAt(n));
  }

  List<MyStaggeredTile> getList(List<Notes> notes) {
    List<MyStaggeredTile> res = [];
    for (Notes n in notes)
      res.add(_generateTile(n));

    return res;
  }

  MyStaggeredTile _generateTile(Notes n) {
    return MyStaggeredTile(n);
  }
}
