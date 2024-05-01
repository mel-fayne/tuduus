import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:tuduus/data/models/task.dart';
import 'package:tuduus/controllers/main_controller.dart';
import 'package:tuduus/utils/constants.dart';
import 'package:tuduus/utils/functions.dart';
import 'package:tuduus/widgets/dropdown_field.dart';
import 'package:tuduus/widgets/form_field.dart';
import 'package:tuduus/widgets/primary_button.dart';

class SingleTaskView extends ActiveView<MainController> {
  static const routeName = "/single-task";
  final bool isEdit;
  final Task? currentTask;
  const SingleTaskView(
      {super.key,
      required super.activeController,
      this.currentTask,
      required this.isEdit});

  @override
  ActiveState<ActiveView<ActiveController>, MainController> createActivity() =>
      _SingleTaskViewState(activeController);
}

class _SingleTaskViewState extends ActiveState<SingleTaskView, MainController> {
  _SingleTaskViewState(super.activeController);
  final taskForm = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  String priority = 'LOW';
  bool isComplete = false;
  String boardName = defaultBoard;

  @override
  void initState() {
    super.initState();
    if (widget.currentTask != null && widget.isEdit) {
      titleCtrl.text = widget.currentTask!.title;
      descCtrl.text = widget.currentTask!.description ?? '';
      priority = getPriority(widget.currentTask!.priority);
      isComplete = widget.currentTask!.isComplete;
      boardName = widget.currentTask!.boardName!;
    } else {
      boardName = activeController.currentBoard.value.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Form(
          key: taskForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBoardField(),
              CustomFormField(
                  onValidate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a task name';
                    }
                    return null;
                  },
                  fieldCtrl: titleCtrl,
                  label: 'Task Name',
                  isRequired: true),
              CustomFormField(
                  onValidate: (value) {
                    return null;
                  },
                  fieldCtrl: descCtrl,
                  label: 'Description',
                  maxLines: 4,
                  isRequired: false),
              _buildPriorityField(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Completed:'),
                  Checkbox(
                      value: isComplete,
                      onChanged: (value) {
                        isComplete = value!;
                        setState(() {});
                      }),
                ],
              ),
              PrimaryButton(
                onPressed: () async {
                  if (taskForm.currentState!.validate()) {
                    Task newTask = Task(
                        title: titleCtrl.text,
                        description: descCtrl.text,
                        boardName: boardName,
                        priority: priorityStates[priority] ?? 0,
                        isComplete: isComplete);
                    widget.isEdit
                        ? await activeController.updateTask(
                            widget.currentTask!.id!, newTask)
                        : await activeController.createNewTask(newTask);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                isLoading: false,
                label: widget.isEdit ? "Update Task" : "Create Task",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Column(
            children: priorityStates.keys
                .map(
                  (e) => ListTile(
                    title: Text(
                      e,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: e == 'HIGH'
                              ? Colors.red
                              : e == 'MID'
                                  ? Colors.amber
                                  : Colors.green),
                    ),
                    leading: Radio<String>(
                      value: e,
                      groupValue: priority,
                      onChanged: (value) {
                        priority = value!;
                        setState(() {});
                      },
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildBoardField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text('TaskBoard'),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          width: double.infinity,
          child: DropDownField(
              dropdownValue: boardName,
              onSelected: (String? newValue) async {
                if (newValue != null) {
                  boardName = newValue;
                }
                setState(() {});
              },
              dropdownList: activeController.taskBoardNames.value),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      title: widget.isEdit ? const SizedBox() : const Text('Create a Task'),
      actions: [
        widget.isEdit
            ? Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () async {
                    activeController.deleteTask(widget.currentTask!);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete Task',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }
}
