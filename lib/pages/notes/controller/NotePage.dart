import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:tritek_lms/appTheme/appTheme.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/repository/notes.repository.dart';
import 'package:tritek_lms/pages/notes/views/MoreOptionsSheet.dart';

class NotePage extends StatefulWidget {
  final Notes noteInEditing;

  //constructor that takes a Note object
  NotePage(
    this.noteInEditing,
  );

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _contentController = TextEditingController();
  var noteColor;
  bool _isNewNote = false;
  final _contentFocus = FocusNode();
  final NoteRepository _repository = NoteRepository();

  String _contentFromInitial;
  DateTime _lastEditedForUndo;

  Notes _editableNote;

  // the timer variable responsible to call persistData function every 5 seconds and cancel the timer when the page pops.
  Timer _persistenceTimer;

  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  bool _deleted = false;

  @override
  void initState() {
    super.initState();
    _editableNote = widget.noteInEditing;
    _contentController.text = _editableNote.content;
    noteColor = _editableNote.noteColor;
    _lastEditedForUndo = widget.noteInEditing.updatedAt;

    _contentFromInitial = widget.noteInEditing.content;

    if (widget.noteInEditing.id == -1) {
      _isNewNote = true;
    }
    _persistenceTimer = new Timer.periodic(Duration(seconds: 10), (timer) {
      _persistData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
            color: themeGold,
          ),
          actions: _archiveAction(context),
          elevation: 1,
          backgroundColor: themeBlue,
          title: _pageTitle(),
        ),
        body: _body(context),
      ),
      onWillPop: _readyToPop,
    );
  }

  Widget _body(BuildContext ctx) {
    return Container(
        color: noteColor,
        padding: EdgeInsets.only(left: 16, right: 16, top: 12),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AutoSizeText(
                _editableNote.course +
                    ': ' +
                    _editableNote.lesson +
                    ' @' +
                    _editableNote.time,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Signika Negative',
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  color: themeBlue,
                ),
              ),
              Divider(),
              Flexible(
                  child: Container(
                      padding: EdgeInsets.all(5),
//    decoration: BoxDecoration(border: Border.all(color: CentralStation.borderColor,width: 1),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                      child: TextField(
                        decoration: InputDecoration(hintText: 'Your Note here'),
                        onChanged: (str) => {updateNoteObject()},
                        maxLines: 300,
                        // line limit extendable later
                        controller: _contentController,
                        focusNode: _contentFocus,
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        cursorColor: Colors.blue,
                      )))
            ],
          ),
          left: true,
          right: true,
          top: false,
          bottom: false,
        ));
  }

  //returns a new text with "New Note" or "Edit Note" based on the value of _editableNote.id
  Widget _pageTitle() {
    return Text(
      _editableNote.id == null ? "New Note" : "Edit Note",
      style: TextStyle(
        fontFamily: 'Signika Negative',
        fontWeight: FontWeight.w700,
        fontSize: 18.0,
        color: themeGold,
      ),
    );
  }

  List<Widget> _archiveAction(BuildContext context) {
    List<Widget> actions = [];
    if (widget.noteInEditing.id != -1) {
      actions.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _undo(),
            child: Icon(
              Icons.undo,
              color: themeGold,
            ),
          ),
        ),
      ));
    }
    actions += [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => _archivePopup(context),
            child: Icon(
              Icons.archive,
              color: themeGold,
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          child: GestureDetector(
            onTap: () => bottomSheet(context),
            child: Icon(Icons.more_vert, color: themeGold),
          ),
        ),
      ),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 12),
      //   child: InkWell(
      //     child: GestureDetector(
      //       onTap: () => {_saveAndStartNewNote(context)},
      //       child: Icon(
      //         Icons.add,
      //         color: themeGold,
      //       ),
      //     ),
      //   ),
      // )
    ];
    return actions;
  }

  //responsible for opening the moreOptionsSheet Class and its widgets
  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return MoreOptionsSheet(
            color: noteColor,
            callBackColorTapped: _changeColor,
            callBackOptionTapped: bottomSheetOptionTappedHandler,
            updatedAt: _editableNote.updatedAt,
          );
        });
  }

  //saves data as the user makes changes and saves and updates this value whenever it changes
  Future<void> _persistData() async {
    print(_deleted.toString());
    if (_deleted) {
      return;
    }

    updateNoteObject();
    if (_editableNote.content.isNotEmpty) {
      if (_editableNote.id == -1) {
        Notes autoIncrementedId =
            await _repository.update(_editableNote); // for new note
        // set the id of the note from the database after inserting the new note so for next persisting
        _editableNote.id = autoIncrementedId.id;
      } else {
        _editableNote.createdAt = DateTime.now();
        _editableNote.updatedAt = DateTime.now();

        if (_editableNote.noteColor == null) {
          _editableNote.noteColor = Colors.white;
        }
        _editableNote.synced = false;
        print('Saving Note: NotePage');
        await _repository.save(_editableNote); // for updating the existing note
      }
    }
  }

