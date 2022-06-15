import 'package:flutter/material.dart';
import 'package:qbix/utils/api_keys.dart';
import 'package:qbix/utils/app_constants.dart';
import 'package:qbix/utils/methods.dart';

class Event {
  String id;
  String eventName;
  String place;
  String eventDescription;
  String startTime;
  String endTime;
  String eventType;
  String studentId;
  int seats;
  int enrollCount;
  int attendCount;
  DateTime date;
  bool attended;

  Event({
    @required this.date,
    @required this.id,
    @required this.eventName,
    @required this.place,
    @required this.eventDescription,
    @required this.startTime,
    @required this.endTime,
    @required this.eventType,
    @required this.seats,
    @required this.enrollCount,
    @required this.attendCount,
    @required this.studentId,
    @required this.attended,
  });

  factory Event.empty() => Event(
        id: "",
        eventName: "",
        place: "",
        eventDescription: "",
        studentId: "",
        startTime: "",
        endTime: "",
        eventType: "",
        seats: 0,
        enrollCount: 0,
        attendCount: 0,
        date: DateTime.now(),
        attended: false,
      );

  factory Event.fromMap(Map data) {
    apiLogs("Event.fromMap Data : $data");
    try {
      return Event(
        id: data[APIKeys.id] ?? "",
        eventName: data[APIKeys.eventName] ?? "",
        place: data[APIKeys.place] ?? "",
        eventDescription: data[APIKeys.eventDescription] ?? "",
        startTime: data[APIKeys.startTime] ?? "",
        endTime: data[APIKeys.endTime] ?? "",
        eventType: data[APIKeys.eventType] ?? "",
        studentId: data[APIKeys.studentId] ?? "",
        seats: data[APIKeys.seats] ?? 0,
        attended: data[APIKeys.attended] ?? false,
        enrollCount: data[APIKeys.enrollCount] ?? 0,
        attendCount: data[APIKeys.attendCount] ?? 0,
        date: toDateTimeFromString(data[APIKeys.date]) ?? Event.empty().date,
      );
    } catch (e, s) {
      apiLogs("Event.fromMap Exception : $e\n$s");
    }

    return Event.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.eventName: this.eventName,
        APIKeys.place: this.place,
        APIKeys.studentId: this.studentId,
        APIKeys.eventDescription: this.eventDescription,
        APIKeys.startTime: this.startTime,
        APIKeys.endTime: this.endTime,
        APIKeys.eventType: this.eventType,
        APIKeys.seats: this.seats,
        APIKeys.attended: this.attended,
        APIKeys.enrollCount: this.enrollCount,
        APIKeys.attendCount: this.attendCount,
        APIKeys.date: dateSendFormatter.format(this.date),
      };

  log() {
    apiLogs("=======Event=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class EventType {
  String eventName;
  String eventDescription;
  int maxEnrollCount;

  EventType({
    @required this.eventName,
    @required this.eventDescription,
    @required this.maxEnrollCount,
  });

  factory EventType.empty() => EventType(
        eventName: "",
        eventDescription: "",
        maxEnrollCount: 0,
      );

  factory EventType.fromMap(Map data) {
    apiLogs("EventType.fromMap Data : $data");
    try {
      return EventType(
        eventName: data[APIKeys.eventName] ?? "",
        eventDescription: data[APIKeys.eventDescription] ?? "",
        maxEnrollCount: data[APIKeys.maxEnrollCount] ?? 0,
      );
    } catch (e, s) {
      apiLogs("EventType.fromMap Exception : $e\n$s");
    }

    return EventType.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.eventName: this.eventName,
        APIKeys.eventDescription: this.eventDescription,
        APIKeys.maxEnrollCount: this.maxEnrollCount,
      };

  log() {
    apiLogs("=======EventType=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class EventStudent {
  String studentId;
  String name;
  String emailId;
  String mobileNumber;
  DateTime createdAt;
  DateTime updatedAt;
  bool attended;

  EventStudent({
    @required this.studentId,
    @required this.name,
    @required this.emailId,
    @required this.mobileNumber,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.attended,
  });

  factory EventStudent.empty() => EventStudent(
        studentId: "",
        name: "",
        emailId: "",
        mobileNumber: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        attended: false,
      );

  factory EventStudent.fromMap(Map data) {
    apiLogs("EventStudent.fromMap Data : $data");
    try {
      return EventStudent(
        studentId: data[APIKeys.studentId] ?? "",
        name: data[APIKeys.name] ?? "",
        emailId: data[APIKeys.emailId] ?? "",
        mobileNumber: data[APIKeys.mobileNumber] ?? "",
        createdAt: toDateTimeFromString(data[APIKeys.createdAt]) ?? DateTime.now(),
        updatedAt: toDateTimeFromString(data[APIKeys.updatedAt]) ?? DateTime.now(),
        attended: data[APIKeys.attended] ?? false,
      );
    } catch (e, s) {
      apiLogs("EventStudent.fromMap Exception : $e\n$s");
    }

    return EventStudent.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.studentId: this.studentId,
        APIKeys.name: this.name,
        APIKeys.emailId: this.emailId,
        APIKeys.mobileNumber: this.mobileNumber,
        APIKeys.attended: this.attended,
        APIKeys.createdAt: dateSendFormatter.format(this.createdAt),
        APIKeys.updatedAt: dateSendFormatter.format(this.updatedAt),
      };

  log() {
    apiLogs("=======EventStudent=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
