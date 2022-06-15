import 'package:meta/meta.dart';
import 'package:qbix/utils/a_utils.dart';

class Counsellor {
  String emailId;
  String name;
  String mobileNumber;
  String imageURL;
  String gender;
  int tier;
  CounsellorRoles counsellorRoles;

  Counsellor({
    @required this.emailId,
    @required this.name,
    @required this.mobileNumber,
    @required this.imageURL,
    @required this.gender,
    @required this.tier,
    @required this.counsellorRoles,
  });

  factory Counsellor.empty() => Counsellor(
        emailId: "",
        name: "",
        mobileNumber: "",
        imageURL: "",
        gender: "",
        tier: 0,
        counsellorRoles: CounsellorRoles.empty(),
      );

  factory Counsellor.fromMap(Map data) {
    apiLogs("Counsellor.fromMap Data : $data");
    try {
      return Counsellor(
        emailId: data[APIKeys.emailId] ?? "",
        name: data[APIKeys.name] ?? "",
        mobileNumber: data[APIKeys.mobileNumber] ?? "",
        imageURL: data[APIKeys.imageURL] ?? "",
        gender: data[APIKeys.gender] ?? "",
        tier: toINT(data[APIKeys.tier]),
        counsellorRoles: CounsellorRoles.fromMap(data[APIKeys.roles] ?? Map()),
      );
    } catch (e, s) {
      apiLogs("Counsellor.fromMap Exception : $e\n$s");
    }

    return Counsellor.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.name: this.name,
        APIKeys.emailId: this.emailId,
        APIKeys.mobileNumber: this.mobileNumber,
        APIKeys.imageURL: this.imageURL,
        APIKeys.gender: this.gender,
        APIKeys.tier: this.tier,
        APIKeys.roles: this.counsellorRoles.toMap(),
      };

  log() {
    apiLogs("=======LogCounsellor=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class CounsellorRoles {
  bool roleAppointments;
  bool roleAccounts;
  bool roleEvents;
  bool roleMembers;
  bool roleActivateStudents;
  bool roleClasses;
  bool roleStatistics;
  bool roleAddStudents;

  CounsellorRoles({
    @required this.roleAppointments,
    @required this.roleAccounts,
    @required this.roleEvents,
    @required this.roleMembers,
    @required this.roleActivateStudents,
    @required this.roleClasses,
    @required this.roleStatistics,
    @required this.roleAddStudents,
  });

  factory CounsellorRoles.empty() => CounsellorRoles(
        roleAppointments: false,
        roleAccounts: false,
        roleEvents: false,
        roleMembers: false,
        roleActivateStudents: false,
        roleClasses: false,
        roleStatistics: false,
        roleAddStudents: false,
      );

  factory CounsellorRoles.fromMap(Map data) {
    apiLogs("CounsellorRoles.fromMap Data : $data");
    try {
      return CounsellorRoles(
        roleAppointments: data[APIKeys.roleAppointments] ?? false,
        roleAccounts: data[APIKeys.roleAccounts] ?? false,
        roleEvents: data[APIKeys.roleEvents] ?? false,
        roleMembers: data[APIKeys.roleMembers] ?? false,
        roleActivateStudents: data[APIKeys.roleActivateStudents] ?? false,
        roleClasses: data[APIKeys.roleClasses] ?? false,
        roleStatistics: data[APIKeys.roleStatistics] ?? false,
        roleAddStudents: data[APIKeys.roleAddStudents] ?? false,
      );
    } catch (e, s) {
      apiLogs("CounsellorRoles.fromMap Exception : $e\n$s");
    }

    return CounsellorRoles.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.roleAppointments: this.roleAppointments,
        APIKeys.roleAccounts: this.roleAccounts,
        APIKeys.roleEvents: this.roleEvents,
        APIKeys.roleMembers: this.roleMembers,
        APIKeys.roleActivateStudents: this.roleActivateStudents,
        APIKeys.roleClasses: this.roleClasses,
        APIKeys.roleStatistics: this.roleStatistics,
        APIKeys.roleAddStudents: this.roleAddStudents,
      };
}
