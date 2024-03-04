import 'package:TODO/cubit/cubit.dart';
import 'package:TODO/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../reusable components/items building.dart';

class new_tasks_screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<todoCubit, todoStates>(
      listener: (BuildContext context, todoStates state) {  },
      builder: (BuildContext context, todoStates state) {
        return Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView.separated(
              itemBuilder: (context, index) => buildList(todoCubit.get(context).newTasks[index],context),
              separatorBuilder: (context, index) => SizedBox(height: 15,),
              itemCount: todoCubit.get(context).newTasks.length,
            ),
        );
      },
    );
    }
}



// Color.fromRGBO(1, 11, 19, 1.0),