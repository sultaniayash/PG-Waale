import 'package:flutter/material.dart';
import 'package:qbix/models/master_data_model.dart';
import 'package:qbix/models/time_slot_model.dart';
import 'package:qbix/services/auth_service.dart';
import 'package:qbix/utils/api_keys.dart';
import 'package:qbix/utils/app_constants.dart';
import 'package:qbix/utils/methods.dart';

class Appointment {
  String id;
  String createdAt;
  String updatedAt;
  String reason;
  String changeReason;
  String createdBy;
  String createdByType;
  String studentId;
  String from;
  String to;
  String date;
  TimeSlot timeSlot;
  String status;
  String counsellorId;
  String notes;
  int studentRating;
  String studentRatingComment;
  String studentName;

  Appointment({
    @required this.id,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.reason,
    @required this.changeReason,
    @required this.createdBy,
    @required this.createdByType,
    @required this.studentId,
    @required this.from,
    @required this.to,
    @required this.date,
    @required this.timeSlot,
    @required this.status,
    @required this.counsellorId,
    @required this.notes,
    @required this.studentRating,
    @required this.studentRatingComment,
    @required this.studentName,
  });

  factory Appointment.empty() => Appointment(
        id: generateDbId(),
        createdAt: getCurrentTime(),
        updatedAt: getCurrentTime(),
        reason: AppointmentReasons.INITIAL_COUNSELLING,
        changeReason: "",
        createdBy: auth.currentUser.uid,
        createdByType: AppointmentCreatedByType.STUDENT,
        studentId: auth.currentUser.uid,
        from: "",
        to: "",
        counsellorId: "",
        studentRatingComment: "",
        studentName: "",
        notes: "",
        studentRating: 0,
        date: dateSendFormatter.format(DateTime.now()),
        timeSlot: TimeSlot.empty(),
        status: AppointmentStatus.CONFIRMED,
      );

  factory Appointment.fromMap(Map data) {
    apiLogs("Appointment.fromMap Data : $data");
    try {
      return Appointment(
        id: data[APIKeys.id] ?? "",
        createdAt: data[APIKeys.createdAt] ?? "",
        updatedAt: data[APIKeys.updatedAt] ?? "",
        reason: data[APIKeys.reason] ?? "",
        changeReason: data[APIKeys.changeReason] ?? "",
        createdBy: data[APIKeys.createdBy] ?? "",
        createdByType: data[APIKeys.createdByType] ?? "",
        studentId: data[APIKeys.studentId] ?? "",
        from: data[APIKeys.from] ?? "",
        to: data[APIKeys.to] ?? "",
        date: data[APIKeys.date] ?? "",
        timeSlot: TimeSlot.fromMap(data[APIKeys.timeSlot] ?? Map()),
        status: data[APIKeys.status] ?? "",
        counsellorId: data[APIKeys.counsellorId] ?? "",
        notes: data[APIKeys.notes] ?? "",
        studentRating: data[APIKeys.studentRating] ?? 0,
        studentRatingComment: data[APIKeys.studentRatingComment] ?? "",
        studentName: data[APIKeys.studentName] ?? "",
      );
    } catch (e, s) {
      apiLogs("Appointment.fromMap Exception : $e\n$s");
    }

    return Appointment.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.createdAt: this.createdAt,
        APIKeys.updatedAt: this.updatedAt,
        APIKeys.reason: this.reason,
        APIKeys.changeReason: this.changeReason,
        APIKeys.createdBy: this.createdBy,
        APIKeys.createdByType: this.createdByType,
        APIKeys.studentId: this.studentId,
        APIKeys.from: this.from,
        APIKeys.to: this.to,
        APIKeys.date: this.date,
        APIKeys.timeSlot: this.timeSlot.toMap(),
        APIKeys.status: this.status,
        APIKeys.counsellorId: this.counsellorId,
        APIKeys.notes: this.notes,
        APIKeys.studentRating: this.studentRating,
        APIKeys.studentRatingComment: this.studentRatingComment,
        APIKeys.studentName: this.studentName,
      };
}

class DayTimeSlot {
  TimeSlot timeSlot;
  DateTime date;

  DayTimeSlot({
    @required this.timeSlot,
    @required this.date,
  });

  factory DayTimeSlot.empty() => DayTimeSlot(
        timeSlot: TimeSlot.empty(),
        date: DateTime.now().subtract(Duration(days: 10)),
      );

