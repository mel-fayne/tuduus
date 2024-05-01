class Board {
  int? id;
  String title;

  Board({
    this.id,
    required this.title,
  });

  Board.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'];

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'title': title,
      };
}
