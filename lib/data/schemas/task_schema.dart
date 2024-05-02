import 'package:quickeydb/quickeydb.dart';
import 'package:tuduus/data/models/task.dart';

class TaskSchema extends DataAccessObject<Task> {
  TaskSchema()
      : super(
          '''
          CREATE TABLE tasks (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            boardName TEXT NOT NULL,
            description TEXT,
            priority INTEGER DEFAULT 0 NOT NULL,
            isComplete INTEGER DEFAULT 0 NOT NULL,
            isStarred INTEGER DEFAULT 0 NOT NULL,
            FOREIGN KEY (boardName) REFERENCES boards (title)
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
