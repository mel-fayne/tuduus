class Task {
  int? id;
  String title;
  String? description;
  String board;
  int priority;
  bool isComplete;

  Task({
    this.id,
    required this.title,
    required this.board,
    this.description,
    this.priority = 0,
    this.isComplete = false,
  });

  Task.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        board = map['board'],
        priority = map['priority'],
        isComplete = map['isComplete'] == 0 ? false : true;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'board': board,
        'priority': priority,
        'isComplete': isComplete == false ? 0 : 1,
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'title': title,
        'description': description,
        'board': board,
        'priority': priority,
        'isComplete': isComplete == false ? 0 : 1,
      };
}
