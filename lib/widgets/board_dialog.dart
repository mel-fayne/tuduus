import 'package:flutter/material.dart';
import 'package:tuduus/main_controller.dart';
import 'package:tuduus/widgets/form_field.dart';
import 'package:tuduus/widgets/primary_button.dart';

class BoardDialog extends StatefulWidget {
  final MainController mainCtrl;
  final bool isEdit;
  const BoardDialog({super.key, required this.mainCtrl, required this.isEdit});

  @override
  State<BoardDialog> createState() => _BoardDialogState();
}

class _BoardDialogState extends State<BoardDialog> {
  final boardNameForm = GlobalKey<FormState>();
  TextEditingController boardNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.isEdit
        ? boardNameCtrl.text = widget.mainCtrl.currentBoard.value
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: boardNameForm,
          child: Column(
            children: [
              Text(
                "Create A New Board",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomFormField(
                  onValidate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a board name';
                    }
                    if (widget.mainCtrl.taskBoardNames.value.contains(value)) {
                      return 'A board with this name already exists';
                    }
                    return null;
                  },
                  fieldCtrl: boardNameCtrl,
                  label: 'Board Name',
                  isRequired: true),
              PrimaryButton(
                onPressed: () async {
                  if (boardNameForm.currentState!.validate()) {
                    widget.isEdit
                        ? await widget.mainCtrl
                            .updateTaskBoard(boardNameCtrl.text)
                        : await widget.mainCtrl
                            .createTaskBoard(boardNameCtrl.text);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                isLoading: false,
                label: widget.isEdit ? "Update Board" : "Create Board",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
