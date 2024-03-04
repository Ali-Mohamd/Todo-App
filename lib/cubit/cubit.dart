import 'package:TODO/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/done_tasks/done_tasks_screen.dart';
import '../modules/tasks/new_tasks_screen.dart';

class todoCubit extends Cubit<todoStates> {

  todoCubit() : super(initialState());
  static todoCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  Database? DB;
  bool isBTM = false;
  IconData bottomSheetIcon = Icons.add;

  List <Widget> screens = [
    new_tasks_screen(),
    done_tasks_screen(),
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index) {
    currentIndex = index;
    emit(btmNavBar());
  }

  void DBcreate() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (DB, version) {
        print('DB created');
        DB.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT);')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (DB) async {
        if (DB != null) {
          List<Map> fetchedTasks = await DBget(DB);
          fetchedTasks.forEach((element) {
            if (element['status'] == 'new') {
              newTasks.add(element);
            } else if (element['status'] == 'done') {
              doneTasks.add(element);
            }
          });
          print('DB opened');
          emit(getDBstate());
        }
      },
    ).then((value) {
      DB = value;
      emit(createDBstate());
    });
  }

  Future<List<Map>> DBget(Database db) async {
    List<Map> result = await db.rawQuery('SELECT * FROM tasks');
    return result.isNotEmpty ? result : [];
  }

  DBinsert({
    required String title,
    required String time,
    required String date,
  }) async {
    await DB!.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES(?, ?, ?, ?)',
          [title, date, time, "new"]);
      print('Inserted task with id $id');
    });
    await fetchAndUpdateTasks();
    emit(insertDBstate());
  }

  Future<void> fetchAndUpdateTasks() async {
    newTasks = [];
    doneTasks = [];
    List<Map> fetchedTasks = await DBget(DB!);
    fetchedTasks.forEach((element) {
        if (element['status'] == 'new' && !newTasks.any((task) => task['id'] == element['id']) ) {
          newTasks.add(element);
        } else if (element['status'] == 'done' && !doneTasks.any((task) => task['id'] == element['id'])) {
          doneTasks.add(element);
        }
      emit(getDBstate());
    });
  }

  void sheetVarChange ({
    required bool btm,
    required IconData icn}) {
    isBTM = btm;
    bottomSheetIcon = icn;

    emit(sheetState());
  }

  void DBupdate({
    required int id
}) async {
     DB!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['done', id]).then((value)
     {
       fetchAndUpdateTasks();
       emit(updateDBstate());
     }
     );
  }

  void DBdelete({
    required int id
  }) async {
    DB!..rawDelete("DELETE FROM tasks WHERE id = ?", [id]).then((value)
    {
      fetchAndUpdateTasks();
      emit(deleteDBstate());
    }
    );
  }

}

