import 'package:flutter/material.dart';

class Task {
   int? id;
   String? title;
   String? note;
   int? isCompleted;
   String? date;
   String? startTime;
   String? endTime;
   int? color;
   int? remind;
   String? repeat;

   //constructor with named parameter
   Task ({
     this.id,
     this.title,
     this.note,
     this.isCompleted,
     this.date,
     this.startTime,
     this.endTime,
     this.color,
     this.remind,
     this.repeat
     });

   //dynamic map string fromJson method
    Task.fromJson(Map<String, dynamic> json){
      id = json['id'];
      title = json['title'];
      note = json['note'];
      isCompleted = json['isCompleted'];
      date = json['date'];
      startTime = json['startTime'];
      endTime = json['endTime'];
      color = json['color'];
      remind = json['remind'];
      repeat = json['repeat'];
  }

   //mapping
   //convert toJson method
    Map<String, dynamic> toJson()  {
      //create an instance for mapping Map<String , dynamic>
      final Map<String, dynamic> data = new Map<String, dynamic>();

      //in json
      //  {
      //  "key": "value";
      //  }
      data['id'] = this.id;
      data['title'] = this.title;
      data['note'] = this.note;
      data['date'] = this.date;
      data['isCompleted'] = this.isCompleted;
      data['startTime'] = this.startTime;
      data['endTime'] = this.endTime;
      data['color'] = this.color;
      data['remind'] = this.remind;
      data['repeat'] = this.repeat;
      return data;
    }


}