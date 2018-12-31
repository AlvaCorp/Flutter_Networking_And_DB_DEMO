import 'package:api_to_db_flutter/models/PhotoDb.dart';
import 'package:api_to_db_flutter/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRecordScreen extends StatefulWidget {
  @override
  State<DatabaseRecordScreen> createState() {
    // TODO: implement createState
    return DatabaseRecordScreenState();
  }
}

class DatabaseRecordScreenState extends State<DatabaseRecordScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<PhotoDb> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<PhotoDb>();
      updateListView();
    }

    return Scaffold(
//      appBar: AppBar(
//        title: Text('Notes'),
//      ),

      body: getNoteListView(),

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          debugPrint('FAB clicked');
//        },
//
//        tooltip: 'Add Note',
//
//        child: Icon(Icons.add),
//
//      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              child: new Image.network(
                this.noteList[position].thumbnail,
                height: 40.0,
                width: 40.0,
              ),
            ),

            title: Text(
              this.noteList[position].title,
              style: titleStyle,
            ),

//            subtitle: Text(this.noteList[position].date),

            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),

            onTap: () {
              debugPrint("ListTile Tapped");
//              navigateToDetail(this.noteList[position],'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, PhotoDb note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<PhotoDb>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  getImages() {}
}