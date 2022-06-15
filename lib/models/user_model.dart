import 'package:meta/meta.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/utils/a_utils.dart';

class User {
  bool loggedIn;
  String uid;
  String emailId;
  String mobileNumber;
  String leadStatus;
  bool isInfoComplete;
  PersonalInformation personalInformation;
  EducationInformation educationInformation;
  CoursesCountriesInformation coursesCountriesInformation;
  ExperienceInformation experienceInformation;
  ExamInformation examInformation;

  String get fullName => personalInformation.firstName + " " + personalInformation.lastName;

  User({
    @required this.loggedIn,
    @required this.uid,
    @required this.emailId,
    @required this.mobileNumber,
    @required this.leadStatus,
    @required this.isInfoComplete,
    @required this.personalInformation,
    @required this.educationInformation,
    @required this.coursesCountriesInformation,
    @required this.experienceInformation,
    @required this.examInformation,
  });

  factory User.empty() => User(
        loggedIn: false,
        uid: "",
        emailId: "",
        mobileNumber: "",
        leadStatus: LeadStatus.NEW,
        isInfoComplete: false,
        personalInformation: PersonalInformation.empty(),
        educationInformation: EducationInformation.empty(),
        coursesCountriesInformation: CoursesCountriesInformation.empty(),
        experienceInformation: ExperienceInformation.empty(),
        examInformation: ExamInformation.empty(),
      );

  factory User.fromMap({bool loggedIn = false, Map data}) {
    apiLogs("User.fromMap Data : $data");
    try {
      return User(
        loggedIn: loggedIn,
        uid: data[APIKeys.uid] ?? "",
        emailId: data[APIKeys.emailId] ?? "",
        mobileNumber: data[APIKeys.mobileNumber] ?? "",
        leadStatus: data[APIKeys.leadStatus] ?? LeadStatus.NEW,
        isInfoComplete: data[APIKeys.isInfoComplete] ?? false,
        personalInformation: PersonalInformation.fromMap(data[APIKeys.personalInformation] ?? Map()),
        educationInformation: EducationInformation.fromMap(data[APIKeys.educationInformation] ?? Map()),
        coursesCountriesInformation:
            CoursesCountriesInformation.fromMap(data[APIKeys.coursesCountriesInformation] ?? Map()),
        experienceInformation: ExperienceInformation.fromMap(data[APIKeys.experienceInformation] ?? Map()),
        examInformation: ExamInformation.fromMap(data[APIKeys.examInformation] ?? Map()),
      );
    } catch (e, s) {
      apiLogs("User.fromMap Exception : $e\n$s");
    }

    return User.empty();
  }

  factory User.fromUIDAndEmail({String email, String uid}) {
    apiLogs("User.fromMap email:$email |  uid:$uid");
    try {
      User _user = User.empty();
      _user.loggedIn = true;
      _user.uid = uid;
      _user.emailId = email;
      return _user;
    } catch (e, s) {
      apiLogs("User.fromUIDAndEmail Exception : $e\n$s");
    }

    return User.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.uid: this.uid,
        APIKeys.emailId: this.emailId,
        APIKeys.mobileNumber: this.mobileNumber,
        APIKeys.leadStatus: this.leadStatus,
        APIKeys.isInfoComplete: this.isInfoComplete,
        APIKeys.personalInformation: this.personalInformation.toMap(),
        APIKeys.educationInformation: this.educationInformation.toMap(),
        APIKeys.coursesCountriesInformation: this.coursesCountriesInformation.toMap(),
        APIKeys.experienceInformation: this.experienceInformation.toMap(),
        APIKeys.examInformation: this.examInformation.toMap(),
      };

  log() {
    apiLogs("=======LogUser=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
