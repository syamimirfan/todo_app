import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_apps/db/db_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:to_do_apps/models/task.dart';

//inherit GetxController
class TaskController extends GetxController {

  final RxList<Task> taskList = List<Task>.empty().obs;

  @override
  void onReady(){
    super.onReady();
  }

  //method to wrap
   Future<void> addTask({required Task task}) async{
      await DBHelper.insert(task);
  }

  //get all the data from table
   void getTasks() async {
    List<Map<String,dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
 }

   //delete task
   void delete(Task task){
       DBHelper.delete(task);
       getTasks();
   }

   //update task
   void markTaskCompleted(int id) async{
       await DBHelper.update(id);
       getTasks();
   }
}