class Reminder {
  int? ReminderId;
  String? title;
  String? description;
  String? event;
  String? date;


  Reminder({
    required this.ReminderId,
    required this.title,
    required this.description,
    required this.event,
    required this.date,
  });

  factory Reminder.fromSQLite(Map map) {
    return Reminder(
      ReminderId: map['TaskId'],
      title: map['title'],
      description: map['description'],
      event: map['event'],
      date: map['DateTime'],
    );
  }

  static List<Reminder> fromSQLiteList(List<Map> listMap) {
    List<Reminder> users = [];
    for (Map item in listMap) {
      users.add(Reminder.fromSQLite(item));
    }
    return users;
  }


  factory Reminder.empty() {
    return Reminder(ReminderId: null, title: '', description: '', date: null, event: '');
  }
}