import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/controllers/task_controller.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/screens/theme.dart';
import 'package:to_do_app/screens/widgets/button.dart';
import 'package:to_do_app/screens/widgets/inputField.dart';
import 'package:to_do_app/services/themeServices.dart';

class AddTaskPAge extends StatefulWidget {
  const AddTaskPAge({Key? key}) : super(key: key);

  @override
  State<AddTaskPAge> createState() => _AddTaskPAgeState();
}

class _AddTaskPAgeState extends State<AddTaskPAge> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endtime = '10:00 PM';
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  int _selectedColor = 0;

  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add task",
                style: HeadingStyle,
              ),
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteController,
              ),
              InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                      onPressed: () {
                        _getDatefromUser();
                      },
                      icon: Icon(Icons.calendar_today_rounded))),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                    title: "Start Date",
                    hint: _startTime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTIme: true);
                        },
                        icon: Icon(Icons.access_time_rounded)),
                  )),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: InputField(
                    title: "End Date",
                    hint: _endtime,
                    widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTIme: false);
                        },
                        icon: Icon(Icons.access_time_rounded)),
                  )),
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  elevation: 4,
                  iconSize: 30,
                  underline: Container(
                    height: 0,
                  ),
                ),
              ),
              InputField(
                title: "Repeat",
                hint: "$_selectedRepeat",
                widget: DropdownButton(
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  elevation: 4,
                  iconSize: 30,
                  underline: Container(
                    height: 0,
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(label: "Create Task", onTap: () => _validateData())
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      //add to db
      _addTasktoDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', "All fields are required !",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.red,
          icon: Icon(
            Icons.warning,
            color: Colors.red,
          ));
    }
  }

  _addTasktoDb() async {
    int value = await _taskController.addTask(
        task: Task(
      date: DateFormat.yMd().format(_selectedDate),
      title: _titleController.text,
      note: _noteController.text,
      startTime: _startTime,
      endTime: _endtime,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      isCompleted: 0,
    ));
    print("My id is " + " $value");
  }

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color"),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                  radius: 14,
                  backgroundColor: index == 0
                      ? Colors.blue
                      : index == 1
                          ? Colors.red
                          : Colors.yellow,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getTimeFromUser({required bool isStartTIme}) async {
    var pickedTime = await _ShowTimePicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('time canceled');
    } else if (isStartTIme == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTIme == false) {
      setState(() {
        _endtime = _formatedTime;
      });
    }
  }

  _ShowTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(' ')[0]),
        ));
  }

  _getDatefromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2121));
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      print('null');
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
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
        const SizedBox(
          width: 10,
        )
      ],
    );
  }
}
