class Note {
  int? NoteId;
  String? title;
  String? content;
  String? ChapterId;


  Note({
    required this.NoteId,
    required this.title,
    required this.content,
    required this.ChapterId
  });

  factory Note.fromSQLite(Map map) {
    return Note(
        NoteId: map['NoteId'],
        title: map['title'],
        content: map['content'],
        ChapterId: map['ChapterId'].toString()
    );
  }

  static List<Note> fromSQLiteList(List<Map> listMap) {
    List<Note> notes = [];
    for (Map item in listMap) {
      notes.add(Note.fromSQLite(item));
    }
    return notes;
  }

  Map<String, dynamic> toMap() {
    return {
      'NoteId': NoteId,
      'title' : title,
      'content': content,
      'ChapterId' : ChapterId
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(NoteId: map['NoteId'], title: map['title'], content: map['content'], ChapterId: map['ChapterId']);
  }

  factory Note.empty() {
    return Note(NoteId: null, title: '', content: '', ChapterId: '');
  }
}