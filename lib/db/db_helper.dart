import 'package:sqflite/sqflite.dart';
import 'package:to_do_apps/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks"; //database name

  //init method
  static Future<void> initDb() async {
     if(_db != null) {
       return;
     }

     //try and catch if there are some errors
     try {
        String _path = await getDatabasesPath() + 'tasks.db'; //database_name.db
       _db = await openDatabase(
         _path,
         version: _version,
         onCreate: (db, version) {
           print("Create a new table");
           return db.execute(
             //create a table
             "CREATE TABLE $_tableName("
                 "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                 "title STRING,note TEXT,date STRING, "
                 "startTime STRING, endTime STRING, "
                 "remind INTEGER, repeat STRING, "
                 "color INTEGER, "
                 "isCompleted INTEGER)",
           );
         }
       );
     }catch(e){
       print(e);
     }
  }

  //method to call in task_controller.dart
  static Future<int> insert(Task? task) async {
       return await _db?.insert(_tableName, task!.toJson())??1;
  }

  //get the data
  static Future<List<Map<String, dynamic>>> query() async{
     return await _db!.query(_tableName);
  }

  //for delete data
   static delete(Task task) async{
    //get where the id to be deleted
     return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
   }

   //for update data to be completed
   static update(int id) async{
    //must have 3 single quotes
    return await _db!.rawUpdate('''  
        UPDATE tasks 
        SET isCompleted = ?
        WHERE id=?
    ''', [1, id]);
   }
}