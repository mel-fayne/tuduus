import 'package:activity/activity.dart';
import 'package:activity/core/types/active_type.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuduus/data/schema.dart';
import 'package:tuduus/data/task.dart';

import 'utils/constants.dart';

class MainController extends ActiveController {
  /// This override is needed
  @override
  List<ActiveType> get activities {
    return [];
  }

  ActiveBool isLoading = ActiveBool(false);
  ActiveString userName = ActiveString('');
  ActiveString currentBoard = ActiveString(defaultBoard);
  ActiveType<List<String>> taskBoardNames = ActiveType([]);
  ActiveType<List<Task>> completeTasks = ActiveType([]);
  ActiveType<List<Task>> inCompleteTasks = ActiveType([]);

  Future<void> homeInit() async {
    await getUserDetails();
    await getTaskBoards();
    await getTasks();
    notifyActivities([]);
  }

  // --------- TASKS

  Future<void> getTasks() async {
    var allTasks = await QuickeyDB.getInstance!<TaskSchema>()!
        .where({'board == ?': currentBoard.value}).order(
            ['priority'], 'DESC').toList();
    allTasks = allTasks.where((task) => task != null).cast<Task>().toList();

    completeTasks = ActiveType(
        allTasks.where((e) => e!.isComplete == true).toList() as List<Task>);
    inCompleteTasks = ActiveType(
        allTasks.where((e) => e!.isComplete == false).toList() as List<Task>);

    notifyActivities([]);
  }

  Future<void> updateTaskComplete(Task selectedTask) async {
    await QuickeyDB.getInstance!<TaskSchema>()!
        .update(selectedTask..isComplete = !selectedTask.isComplete);
    await getTasks();
  }

  Future<void> createNewTask(Task newTask) async {
    await QuickeyDB.getInstance!<TaskSchema>()?.create(
      Task(
          title: newTask.title,
          description: newTask.description,
          board: newTask.board,
          priority: newTask.priority,
          isComplete: newTask.isComplete),
    );
    await getTasks();
  }

  Future<void> updateTask(int updateId, Task newTask) async {
    newTask.id = updateId;
    await QuickeyDB.getInstance!<TaskSchema>()!.update(newTask);
    await getTasks();
  }

  Future<void> deleteTask(Task newTask) async {
    await QuickeyDB.getInstance!<TaskSchema>()!.delete(newTask);
    await getTasks();
  }

  // --------- TASK BOARDS

  Future<void> getTaskBoards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String boards = prefs.getString('taskBoards') ?? defaultBoard;
    var boardNames = boards.split(",");
    taskBoardNames = ActiveType(boardNames);
  }

  Future<void> createTaskBoard(String newBoardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String boards = prefs.getString('taskBoards') ?? defaultBoard;
    String allBoards = '$boards,$newBoardName';
    await updateBoards(allBoards);
  }

  Future<void> updateTaskBoard(String newBoardName) async {
    // update tasks in this board to have the new board name
    List<String> boards =
        taskBoardNames.value.where((e) => e != currentBoard.value).toList();
    String allBoards = '${boards.join(",")},$newBoardName';
    await updateBoards(allBoards);
  }

  Future<void> deleteTaskBoard() async {
    // delete all tasks in this board
    List<String> boards =
        taskBoardNames.value.where((e) => e != currentBoard.value).toList();
    String allBoards = boards.join(",");
    await updateBoards(allBoards);
  }

  Future<void> updateBoards(String allBoards) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('taskBoards', allBoards);
    await getTaskBoards();
    notifyActivities([]);
  }

  // --------- USER DETAILS

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('userName') ?? '';
    userName = ActiveString(name);
  }

  Future<void> handleOnboard(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setBool('isOnboarded', true);
  }
}
