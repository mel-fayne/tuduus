import 'package:flutter/material.dart';
import 'package:tuduus/app/single_task.dart';
import 'package:tuduus/data/models/task.dart';
import 'package:tuduus/controllers/main_controller.dart';
import 'package:tuduus/theme/colors.dart';

class TaskTile extends StatelessWidget {
  final Task selectedTask;
  final MainController mainCtrl;
  const TaskTile(
      {super.key, required this.selectedTask, required this.mainCtrl});

  @override
  Widget build(BuildContext context) {
    Color boardColor = selectedTask.isComplete
        ? Colors.grey
        : boardColors[mainCtrl.taskBoards.value
            .where((e) => e.title == selectedTask.boardName!)
            .first
            .boardColorIdx];

    Color taskColor = selectedTask.isComplete
        ? Colors.grey
        : selectedTask.priority == 2
            ? Colors.red
            : selectedTask.priority == 1
                ? Colors.amber
                : Colors.green;

    return ListTile(
        leading: Checkbox(
          onChanged: (value) async {
            await mainCtrl.updateTaskComplete(selectedTask);
          },
          value: selectedTask.isComplete,
          side: mainCtrl.isAllView.value
              ? MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(width: 1.0, color: taskColor),
                )
              : null,
        ),
        title: Text(
          selectedTask.title,
          style: TextStyle(
              decoration: selectedTask.isComplete
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        trailing: mainCtrl.isAllView.value
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: boardColor)),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                child: Text(selectedTask.boardName!,
                    style: TextStyle(fontSize: 10, color: boardColor)),
              )
            : Container(
                height: 15,
                width: 15,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: taskColor),
              ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleTaskView(
                  currentTask: selectedTask,
                  activeController: mainCtrl,
                  isEdit: true),
            ),
          );
        });
  }
}