  Map<String, dynamic> toMap() => {
        APIKeys.timeSlot: this.timeSlot.toMap(),
        APIKeys.date: dateReadFormatter.format(this.date),
      };

  log() {
    apiLogs("=======DayTimeSlot=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class DayInfo {
  DateTime day;
  List<TimeSlot> availabilityTimeSlots;
  bool isAvailable;

  DayInfo({
    @required this.day,
    @required this.availabilityTimeSlots,
    @required this.isAvailable,
  });

  factory DayInfo.empty() => DayInfo(
        day: DateTime.now(),
        availabilityTimeSlots: [],
        isAvailable: false,
      );

  factory DayInfo.fromMap({
    @required DateTime day,
    @required Map data,
    @required int tier,
  }) {
    apiLogs("DayInfo.fromMap Data : $data");
    try {
      List timeSlotData = data[APIKeys.availabilitySlots] ?? List();

      DayInfo dayInfo = DayInfo(
        day: day,
        availabilityTimeSlots: timeSlotData.map((ts) => TimeSlot.fromMap(ts)).toList(),
        isAvailable: data[APIKeys.isAvailable] ?? false,
      );

      if (tier == 1) {
        dayInfo.availabilityTimeSlots.forEach((timeSlot) {
          timeSlot.startTime = MasterData.get().tier1TimeSlotList.firstWhere((ts) => ts.id == timeSlot.id).startTime;
          timeSlot.endTime = MasterData.get().tier1TimeSlotList.firstWhere((ts) => ts.id == timeSlot.id).endTime;
        });
      } else if (tier == 2) {
        dayInfo.availabilityTimeSlots.forEach((timeSlot) {
          timeSlot.startTime = MasterData.get().tier2TimeSlotList.firstWhere((ts) => ts.id == timeSlot.id).startTime;
          timeSlot.endTime = MasterData.get().tier2TimeSlotList.firstWhere((ts) => ts.id == timeSlot.id).endTime;
        });
      }
      //disable time slot according to current time

      dayInfo.availabilityTimeSlots.forEach((timeSlot) {
        DateTime _today = DateTime.now().add(Duration(minutes: 45));
        String timeSlotData = dateSendFormatter.format(day) + " ${timeSlot.startTime}:00";
        DateTime timeSlotDate = toDateTimeFromString(timeSlotData);
        if (timeSlotDate.isBefore(_today)) timeSlot.isAvailable = false;
      });

      return dayInfo;
    } catch (e, s) {
      apiLogs("DayInfo.fromMap Exception : $e\n$s");
    }

    return DayInfo.empty();
  }

  factory DayInfo.fromMasterData({
    @required DateTime day,
    @required int tier,
  }) {
    apiLogs("DayInfo.fromMasterData Data : $day");
    try {
      DayInfo dayInfo = DayInfo(
        day: day,
        availabilityTimeSlots: [],
        isAvailable: true,
      );
      if (tier == 1) {
        dayInfo.availabilityTimeSlots =
            MasterData.get().tier1TimeSlotList.map((ts) => TimeSlot.formTimeSlot(ts)).toList();
      } else if (tier == 2) {
        dayInfo.availabilityTimeSlots =
            MasterData.get().tier2TimeSlotList.map((ts) => TimeSlot.formTimeSlot(ts)).toList();
      }

      //disable time slot according to current time
      dayInfo.availabilityTimeSlots.forEach((timeSlot) {
        DateTime _today = DateTime.now().add(Duration(minutes: 45));
        String timeSlotData = dateSendFormatter.format(day) + " ${timeSlot.startTime}:00";
        DateTime timeSlotDate = toDateTimeFromString(timeSlotData);
        if (timeSlotDate.isBefore(_today)) {
          apiLogs(" isNOTAvailable =>$timeSlotData -$_today");
          timeSlot.isAvailable = false;
        } else {
          apiLogs(" isAvailable =>$timeSlotData -$_today");
        }
      });

      return dayInfo;
    } catch (e, s) {
      apiLogs("DayInfo.fromMasterData Exception : $e\n$s");
    }

    return DayInfo.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.isAvailable: this.isAvailable,
        APIKeys.availabilitySlots: this.availabilityTimeSlots.map((data) => data.toMap()).toList(),
      };

  log() {
    apiLogs("=======LogAppointment=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
