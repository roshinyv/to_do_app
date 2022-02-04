import 'package:get/get.dart';
import 'package:to_do_app/db/db_services.dart';
import 'package:to_do_app/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DbServices.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DbServices.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DbServices.delete(task);
  }
}
