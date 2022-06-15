import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/models/time_slot_model.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';

import 'event_model.dart';

class MasterData {
  List<TimeSlot> tier1TimeSlotList;
  List<TimeSlot> tier2TimeSlotList;
  List<EventType> eventTypeList;
  List<String> courses;
  List<AppCountry> countries;

  static MasterData _instance = MasterData.empty();

  MasterData({
    @required this.tier1TimeSlotList,
    @required this.tier2TimeSlotList,
    @required this.eventTypeList,
    @required this.courses,
    @required this.countries,
  });

  factory MasterData.get() => _instance;

  factory MasterData.empty() => MasterData(
        tier1TimeSlotList: [],
        tier2TimeSlotList: [],
        eventTypeList: [],
        courses: [],
        countries: [],
      );

  factory MasterData.fromMap(Map data) {
    apiLogs("MasterData.fromMap Data : $data");
    try {
      Map timeSlotData = data[APIKeys.timeSlots] ?? Map();
      List tier1List = timeSlotData[APIKeys.tier1] ?? List();
      List tier2List = timeSlotData[APIKeys.tier2] ?? List();
      List eventTypeList = data[APIKeys.eventType] ?? List();
      List courses = data[APIKeys.courses] ?? List();
      List countries = data[APIKeys.countries] ?? List();

      return MasterData(
        tier1TimeSlotList: tier1List.map((ts) => TimeSlot.fromMaster(ts)).toList(),
        tier2TimeSlotList: tier2List.map((ts) => TimeSlot.fromMaster(ts)).toList(),
        eventTypeList: eventTypeList.map((event) => EventType.fromMap(event)).toList(),
        countries: countries.map((country) => AppCountry.fromMap(country)).toList(),
        courses: courses.map((course) => '$course').toList(),
      );
    } catch (e, s) {
      apiLogs("MasterData.fromMap Exception : $e\n$s");
    }

    return MasterData.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.timeSlots: {
          APIKeys.tier1: this.tier1TimeSlotList.map((data) => data.toMap()).toList(),
          APIKeys.tier2: this.tier2TimeSlotList.map((data) => data.toMap()).toList(),
        },
        APIKeys.eventType: this.eventTypeList.map((data) => data.toMap()).toList(),
        APIKeys.courses: this.courses.map((data) => data).toList(),
        APIKeys.countries: this.countries.map((data) => data.toMap()).toList(),
      };

  log() {
    apiLogs("=======MasterData=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }

  static Future<Null> fetchMasterData() async {
    apiLogs("MasterData fetchMasterData");
    DocumentSnapshot documentSnapshot =
        await firestore.collection(FirestoreCollection.dbRoute).document(FirestoreCollection.master).get();
    if (documentSnapshot.exists) {
      _instance = MasterData.fromMap(documentSnapshot.data);
      _instance.log();
    } else {
      apiLogs("Error in fetchMasterData");
    }
  }
}
