class Task {
  int? id;
  String? boardName;
  String title;
  String? description;
  int priority;
  bool isComplete;
  bool isStarred;

  Task({
    this.id,
    required this.title,
    this.boardName,
    this.description,
    this.priority = 0,
    this.isComplete = false,
    this.isStarred = false,
  });

  Task.fromMap(Map<String?, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        boardName = map['boardName'],
        priority = map['priority'],
        isComplete = map['isComplete'] == 0 ? false : true,
        isStarred = map['isStarred'] == 0 ? false : true;

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'boardName': boardName,
        'priority': priority,
        'isComplete': isComplete == false ? 0 : 1,
        'isStarred': isStarred == false ? 0 : 1,
      };

  Map<String, dynamic> toTableMap() => {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'boardName': boardName,
        'isComplete': isComplete == false ? 0 : 1,
        'isStarred': isStarred == false ? 0 : 1,
      };
}
