import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../cubit/states.dart';
import '../../reusable components/items building.dart';

class done_tasks_screen extends StatelessWidget {
  const done_tasks_screen({super.key});
  Widget build(BuildContext context) {
    return BlocConsumer<todoCubit, todoStates>(
      listener: (BuildContext context, todoStates state) {  },
      builder: (BuildContext context, todoStates state) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.separated(
            itemBuilder: (context, index) => buildList(todoCubit.get(context).doneTasks[index],context),
            separatorBuilder: (context, index) => SizedBox(height: 15,),
            itemCount: todoCubit.get(context).doneTasks.length,
          ),
        );
      },
    );
  }

}
