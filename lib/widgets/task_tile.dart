import 'package:flutter/material.dart';
import 'package:tuduus/data/task.dart';
import 'package:tuduus/main_controller.dart';

class TaskTile extends StatelessWidget {
  final Task selectedTask;
  final MainController mainCtrl;
  const TaskTile(
      {super.key, required this.selectedTask, required this.mainCtrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CheckboxListTile(
        onChanged: (value) async {
          await mainCtrl.updateTaskComplete(selectedTask);
        },
        value: selectedTask.isComplete,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedTask.title),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedTask.priority == 2
                      ? Colors.red
                      : selectedTask.priority == 1
                          ? Colors.green
                          : Colors.blue),
            )
          ],
        ),
      ),
    );
  }
}
