import 'package:quickeydb/quickeydb.dart';
import 'package:tuduus/data/models/board.dart';

class BoardSchema extends DataAccessObject<Board> {
  BoardSchema()
      : super(
          '''
          CREATE TABLE boards (
            id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL
          );
          ''',
          relations: [],
          converter: Converter(
            encode: (board) => Board.fromMap(board),
            decode: (board) => board!.toMap(),
            decodeTable: (board) => board!.toTableMap(),
          ),
        );
}
