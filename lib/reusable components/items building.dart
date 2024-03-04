import 'package:TODO/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget buildList(Map model, context) => Dismissible(
  key: Key("model['id']"),
  onDismissed: (direction) {
    if (direction == DismissDirection.endToStart) {
      todoCubit.get(context).DBdelete(id: model['id']);
    }
  },
  direction: DismissDirection.endToStart,
  child: Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              todoCubit.get(context).DBupdate(id: model['id']);
            },
            icon: Icon(
              Icons.crop_square_rounded,
              size: 35,
              color: Color.fromRGBO(17, 140, 216, 1),
            ),
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'cairo',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'cairo',
                        color: Colors.grey
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${model['time']}',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'cairo',
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 60,),
          Icon(
              Icons.arrow_back,
              size: 22,
              color: Colors.grey,
            ),
        ],
      ),
    ),
  ),
);