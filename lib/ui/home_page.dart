import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_apps/controllers/task_controller.dart';
import 'package:to_do_apps/models/task.dart';
import 'package:to_do_apps/services/notification_services.dart';
import 'package:to_do_apps/services/theme_services.dart';
import 'package:to_do_apps/ui/add_task_bar.dart';
import 'package:to_do_apps/ui/theme.dart';
import 'package:to_do_apps/ui/widgets/button.dart';
import 'package:to_do_apps/ui/widgets/task_tile.dart';

//create a stateful widgets
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState(){
    //TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    //notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
         _addTaskBar(),
         _addDateBar(),
          SizedBox(height: 10,),
          _showTasks(),
        ],
      ),
    );
  }

  //adddatebar method
  _addDateBar(){
    return  Container(
      margin: const EdgeInsets.only(top: 20),
      //make a calendar to choose
      child: DatePicker(
        DateTime.now(),
        height:100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dayTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        dateTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        monthTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey
          ),
        ),
        onDateChange: (date){
          setState(() {
            _selectedDate=date;
          });
        },
      ),
    );
  }


  //addtaskbar method
  _addTaskBar(){
   return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( DateFormat.yMMMMd().format(DateTime.now()), //return string in data month date and year
                  style:subHeadingStyle ,
                ),
                Text("Today",
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap: () async {
              await Get.to(()=>AddTaskPage());
              //after wait it will return all the list of task
              _taskController.getTasks();
           }
          )
        ],
      ),
    );
  }

  //_appBar method
  _appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      //to click
      //change the theme dark mode
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body: Get.isDarkMode?"Activated Light Mode":"Activated Dark Mode"
          );
         // notifyHelper.scheduledNotification();
        },
        child: Icon(
            Get.isDarkMode?Icons.wb_sunny_outlined:Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white:Colors.black),
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

  //_showTask method to show all task from database
  _showTasks(){
     return Expanded(
       //special feature in Getx, Obx function
         child: Obx(() {
            return ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (_, index) {
                  //create instance of task
                  Task task = _taskController.taskList[index];
                  //print(task.toJson());
                  if(task.repeat=='Daily')  {
                    //convert it to string
                      DateTime date = DateFormat.jm().parse(task.startTime.toString());
                      var myTime = DateFormat("HH:mm").format(date);
                      notifyHelper.scheduledNotification(
                        int.parse(myTime.toString().split(":")[0]),
                        int.parse(myTime.toString().split(":")[1]),
                        task
                      );
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if(task.date==DateFormat.yMd().format(_selectedDate)){
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, task);
                                },
                                child: TaskTile(task),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  } else{
                    return Container(); //empty container
                  }
                });
         }),
     );
  }

  //_showBottomSheet() method
  _showBottomSheet(BuildContext, Task task){
     Get.bottomSheet(
        Container(
          padding: const EdgeInsets.only(top: 4),
          height: task.isCompleted==1?
          MediaQuery.of(context).size.height*0.24:   //if task is completed its only have 0.24 height
          MediaQuery.of(context).size.height*0.32 ,//if task is not completed its only have 0.32 height
          color: Get.isDarkMode?darkGreyClr:Colors.white,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode?Colors.grey[600]:Colors.grey,
                ),
              ),
              Spacer(),
              task.isCompleted==1?  //if task is not completed
                  Container(): _bottomSheetButton(
                label: "Task Completed",
                onTap: (){
                  _taskController.markTaskCompleted(task.id!);
                  Get.back();
                },
                clr: primaryClr,
                context: context,
              ),
              SizedBox(height:10,),
              _bottomSheetButton(
                  label: "Delete Task",
                  onTap: () {
                    _taskController.delete(task);
                    //get the query back for delete automatically
                    _taskController.getTasks();
                    Get.back();
                  },
                  clr: Colors.red[400]!,
                  context: context,
              ),
              SizedBox(height: 30,),
              _bottomSheetButton(
                  label: "Close",
                  onTap: () {
                    Get.back();
                  },
                  clr: Colors.white,
                  isClose: true,
                  context: context,
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
     );
  }

  //_bottomSheetButton method for Task Completed, Delete Task and Close
  _bottomSheetButton( {
    required String label,required Function() onTap, required Color clr, bool isClose=false,
    required BuildContext context,
  }){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.height*0.45,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose==true?Get.isDarkMode?Colors.grey[600]!:Colors.grey[400]!:clr, //for close button
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose==true?Colors.transparent:clr,  //for close button
        ),
        child: Center(
          child: Text(
              label,
            style: isClose?titleStyle:titleStyle.copyWith(fontWeight: FontWeight.bold).copyWith(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
 }

}
