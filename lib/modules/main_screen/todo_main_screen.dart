import 'package:TODO/cubit/cubit.dart';
import 'package:TODO/cubit/states.dart';
import 'package:flutter/material.dart' as todo_main_screen;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../Style/colors.dart';
import '../done_tasks/done_tasks_screen.dart';
import '../tasks/new_tasks_screen.dart';

class Todo extends StatelessWidget {

  final TextEditingController tilteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final DateTime now = DateTime.now();

  final GlobalKey<ScaffoldState> SCkey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final todo_main_screen.Color bars =
  todo_main_screen.Color.fromRGBO(1, 11, 19, 1.0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => todoCubit()..DBcreate(),
      child: BlocConsumer<todoCubit, todoStates>(
        listener: (BuildContext context, todoStates state) {  },
        builder: (BuildContext context, todoStates state) {
          todoCubit cubit = todoCubit.get(context);
          return Scaffold(
            backgroundColor: Color.fromRGBO(1, 11, 19, 1.0),
            key: SCkey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                title: todo_main_screen.Text(
                  todoCubit.get(context).titles[todoCubit.get(context).currentIndex],
                  style: todo_main_screen.TextStyle(
                      color: todo_main_screen.Colors.white, fontFamily: 'cairo'),
                ),
                backgroundColor: bars,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
            ),
            floatingActionButton: todo_main_screen.FloatingActionButton(
              onPressed: () {
                if (cubit.isBTM) {
                  Navigator.pop(context);
                  cubit.sheetVarChange(btm: false, icn: Icons.add);
                } else {
                  PersistentBottomSheetController bottomSheetController =
                  SCkey.currentState!.showBottomSheet((context) => Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(13, 25, 34, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, top: 40, bottom: 20),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              controller: tilteController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Title';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Title',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cairo',
                                ),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      tilteController.text = '';
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 27,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(color: Colors.white),
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime:
                                  TimeOfDay.now(), // Set the initial selected time if needed
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: bars,
                                        colorScheme: ColorScheme.light(
                                          primary: bars,
                                          onPrimary: Colors.white,
                                        ),
                                        buttonTheme: ButtonThemeData(
                                            textTheme:
                                            ButtonTextTheme.primary),
                                      ),
                                      child: child!,
                                    );
                                  },
                                ).then((value) =>
                                timeController.text =
                                    value!.format(context).toString());
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Time';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Time',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cairo',
                                ),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      timeController.text = '';
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 27,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            TextFormField(
                              readOnly: true,
                              style: TextStyle(color: Colors.white),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                      Duration(days: 365 * 3)),
                                  initialDate:
                                  DateTime.now(), // Set the initial selected date if needed
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        primaryColor: bars,
                                        colorScheme: ColorScheme.light(
                                          primary: bars,
                                          onPrimary: Colors.white,
                                        ),
                                        buttonTheme: ButtonThemeData(
                                            textTheme:
                                            ButtonTextTheme.primary),
                                      ),
                                      child: child!,
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  }
                                });
                              },
                              controller: dateController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the Date';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'cairo',
                                ),
                                labelText: 'Task Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.white,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      dateController.text = '';
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 27,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: secColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextButton(
                                  onPressed: () async {
                                    int lnth = todoCubit.get(context).newTasks.length;
                                    print('New tasks length = ${lnth}');
                                    if (formKey.currentState!.validate()) {
                                      await todoCubit.get(context).DBinsert(
                                        title: tilteController.text,
                                        time: timeController.text,
                                        date: dateController.text,
                                      );
                                      Navigator.pop(context);
                                      cubit.sheetVarChange(btm: false, icn: Icons.add);
                                      tilteController.text = '';
                                      timeController.text = '';
                                      dateController.text = '';
                                    }
                                  },
                                  child: Text(
                                    'Add Task',
                                    style: TextStyle(
                                      fontFamily: 'cairo',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    elevation: 10,
                    backgroundColor: Colors.transparent,
                  );
                  cubit.sheetVarChange(btm: true, icn: Icons.close);
                  bottomSheetController.closed.then((value) {
                    cubit.sheetVarChange(btm: false, icn: Icons.add);
                  });
                }
              },
              backgroundColor: secColor,
              child: Icon(
                cubit.bottomSheetIcon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: todo_main_screen.BottomNavigationBar(
              backgroundColor: bars,
              type: todo_main_screen.BottomNavigationBarType.fixed,
              unselectedItemColor: todo_main_screen.Colors.white,
              selectedItemColor: secColor,
              currentIndex: todoCubit.get(context).currentIndex,
              onTap: (index) {
                todoCubit.get(context).changeIndex(index);
              },
              items: const [
                todo_main_screen.BottomNavigationBarItem(
                  icon: todo_main_screen.Icon(
                    todo_main_screen.Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                todo_main_screen.BottomNavigationBarItem(
                  icon: todo_main_screen.Icon(
                    todo_main_screen.Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
              ],
            ),
            body: todoCubit.get(context).newTasks.length == 0 && todoCubit.get(context).doneTasks.length == 0
                ? Container(color: Color.fromRGBO(1, 11, 19, 1.0),)  //todo_main_screen.Center(child: CircularProgressIndicator())
                : todoCubit.get(context).screens[todoCubit.get(context).currentIndex],
          );
        },
      ),
    );
  }
}
