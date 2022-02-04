import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/screens/add_task_bar.dart';
import 'package:to_do_app/screens/theme.dart';
import 'package:to_do_app/screens/widgets/button.dart';
import 'package:to_do_app/screens/widgets/taskTile.dart';
import 'package:to_do_app/services/notification_services.dart';
import 'package:to_do_app/services/themeServices.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(
            height: 5,
          ),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
        itemCount: _taskController.taskList.length,
        itemBuilder: (_, index) {
          print(_taskController.taskList.length);
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showBottomSheet(
                            context, _taskController.taskList[index]);
                      },
                      child: TaskTile(_taskController.taskList[index]),
                    ),
                  ],
                ),
              ),
            ),
          );

          //  Container(
          //   height: 100,
          //   width: 50,
          //   color: Colors.indigo,
          //   margin: const EdgeInsets.only(bottom: 10),
          //   child: Text(_taskController.taskList[index].title.toString()),
          // );
        },
      );
    }));
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        color: Get.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      child: Container(
        margin: const EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.indigo,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: Colors.grey),
          ),
          onDateChange: (date) {
            _selectedDate = date;
          },
          // deactivatedColor: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: HeadingStyle,
                ),
              ],
            ),
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.to(() => AddTaskPAge());
              _taskController.getTasks();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Activated DarkTheme"
                  : "Activated light theme");
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Icon(
          Icons.person,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
