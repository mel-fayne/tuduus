import 'package:activity/activity.dart';
import 'package:quickeydb/quickeydb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuduus/data/models/board.dart';
import 'package:tuduus/data/schemas/board_schema.dart';
import 'package:tuduus/data/schemas/task_schema.dart';
import 'package:tuduus/data/models/task.dart';

import '../utils/constants.dart';

class MainController extends ActiveController {
  /// This override is needed
  @override
  List<ActiveType> get activities {
    return [];
  }

  ActiveType<Board> currentBoard = ActiveType(Board(title: defaultBoard));
  ActiveType<List<Board>> taskBoards = ActiveType([]);
  ActiveType<List<String>> taskBoardNames = ActiveType([]);
  ActiveType<List<Task>> completeTasks = ActiveType([]);
  ActiveType<List<Task>> inCompleteTasks = ActiveType([]);
  ActiveString selectedPriority = ActiveString('All');
  ActiveBool isDesc = ActiveBool(true);
  ActiveString userName = ActiveString('');

  Future<void> homeInit() async {
    await getUserDetails();
    await getBoards();
    await getTasks();
    notifyActivities([]);
  }

  // --------- TASKS

  Future<void> getTasks() async {
    String sortOrder = isDesc.value ? 'DESC' : 'ASC';
    final Map<String, dynamic> fetchQuery = {
      'boardName == ?': currentBoard.value.title
    };
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
          boardName: newTask.boardName,
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

  Future<Board> getBoard(String boardName) async {
    Board? board = await QuickeyDB.getInstance!<BoardSchema>()!
        .where({'title == ?': boardName}).first;
    return board ?? Board(title: defaultBoard);
  }

  // --------- TASK BOARDS

  Future<void> getBoards({String? newBoardName}) async {
    var boards = await QuickeyDB.getInstance!<BoardSchema>()!.all;
    boards = boards.where((board) => board != null).cast<Board>().toList();

    taskBoards = ActiveType(
        boards.where((board) => board != null).cast<Board>().toList());
    taskBoardNames = ActiveType(taskBoards.value.map((e) => e.title).toList());
    var currBoard = newBoardName == null
        ? boards[0]
        : await QuickeyDB.getInstance!<BoardSchema>()!
            .where({'title == ?': newBoardName}).first;
    currentBoard = ActiveType(currBoard!);
  }

  Future<void> createTaskBoard(Board newBoard) async {
    await QuickeyDB.getInstance!<BoardSchema>()?.create(
      Board(title: newBoard.title),
    );
    await getBoards(newBoardName: newBoard.title);
    await getTasks();
  }

  Future<void> updateTaskBoard(Board newBoard) async {
    // update all tasks in this board
    var batch = QuickeyDB.getInstance!.database!.batch();
    batch.update('tasks', {'boardName': newBoard.title},
        where: 'boardName = ?', whereArgs: [currentBoard.value.title]);
    await batch.commit();
    // update board
    newBoard.id = currentBoard.value.id;
    await QuickeyDB.getInstance!<BoardSchema>()!.update(newBoard);
    await getBoards(newBoardName: newBoard.title);
    await getTasks();
  }

  Future<void> deleteTaskBoard() async {
    // delete all tasks in this board
    var batch = QuickeyDB.getInstance!.database!.batch();
    batch.delete('tasks',
        where: 'boardName = ?', whereArgs: [currentBoard.value.title]);
    await batch.commit();
    // delete board
    await QuickeyDB.getInstance!<BoardSchema>()!.delete(currentBoard.value);
    await getBoards();
    await getTasks();
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
