import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:tuduus/main_controller.dart';

class HomeView extends ActiveView<MainController> {
  static const routeName = "/home";
  const HomeView({super.key, required super.activeController});

  @override
  ActiveState<ActiveView<ActiveController>, MainController> createActivity() =>
      _HomeViewState(activeController);
}

class _HomeViewState extends ActiveState<HomeView, MainController> {
  _HomeViewState(super.activeController);

  @override
  void initState() {
    super.initState();
    activeController.homeInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeController.isLoading.value
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
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
                        fontSize: 42),
                  ),
                  Text(
                    "You can get it done today!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Create Board'))
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton<String>(
                      value: activeController.currentBoard.value,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      elevation: 4,
                      underline: Container(),
                      onChanged: (String? newValue) {},
                      items: activeController.taskBoardNames.value
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
