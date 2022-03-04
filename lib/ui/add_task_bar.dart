import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_apps/controllers/task_controller.dart';
import 'package:to_do_apps/models/task.dart';
import 'package:to_do_apps/ui/theme.dart';
import 'package:to_do_apps/ui/widgets/button.dart';
import 'package:to_do_apps/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

//create stateful widget
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //task controller
  final TaskController _taskController = Get.put(TaskController());
  
  //text editing controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  //date
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "10:00 AM";

  //remind
  int _selectedRemind = 5;
  List<int> remindList=[
    5,
    10,
    15,
    20,
    25,
    30,
  ];

  //repeat
  String _selectedRepeat = "None";
  List<String> repeatList=[
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  //color
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
        body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   "Add Task",
                   style: headingStyle,
                 ),
                 MyInputField(title: "Title", hint: "Enter Your Title",controller: _titleController,),
                 MyInputField(title: "Note", hint: "Enter Your Note",controller: _noteController,),
                 MyInputField(title: 'Date', hint: DateFormat.yMd().format(_selectedDate),
                 widget:IconButton(
                    onPressed: () {
                       _getDateFromUser();
                    },
                     icon: Icon(Icons.calendar_today_outlined,
                      color: Colors.grey,
                     ),
                  ),
                 ),
                 Row(
                   children: [
                     Expanded(
                       child: MyInputField(
                         title: "Start Date",
                         hint: _startTime,
                         widget: IconButton(
                           onPressed: () {
                             _getTimeFromUser(isStartTime: true);
                           },
                           icon: Icon(
                             Icons.access_time_rounded,
                             color: Colors.grey,
                           ),
                         ),
                       ),
                     ),
                     SizedBox(width: 12,),
                     Expanded(
                       child: MyInputField(
                         title: "End Date",
                         hint: _endTime,
                         widget: IconButton(
                           onPressed: () {
                             _getTimeFromUser(isStartTime: false);
                           },
                           icon: Icon(
                             Icons.access_time_rounded,
                             color: Colors.grey,
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
                 MyInputField(title: "Remind", hint: "$_selectedRemind minutes early",
                   widget: DropdownButton(
                     onChanged: (String? newValue) {
                       setState(() {
                         _selectedRemind = int.parse(newValue!);
                       });
                     },
                     items: remindList.map<DropdownMenuItem<String>>((int value){
                       return DropdownMenuItem<String>(
                           value: value.toString(),
                           child: Text(value.toString()),
                          );
                        }
                     ).toList(),
                     icon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.grey,),
                     iconSize: 32,
                     elevation: 4,
                     style: subTitleStyle,
                     underline: Container(height: 0,),
                   ),
                 ),
                 MyInputField(title: "Repeat", hint: "$_selectedRepeat",
                    widget: DropdownButton(
                     onChanged: (String? newValue) {
                       setState(() {
                         _selectedRepeat = newValue!;
                       });
                     },
                    items: repeatList.map<DropdownMenuItem<String>>((String? value){
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value!, style:  TextStyle(color: Colors.grey)),
                       );
                    }).toList(),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey,),
                    iconSize: 32,
                    elevation: 4,
                    style: subTitleStyle,
                    underline: Container(height: 0,),

                 ),
                 ),
                 SizedBox(height: 10.0,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     _colorPallete(),
                     //Create Task Button
                     MyButton(label: "Create Task", onTap: ()=>_validateDate()),
                   ],
                 ),
               ],
            ),
          ),
        ),
    );
  }

  //_appBar method
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      //to click
      //change the theme dark mode
      leading: GestureDetector(
        onTap: () {
         Get.back();
        },
        child: Icon(
          Icons.arrow_back,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      //when user clicked
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
            "images/admin.png",
          ),
        ),
        SizedBox(width: 20,),
      ],

    );
  }

  //getDateFromUser method
  _getDateFromUser() async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),//current date
        //this is the range first and last date for user to choose
        firstDate: DateTime(2010),  //start from tahun 2010
        lastDate: DateTime(2300) //end tahun 2300
    );

    if (_pickerDate != null){
      //set it back to input form with setState
      setState(() {
        _selectedDate = _pickerDate;
      });

    }else{
      print("error!");
    }
  }

  //getTimeFromUser method
  _getTimeFromUser ( {required bool isStartTime} ) async{
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);  //return to string of date

     if(pickedTime == null){
       print("Time Cancel");
     } else if(isStartTime == true){
         setState(() {
           _startTime = _formatedTime;
         });
     } else if(isStartTime == false){
         setState(() {
           _endTime = _formatedTime;
         });
     }
  }

  //return the show time picker
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        //_startTime -> 10:30 AM
          hour: int.parse(_startTime.split(":")[0]), //taking index 0
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])  //taking index 1 and split with taking index 0
      )
    );
  }

  //colorPallete method
  _colorPallete(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Color",style:titleStyle,),
          SizedBox(height: 8.0,),
          //to put in horizontal line, use the Wrap
          Wrap(
            children: List<Widget>.generate(
                3, //3 colors for widget in dynamic
                    (int index){
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor=index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        radius: 14,
                        //if index 0, use primaryClr, else if index 1,use pinkClr,else use yellowClr
                        backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                        child: _selectedColor==index?Icon(Icons.done
                          ,color: Colors.white,
                          size: 16,
                        ):Container(),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      );
  }

   //validateDate method
   _validateDate() {
         if(_titleController.text.isNotEmpty&&_noteController.text.isNotEmpty){
           //add to database by calling _addTasktoDb method
           _addTasktoDb();

           //go back to previous page
           Get.back();
         }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
           Get.snackbar("Required", "All form are required! ",
             snackPosition: SnackPosition.BOTTOM,
             backgroundColor: Colors.white,
             icon: Icon(Icons.warning_amber_rounded,color: Colors.red,),
             colorText: Colors.red,
           );
         }
   }

   //_addTasktoDb method
   _addTasktoDb() async {
     await _taskController.addTask(
        task: Task(
          title: _titleController.text,
          note: _noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          remind: _selectedRemind,
          repeat: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0,
        ),
    );

  }
}
