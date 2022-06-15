import 'package:flutter/material.dart';
import 'package:qbix/utils/api_keys.dart';
import 'package:qbix/utils/app_constants.dart';
import 'package:qbix/utils/methods.dart';

class Task {
  String id;
  String title;
  String description;
  String status;
  String parentId;
  String createdBy;
  DateTime createdAt;
  DateTime dueDate;
  List<SubTask> subTaskList;

  Task({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.status,
    @required this.parentId,
    @required this.createdBy,
    @required this.dueDate,
    @required this.createdAt,
    @required this.subTaskList,
  });

  int get totalDays {
    int total = 0;
    subTaskList.forEach((subTask) => total += subTask.daysRequired);
    return total;
  }

  factory Task.empty() => Task(
        id: "",
        title: "",
        description: "",
        createdBy: "",
        parentId: "",
        status: TaskStatus.ASSIGNED,
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        subTaskList: [],
      );

  factory Task.fromMap(Map data) {
    apiLogs("Task.fromMap Data : $data");
    try {
      return Task(
        id: data[APIKeys.id] ?? "",
        title: data[APIKeys.title] ?? "",
        description: data[APIKeys.description] ?? "",
        parentId: data[APIKeys.parentId] ?? "",
        createdBy: data[APIKeys.createdBy] ?? "",
        status: data[APIKeys.status] ?? TaskStatus.ASSIGNED,
        dueDate: toDateTimeFromString(data[APIKeys.date]) ?? Task.empty().dueDate,
        subTaskList: List.from(data[APIKeys.subTaskList] ?? List()).map((data) => SubTask.fromMap(data)).toList(),
        createdAt: toDateTimeFromString(data[APIKeys.createdAt]) ?? Task.empty().createdAt,
      );
    } catch (e, s) {
      apiLogs("Task.fromMap Exception : $e\n$s");
    }

    return Task.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.title: this.title,
        APIKeys.description: this.description,
        APIKeys.parentId: this.parentId,
        APIKeys.createdBy: this.createdBy,
        APIKeys.status: this.status,
        APIKeys.dueDate: dateSendFormatter.format(this.dueDate),
        APIKeys.createdAt: dateSendFormatter.format(this.createdAt),
        APIKeys.subTaskList: this.subTaskList.map((data) => data.toMap()).toList()
      };

  log() {
    apiLogs("=======Task=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class SubTask {
  String title;
  String description;
  bool status;
  int daysRequired;
  List<TaskDocument> taskDocumentList;

  SubTask({
    @required this.title,
    @required this.description,
    @required this.status,
    @required this.daysRequired,
    @required this.taskDocumentList,
  });

  factory SubTask.empty() => SubTask(
        title: "",
        description: "",
        status: false,
        daysRequired: 1,
        taskDocumentList: [],
      );

  factory SubTask.fromMap(Map data) {
    apiLogs("SubTask.fromMap Data : $data");
    try {
      return SubTask(
        title: data[APIKeys.title] ?? "",
        description: data[APIKeys.description] ?? "",
        status: data[APIKeys.status] ?? false,
        daysRequired: SubTask.empty().daysRequired,
        taskDocumentList:
            List.from(data[APIKeys.taskDocumentList] ?? List()).map((data) => TaskDocument.fromMap(data)).toList(),
      );
    } catch (e, s) {
      apiLogs("SubTask.fromMap Exception : $e\n$s");
    }

    return SubTask.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.title: this.title,
        APIKeys.description: this.description,
        APIKeys.status: this.status,
        APIKeys.daysRequired: this.daysRequired,
        APIKeys.taskDocumentList: this.taskDocumentList.map((data) => data.toMap()).toList()
      };

  log() {
    apiLogs("=======SubTask=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class TaskDocument {
  String title;
  String url;

  TaskDocument({
    @required this.title,
    @required this.url,
  });

  factory TaskDocument.empty() => TaskDocument(
        title: "",
        url: "",
      );

  factory TaskDocument.fromMap(Map data) {
    apiLogs("TaskDocument.fromMap Data : $data");
    try {
      return TaskDocument(
        title: data[APIKeys.title] ?? "",
        url: data[APIKeys.url] ?? "",
      );
    } catch (e, s) {
      apiLogs("TaskDocument.fromMap Exception : $e\n$s");
    }

    return TaskDocument.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.title: this.title,
        APIKeys.url: this.url,
      };

  log() {
    apiLogs("=======TaskDocument=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
