class User {
  int? UserId;
  String? UserName;
  String? Gender;
  String? Email;
  String? PhoneNo;
  String? ImagePath;


  User({
    required this.UserId,
    required this.UserName,
    required this.Gender,
    required this.Email,
    required this.PhoneNo,
    required this.ImagePath,
  });

  factory User.fromSQLite(Map map) {
    return User(
        UserId: map['UserId'],
        UserName: map['UserName'],
        Gender: map['Gender'],
        Email: map['Email'],
        PhoneNo: map['PhoneNo'],
        ImagePath: map['ImagePat'],
    );
  }

  static List<User> fromSQLiteList(List<Map> listMap) {
    List<User> users = [];
    for (Map item in listMap) {
      users.add(User.fromSQLite(item));
    }
    return users;
  }


  factory User.empty() {
    return User(UserId: null, UserName: '', Gender: '', Email: '', PhoneNo: '', ImagePath: '');
  }
}