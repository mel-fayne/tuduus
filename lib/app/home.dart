import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:tuduus/app/single_task.dart';
import 'package:tuduus/data/count_card.dart';
import 'package:tuduus/main_controller.dart';
import 'package:tuduus/widgets/board_dialog.dart';
import 'package:tuduus/widgets/task_tile.dart';

class HomeView extends ActiveView<MainController> {
  static const routeName = "/home";
  const HomeView({super.key, required super.activeController});

  @override
  ActiveState<ActiveView<ActiveController>, MainController> createActivity() =>
      _HomeViewState(activeController);
}

class _HomeViewState extends ActiveState<HomeView, MainController> {
  _HomeViewState(super.activeController);
  bool _isCompletedExpanded = false;

  @override
  void initState() {
    super.initState();
    activeController.homeInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBoardHeader(),
            const Divider(),
            activeController.inCompleteTasks.value.isEmpty
                ? _buildNoTasks()
                : _buildInCompleteTasks(),
            activeController.completeTasks.value.isEmpty
                ? const SizedBox()
                : _buildCompletedList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleTaskView(
                    activeController: activeController, isEdit: false)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBoardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 60,
        ),
        Text(
          "Hello ${activeController.userName.value}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 36),
        ),
        Text(
          "You can get it done today!",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 180,
              child: DropdownButton<String>(
                value: activeController.currentBoard.value,
                icon: const Icon(Icons.keyboard_arrow_down),
                underline: Container(),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    activeController.currentBoard = ActiveString(newValue);
                    await activeController.getTasks();
                  }
                },
                items: activeController.taskBoardNames.value
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        insetPadding: const EdgeInsets.symmetric(
                            vertical: 250, horizontal: 25),
                        child: BoardDialog(
                          mainCtrl: activeController,
                          isEdit: false,
                        ),
                      ),
                    ),
                child: const Text('Create New Board'))
          ],
        )
      ],
    );
  }

  Widget _buildInCompleteTasks() {
    return ListView.builder(
        key: UniqueKey(),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return TaskTile(
            selectedTask: activeController.inCompleteTasks.value[index],
            mainCtrl: activeController,
          );
        },
        itemCount: activeController.inCompleteTasks.value.length);
  }

  Widget _buildCompletedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        ExpansionPanelList(
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 5),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              setState(() {
                _isCompletedExpanded = !_isCompletedExpanded;
              });
            });
          },
          children: [
            ExpansionPanel(
              backgroundColor: Theme.of(context).colorScheme.background,
              canTapOnHeader: true,
              isExpanded: _isCompletedExpanded,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Completed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      CountWidget(
                        count: activeController.completeTasks.value.length,
                      ),
                    ],
                  ),
                );
              },
              body: _isCompletedExpanded
                  ? ListView.builder(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return TaskTile(
                          selectedTask:
                              activeController.completeTasks.value[index],
                          mainCtrl: activeController,
                        );
                      },
                      itemCount: activeController.completeTasks.value.length)
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildNoTasks() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/rest.png',
            height: 300,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'All Tasks Completed',
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const Text('Nice Work'),
        ],
      ),
    );
  }
}
