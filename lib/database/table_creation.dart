import 'package:noteverse/database/remindermodel.dart';
import 'package:noteverse/database/taskmodel.dart';
import 'package:noteverse/database/usermodel.dart';
import 'chaptermodel.dart';
import 'notemodel.dart';

class UserTableCreate {
  static const CREATE_TABLE = '''
        CREATE TABLE User (
          UserId INTEGER PRIMARY KEY AUTOINCREMENT,
          UserName VARCHAR(100) ,
          Gender VARCHAR(10) ,
          Email VARCHAR(50) ,
          PhoneNo VARCHAR(10) ,
          ImagePath TEXT NULL
        )
        ''';

  static String selectallusers() {
    return 'select * from User;';
  }

  static String adduser(User x) {
    return '''
    insert into User (UserName,Gender,Email,PhoneNo,ImagePath)
    values (
            '${x.UserName}',
            '${x.Gender}',
            '${x.Email}',
            '${x.PhoneNo}',
            '${x.ImagePath}'
    );
    ''';
  }

  static String updateuser(User x) {
    return '''
    UPDATE User
    SET UserName = '${x.UserName}',
    WHERE UserId = ${x.UserId};
    ''';
  }
}

class ChapterTableCreate {
  static final CREATE_TABLE = '''
        CREATE TABLE Chapter (
          ChapterId INTEGER PRIMARY KEY AUTOINCREMENT,
          Name VARCHAR(100) UNIQUE,
          Description TEXT NULL
        )
        ''';

  static String selectallchapters() {
    return 'select * from Chapter;';
  }

  static String addchapter(Chapter x) {
    return '''
    insert into Chapter (Name,Description)
    values ('${x.Name}',
            '${x.Description}'
    );
    ''';
  }

  static String updatechap(Chapter x) {
    return '''
    UPDATE Chapter
    SET Name = '${x.Name}',
    Description = '${x.Description}'
    WHERE ChapterId = ${x.ChapterId};
    ''';
  }
}

class NoteTableCreate {
  static final CREATE_TABLE = '''
        CREATE TABLE Note (
          NoteId INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(100),
          content TEXT ,
          ChapterId INTEGER,
          FOREIGN KEY(ChapterId) REFERENCES Chapter(ChapterId)
        )
        ''';
  static String addnote(Note x) {
    return '''
    insert into Note (title,content,ChapterId)
    values (
            '${x.title}',
            '${x.content}',
            '${x.ChapterId}'
    );
    ''';
  }
  static String selectallnotes() {
    return 'select * from Note;';
  }
  static String updatenot(Note x) {
    return '''
    UPDATE Note
    SET title = '${x.title}',
    content = '${x.content}',
    ChapterId = ${x.ChapterId}
    WHERE NoteId = ${x.NoteId};
    ''';
  }
}

class TaskTableCreate {
  static const CREATE_TABLE = '''
        CREATE TABLE Task (
          TaskId INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(100),
          description TEXT NULL,
          DateTime DATETIME,
          event VARCHAR(100)
        )
        ''';

  static String selectall() {
    return 'select * from Task;';
  }

  static String addtask(Task x) {
    return '''
    insert into Task (title,description,DateTime,event)
    values ('${x.title}',
            '${x.description}',
            '${x.date}',
            '${x.event}'
    );
    ''';
  }

  static String updatetask(Task x) {
    return '''
    UPDATE Task
    SET title = '${x.title}',
    description = '${x.description}',
    DateTime = '${x.date}',
    event = '${x.event}'
    WHERE TaskId = ${x.TaskId};
    ''';
  }
}

class ReminderTableCreate {
  static const CREATE_TABLE = '''
        CREATE TABLE Reminder (
          ReminderId INTEGER PRIMARY KEY AUTOINCREMENT,
          title VARCHAR(100),
          description TEXT NULL,
          DateTime DATETIME,
          event VARCHAR(100)
        )
        ''';
  static String selectall() {
    return 'select * from Reminder;';
  }
  static String add(Reminder x) {
    return '''
    insert into Reminder (title,description,DateTime,event)
    values ('${x.title}',
            '${x.description}',
            '${x.date}',
            '${x.event}'
    );
    ''';
  }

  static String update(Reminder x) {
    return '''
    UPDATE Reminder
    SET title = '${x.title}',
    description = '${x.description}',
    DateTime = '${x.date}',
    event = '${x.event}'
    WHERE ReminderId = ${x.ReminderId};
    ''';
  }
}


