class Chapter {
  int? ChapterId;
  String? Name;
  String? Description;


  Chapter({
    required this.ChapterId,
    required this.Name,
    required this.Description,
  });

  factory Chapter.fromSQLite(Map map) {
    return Chapter(
      ChapterId: map['ChapterId'],
      Name: map['Name'],
      Description: map['Description']
    );
  }

  static List<Chapter> fromSQLiteList(List<Map> listMap) {
    List<Chapter> chapters = [];
    for (Map item in listMap) {
      chapters.add(Chapter.fromSQLite(item));
    }
    return chapters;
  }


  factory Chapter.empty() {
    return Chapter(ChapterId: null, Name: '', Description: '');
  }
}