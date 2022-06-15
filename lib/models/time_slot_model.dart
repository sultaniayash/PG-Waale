import 'package:flutter/material.dart';
import 'package:qbix/utils/a_utils.dart';

class TimeSlot {
  String id;
  String startTime;
  String endTime;
  bool isAvailable;

  TimeSlot({
    @required this.id,
    @required this.startTime,
    @required this.endTime,
    @required this.isAvailable,
  });

  factory TimeSlot.empty() => TimeSlot(
        id: "",
        startTime: "",
        endTime: "",
        isAvailable: false,
      );

  factory TimeSlot.formTimeSlot(TimeSlot timeSlot) => TimeSlot(
        id: timeSlot.id,
        startTime: timeSlot.startTime,
        endTime: timeSlot.endTime,
        isAvailable: timeSlot.isAvailable,
      );

  factory TimeSlot.fromMap(Map data) {
    apiLogs("TimeSlot.fromMap Data : $data");
    try {
      return TimeSlot(
        id: data[APIKeys.id] ?? "",
        startTime: data[APIKeys.startTime] ?? "",
        endTime: data[APIKeys.endTime] ?? "",
        isAvailable: data[APIKeys.isAvailable] ?? true,
      );
    } catch (e, s) {
      apiLogs("TimeSlot.fromMap Exception : $e\n$s");
    }

    return TimeSlot.empty();
  }

  factory TimeSlot.fromMaster(Map data) {
    apiLogs("TimeSlot.fromMaster Data : $data");
    try {
      return TimeSlot(
        id: data[APIKeys.id] ?? "",
        startTime: data[APIKeys.startTime] ?? "",
        endTime: data[APIKeys.endTime] ?? "",
        isAvailable: true,
      );
    } catch (e, s) {
      apiLogs("TimeSlot.fromMaster Exception : $e\n$s");
    }

    return TimeSlot.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.startTime: this.startTime,
        APIKeys.endTime: this.endTime,
        APIKeys.isAvailable: this.isAvailable,
      };

  log() {
    apiLogs("=======TimeSlot=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
