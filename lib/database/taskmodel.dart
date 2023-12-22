class Task {
  int? TaskId;
  String? title;
  String? description;
  String? event;
  String? date;


  Task({
    required this.TaskId,
    required this.title,
    required this.description,
    required this.event,
    required this.date,
  });

  factory Task.fromSQLite(Map map) {
    return Task(
      TaskId: map['TaskId'],
      title: map['title'],
      description: map['description'],
      event: map['event'],
      date: map['DateTime'],
    );
  }

  static List<Task> fromSQLiteList(List<Map> listMap) {
    List<Task> users = [];
    for (Map item in listMap) {
      users.add(Task.fromSQLite(item));
    }
    return users;
  }


  factory Task.empty() {
    return Task(TaskId: null, title: '', description: '', event: '', date: null);
  }
}