import 'package:flutter/material.dart';
import 'package:tuduus/data/models/board.dart';
import 'package:tuduus/controllers/main_controller.dart';
import 'package:tuduus/theme/colors.dart';
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
  int boardColorIdx = 0;
  TextEditingController boardNameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      boardNameCtrl.text = widget.mainCtrl.currentBoard.value.title;
      boardColorIdx = widget.mainCtrl.currentBoard.value.boardColorIdx;
    } else {
      boardNameCtrl.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: boardNameForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.isEdit ? "Edit Board" : "Create A New Board",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomFormField(
                  onValidate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a board name';
                    }
                    if (!widget.isEdit &&
                        widget.mainCtrl.taskBoardNames.value.contains(value)) {
                      return 'A board with this name already exists';
                    }
                    if (value.contains(',')) {
                      return 'A board name cannot contain a comma (,)';
                    }
                    return null;
                  },
                  fieldCtrl: boardNameCtrl,
                  label: 'Board Name',
                  isRequired: true),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Choose a board Color',
                style: TextStyle(fontSize: 16),
              ),
              Wrap(
                children: boardColors
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: e),
                            ),
                            selected: boardColorIdx == boardColors.indexOf(e),
                            onSelected: (value) async {
                              boardColorIdx = boardColors.indexOf(e);
                              setState(() {});
                            },
                          ),
                        ))
                    .toList(),
              ),
              PrimaryButton(
                onPressed: () async {
                  if (boardNameForm.currentState!.validate()) {
                    Board newBoard = Board(
                        title: boardNameCtrl.text,
                        boardColorIdx: boardColorIdx);
                    widget.isEdit
                        ? await widget.mainCtrl.updateTaskBoard(newBoard)
                        : await widget.mainCtrl.createTaskBoard(newBoard);
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
