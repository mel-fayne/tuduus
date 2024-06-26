import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:tuduus/app/single_task.dart';
import 'package:tuduus/widgets/count_card.dart';
import 'package:tuduus/controllers/main_controller.dart';
import 'package:tuduus/utils/constants.dart';
import 'package:tuduus/widgets/board_dialog.dart';
import 'package:tuduus/widgets/dropdown_field.dart';
import 'package:tuduus/widgets/primary_button.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/tuduus-v2-logo.png',
          height: 50,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 15,
              child: Text(activeController.userName.value,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBoardHeader(),
            const Divider(),
            _buildPriorityFilters(),
            const Divider(),
            activeController.inCompleteTasks.value.isEmpty &&
                    activeController.selectedPriority.value == 'All'
                ? _buildNoTasks()
                : _buildInCompleteTasks(),
            activeController.completeTasks.value.isEmpty
                ? const SizedBox()
                : _buildCompletedList(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            )
          ],
        ),
      ),
      bottomSheet: _buildBottomSheet(),
      floatingActionButton: activeController.isStarredView.value
          ? const SizedBox()
          : FloatingActionButton(
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 180,
              child: DropDownField(
                  dropdownValue: activeController.selectedView.value,
                  onSelected: (String? newValue) async {
                    if (newValue != null) {
                      if (newValue == allBoardsTitle) {
                        activeController.isStarredView = ActiveBool(true);
                        activeController.selectedView =
                            ActiveString(allBoardsTitle);
                      } else {
                        activeController.isStarredView = ActiveBool(false);
                        activeController.selectedView = ActiveString(newValue);
                        activeController.currentBoard = ActiveType(
                            activeController.taskBoards.value
                                .where((e) => e.title == newValue)
                                .first);
                      }
                      await activeController.getTasks();
                    }
                  },
                  dropdownList: activeController.taskBoardNames.value),
            ),
            ElevatedButton(
                onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
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
        padding: EdgeInsets.zero,
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
                      padding: EdgeInsets.zero,
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

  Widget _buildPriorityFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              Icons.filter_alt,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Text("Filter by Priority"),
          ],
        ),
        Wrap(
          children: ['All', ...priorityStates.keys]
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(e),
                      selected: activeController.selectedPriority.value == e,
                      onSelected: (value) async {
                        activeController.selectedPriority = ActiveString(e);
                        await activeController.getTasks();
                      },
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      height: MediaQuery.of(context).size.height / 12,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            activeController.isStarredView.value
                ? const SizedBox()
                : IconButton(
                    onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: BoardDialog(
                              mainCtrl: activeController,
                              isEdit: true,
                            ),
                          ),
                        ),
                    icon: const Icon(Icons.edit_square)),
            IconButton(
                onPressed: () async {
                  activeController.isDesc =
                      ActiveBool(!activeController.isDesc.value);
                  await activeController.getTasks();
                },
                icon: Icon(activeController.isDesc.value
                    ? Icons.keyboard_double_arrow_down
                    : Icons.keyboard_double_arrow_up)),
            activeController.isStarredView.value ||
                    activeController.taskBoardNames.value.length == 1
                ? const SizedBox()
                : IconButton(
                    onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => Dialog(
                            child: _buildDeleteWarning(),
                          ),
                        ),
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildNoTasks() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/rest.png',
            height: 200,
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

  Widget _buildDeleteWarning() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            "Delete Board",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              """
All tasks in this board will be lost!
Are you sure you want to delete your '${activeController.currentBoard.value}' task board? 
            """,
              textAlign: TextAlign.center,
            ),
          ),
          PrimaryButton(
              onPressed: () async {
                await activeController.deleteTaskBoard();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              label: 'Delete Board',
              isLoading: false)
        ],
      ),
    ));
  }
}
