import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_apps/models/task.dart';
import 'package:timezone/src/location_database.dart';
import 'package:to_do_apps/ui/notified_page.dart';

class NotifyHelper {
  //initialize flutter notifcations plugin class/instance
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin(); //

  //method to be called in main.dart

  //in IOS
  initializeNotification() async {
    _configureLocalTimeZone();
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(  //in IOS
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification //call method to get the dialog
    );

    //Request permissions for IOS
    // void requestIOSPermissions() {
    //   flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //       IOSFlutterLocalNotificationsPlugin>()
    //       ?.requestPermissions(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
    // }

    //in android
    final AndroidInitializationSettings initializationSettingsAndroid =
     AndroidInitializationSettings('appicon');

      final InitializationSettings initializationSettings =
      InitializationSettings(
      iOS: initializationSettingsIOS,
      android:initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

  }

  Future onDidReceiveLocalNotification(
      // put '?' to tell compiler that it is null for future
      //so  onDidReceiveLocalNotification: onDidReceiveLocalNotification no error
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   //context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
      Get.dialog(Text("Welcome to To Do App"));
  }

  //on tap select notification
  Future selectNotification(String? payload) async {
    if (payload != null) {
      //selectedNotificationPayload = "The best";
      //selectNotificationSubject.add(payload);
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }

    if(payload == "Theme Changed"){
       print("Nothing to navigate");
    }else {
      Get.to(() => NotifiedPage(label: payload));  //direct to notified page
    }


  }

  //immediate notification or display notification
  displayNotification({required String title, required String body}) async {
    print("MODE CHANGED!!");
    var  androidPlatformChannelSpecifics =  new AndroidNotificationDetails(
        'your channel id', 'your channel name', //for android 8.0 higher..but no need description
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  //schedule notifications
  scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _convertTime(hour,minutes),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name')),  //for android 8.0 higher..but no need description
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|"+"${task.note}|"+"${task.startTime}|", //go to notified page

    );

  }

  //convertTime method
  tz.TZDateTime _convertTime(int hour, int minutes){
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);

      if(scheduleDate.isBefore(now)){
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      }
      return scheduleDate;

  }

  //configure local time zone method
  Future<void> _configureLocalTimeZone() async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

}

