class Board {
  int? id;
  String title;
  int boardColorIdx; // index position in boardColors

  Board({
    this.id,
    required this.title,
    this.boardColorIdx = 0,
  });

  Board.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        boardColorIdx = map['boardColorIdx'];

  Map<String, dynamic> toMap() =>
      {'id': id, 'title': title, 'boardColorIdx': boardColorIdx};

  Map<String, dynamic> toTableMap() =>
      {'id': id, 'title': title, 'boardColorIdx': boardColorIdx};
}
