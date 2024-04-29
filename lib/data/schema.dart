import 'package:quickeydb/quickeydb.dart';
import 'package:tuduus/data/task.dart';

class TaskSchema extends DataAccessObject<Task> {
  TaskSchema()
      : super(
          '''
          CREATE TABLE tasks (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            board TEXT NOT NULL,
            priority INTEGER DEFAULT 0 NOT NULL,
            isComplete INTEGER DEFAULT 0 NOT NULL
          );
          ''',
          relations: [],
          converter: Converter(
            encode: (task) => Task.fromMap(task),
            decode: (task) => task!.toMap(),
            decodeTable: (task) => task!.toTableMap(),
          ),
        );
}
