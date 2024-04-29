import 'package:activity/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends ActiveController {
  /// This override is needed
  @override
  List<ActiveType> get activities {
    return [];
  }

  ActiveString userName = ActiveString('');
  ActiveString currentBoard = ActiveString('ToDo');
  ActiveType<List<String>> taskBoardNames = ActiveType([]);
  ActiveBool isLoading = ActiveBool(false);

  Future<void> homeInit() async {
    await getUserName();
    await getTasks();
    notifyActivities([]);
  }

  // ********** tasks
  Future<void> getTasks() async {
    isLoading = ActiveBool(true);
    isLoading.set(true);

    List<String> taskBoards = ['ToDo'];
    taskBoardNames = ActiveType(taskBoards);
    taskBoardNames.set(taskBoards);

    isLoading = ActiveBool(false);
    isLoading.set(false, notifyChange: true, setAsOriginal: true);
  }

  // ********** onboarding

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('userName') ?? '';
    userName = ActiveString(name);
    userName.set(name);
  }

  Future<void> handleOnboard(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setBool('isOnboarded', true);
  }
}
