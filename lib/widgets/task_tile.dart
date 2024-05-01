import 'package:flutter/material.dart';
import 'package:tuduus/app/single_task.dart';
import 'package:tuduus/data/models/task.dart';
import 'package:tuduus/controllers/main_controller.dart';

class TaskTile extends StatelessWidget {
  final Task selectedTask;
  final MainController mainCtrl;
  const TaskTile(
      {super.key, required this.selectedTask, required this.mainCtrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Checkbox(
          onChanged: (value) async {
            await mainCtrl.updateTaskComplete(selectedTask);
          },
          value: selectedTask.isComplete,
        ),
        title: Text(
          selectedTask.title,
          style: TextStyle(
              decoration: selectedTask.isComplete
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        trailing: Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedTask.isComplete
                  ? Colors.grey
                  : selectedTask.priority == 2
                      ? Colors.red
                      : selectedTask.priority == 1
                          ? Colors.amber
                          : Colors.green),
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
