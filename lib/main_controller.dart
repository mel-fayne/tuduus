import 'package:activity/activity.dart';
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

  ActiveString userName = ActiveString('');
  ActiveString selectedPriority = ActiveString('All');
  ActiveString currentBoard = ActiveString(defaultBoard);
  ActiveType<List<String>> taskBoardNames = ActiveType([]);
  ActiveType<List<Task>> completeTasks = ActiveType([]);
  ActiveType<List<Task>> inCompleteTasks = ActiveType([]);
  ActiveBool isDesc = ActiveBool(true);

  Future<void> homeInit() async {
    await getUserDetails();
    await getBoards();
    await getTasks();
    notifyActivities([]);
  }

  // --------- TASKS

  Future<void> getTasks() async {
    String sortOrder = isDesc.value ? 'DESC' : 'ASC';
    final Map<String, dynamic> fetchQuery = {'board == ?': currentBoard.value};
    if (selectedPriority.value != "All") {
      fetchQuery['priority == ?'] = priorityStates[selectedPriority.value];
    }

    var allTasks = await QuickeyDB.getInstance!<TaskSchema>()!
        .where(fetchQuery)
        .order(['priority'], sortOrder).toList();
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

  Future<void> getBoards({String? newBoard}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String boards = prefs.getString('taskBoards') ?? defaultBoard;
    var boardNames = boards.split(",");

    taskBoardNames = ActiveType(boardNames);
    currentBoard = ActiveString(newBoard ?? taskBoardNames.value[0]);
  }

  Future<void> createTaskBoard(String newBoardName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String boards = prefs.getString('taskBoards') ?? defaultBoard;
    String allBoards = '$boards,$newBoardName';

    await updateBoards(newBoard: newBoardName, allBoards: allBoards);
    await getTasks();
  }

  Future<void> updateTaskBoard(String newBoardName) async {
    // update all tasks in this board
    var batch = QuickeyDB.getInstance!.database!.batch();
    batch.update('tasks', {'board': newBoardName},
        where: 'board = ?', whereArgs: [currentBoard.value]);
    await batch.commit();
    // update board
    List<String> boards =
        taskBoardNames.value.where((e) => e != currentBoard.value).toList();
    String allBoards =
        boards.isEmpty ? newBoardName : '${boards.join(",")},$newBoardName';

    await updateBoards(allBoards: allBoards);
  }

  Future<void> deleteTaskBoard() async {
    // delete all tasks in this board
    var batch = QuickeyDB.getInstance!.database!.batch();
    batch.delete('tasks', where: 'board = ?', whereArgs: [currentBoard.value]);
    await batch.commit();
    // delete board
    List<String> boards =
        taskBoardNames.value.where((e) => e != currentBoard.value).toList();
    String allBoards = boards.join(",");

    await updateBoards(allBoards: allBoards);
    await getTasks();
  }

  Future<void> updateBoards(
      {String? newBoard, required String allBoards}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('taskBoards', allBoards);
    await getBoards(newBoard: newBoard);
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