// this function will ne used to save the updated editing value of the note to the local variables as user types
  void updateNoteObject() {
    _editableNote.content = _contentController.text;
    _editableNote.noteColor = noteColor;

    if (!(_editableNote.content == _contentFromInitial) || (_isNewNote)) {
      if (_editableNote.id == -1) {
        _editableNote.createdAt = DateTime.now();
      }
      // No changes to the note
      // Change last edit time only if the content of the note is mutated in compare to the note which the page was called with.
      _editableNote.updatedAt = DateTime.now();
      CentralStation.updateNeeded = true;
    }
  }

  //Handles callbacks on the MoreOptionsSheet
  void bottomSheetOptionTappedHandler(moreOptions tappedOption) {
    print("option tapped: $tappedOption");
    switch (tappedOption) {
      case moreOptions.delete:
        {
          if (_editableNote.id != -1) {
            _deleteNote(_globalKey.currentContext);
          } else {
            _exitWithoutSaving(context);
          }
          break;
        }
      case moreOptions.share:
        {
          if (_editableNote.content.isNotEmpty) {
            Share.share(
                "${_editableNote.course}\n${_editableNote.section}\n${_editableNote.lesson}\n${_editableNote.content}");
          }
          break;
        }
      case moreOptions.copy:
        {
          _copy();
          break;
        }
    }
  }

  //deletes a saved note from the database when the user selects delete from the bottom sheet
  void _deleteNote(BuildContext context) {
    if (_editableNote.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm ?"),
              content: Text("This note will be deleted permanently"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      setState(() {
                        _deleted = true;
                      });
                      _persistenceTimer.cancel();
                      _repository.delete(_editableNote);
                      CentralStation.updateNeeded = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("No"))
              ],
            );
          });
    }
  }

  //responsible for responding whenever the user selects on a color by changing the color and saving the color
  //value to the database
  void _changeColor(Color newColorSelected) {
    setState(() {
      noteColor = newColorSelected;
      _editableNote.noteColor = newColorSelected;
    });
    if (_editableNote.id != -1) {
      _editableNote.noteColor = noteColor;
      _repository.save(_editableNote);
    }
    CentralStation.updateNeeded = true;
  }

  //this function is called whenever the user clicks on the plus icon to add a new note from
  //an already existing note.
  void _saveAndStartNewNote(BuildContext context) {
    _persistenceTimer.cancel();
    var emptyNote = new Notes();
    Navigator.of(context).pop();
    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  Future<bool> _readyToPop() async {
    _persistenceTimer.cancel();
    //show saved toast after calling _persistData function.

    await _persistData();
    return true;
  }

  //build a pop up for whenever a user clicks on the archive icon,
  // this prompt asks the user if he is sure before proceeding to archive the note

  void _archivePopup(BuildContext context) {
    if (_editableNote.id != -1) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm ?"),
              content: Text("This note will be archived"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => _archiveThisNote(context),
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("No"))
              ],
            );
          });
    } else {
      _exitWithoutSaving(context);
    }
  }

  //this function is called whenever a user clicks on a new note but no value is entered
  void _exitWithoutSaving(BuildContext context) {
    _persistenceTimer.cancel();
    CentralStation.updateNeeded = false;
    Navigator.of(context).pop();
  }

  //responsible for archiving the note
  void _archiveThisNote(BuildContext context) {
    Navigator.of(context).pop();
    // set archived flag to true and send the entire note object in the database to be updated
    _editableNote.isArchived = true;
    _repository.update(_editableNote);
    // update will be required to remove the archived note from the staggered view
    _persistenceTimer.cancel(); // shutdown the timer

    CentralStation.updateNeeded = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: Text("Archived")));
    Navigator.of(context).pop(); // pop back to staggered view
  }

  //this function duplicates a note with the selected id whenever
  //copy is tapped on from the bottom sheet
  void _copy() {
    Notes copy = Notes.fromJson(_editableNote.toJson(false));

    var status = _repository.save(copy);
    CentralStation.updateNeeded = true;
    if (status != null) {
      Navigator.of(_globalKey.currentContext).pop();
    }
  }

//undo changes made to the text using FLutter's TextController method
  void _undo() {
    _contentController.text =
        _contentFromInitial; // widget.noteInEditing.content;
    _editableNote.updatedAt =
        _lastEditedForUndo; // widget.noteInEditing.date_last_edited;
  }
}
