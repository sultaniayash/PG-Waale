import 'package:country_pickers/country.dart';
import 'package:meta/meta.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';

class PersonalInformation {
  String firstName;
  String lastName;
  String address;
  String gender;
  DateTime dob;

  PersonalInformation({
    @required this.firstName,
    @required this.lastName,
    @required this.address,
    @required this.gender,
    @required this.dob,
  });

  factory PersonalInformation.empty() => PersonalInformation(
        firstName: "",
        lastName: "",
        address: "",
        gender: genderList[0],
        dob: DateTime.now().subtract(Duration(days: 1)),
      );

  factory PersonalInformation.fromMap(Map data) {
    apiLogs("PersonalInformation.fromMap Data : $data");
    try {
      return PersonalInformation(
        firstName: data[APIKeys.firstName] ?? "",
        lastName: data[APIKeys.lastName] ?? "",
        address: data[APIKeys.address] ?? "",
        gender: data[APIKeys.gender] ?? PersonalInformation.empty().gender,
        dob: toDateTimeFromString(data[APIKeys.dob]) ?? PersonalInformation.empty().dob,
      );
    } catch (e, s) {
      apiLogs("PersonalInformation.fromMap Exception : $e\n$s");
    }

    return PersonalInformation.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.emailId: auth.currentUser.emailId,
        APIKeys.uid: auth.currentUser.uid,
        APIKeys.firstName: this.firstName,
        APIKeys.lastName: this.lastName,
        APIKeys.address: this.address,
        APIKeys.gender: this.gender,
        APIKeys.dob: dateDOBFormatter.format(this.dob),
      };

  log() {
    apiLogs("=======PersonalInformation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class EducationInformation {
  Education tenTh;
  Education diplomaOr12Th;
  Education bachelors;
  Education masters;

  EducationInformation({
    @required this.tenTh,
    @required this.diplomaOr12Th,
    @required this.bachelors,
    @required this.masters,
  });

  factory EducationInformation.empty() => EducationInformation(
        tenTh: Education.empty(),
        diplomaOr12Th: Education.emptyWithType(),
        bachelors: Education.empty(),
        masters: Education.empty(),
      );

  factory EducationInformation.fromMap(Map data) {
    apiLogs("EducationInformation.fromMap Data : $data");
    try {
      return EducationInformation(
        tenTh: Education.fromMap(data[APIKeys.tenTh] ?? Map()),
        diplomaOr12Th: Education.fromMap(data[APIKeys.diplomaOr12Th] ?? Map()),
        bachelors: Education.fromMap(data[APIKeys.bachelors] ?? Map()),
        masters: Education.fromMap(data[APIKeys.masters] ?? Map()),
      );
    } catch (e, s) {
      apiLogs("EducationInformation.fromMap Exception : $e\n$s");
    }

    return EducationInformation.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.tenTh: this.tenTh.toMap(),
        APIKeys.diplomaOr12Th: this.diplomaOr12Th.toMap(),
        APIKeys.bachelors: this.bachelors.toMap(),
        APIKeys.masters: this.masters.toMap(),
      };

  log() {
    apiLogs("=======LogEducationInformation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class CoursesCountriesInformation {
  DateTime startingMonth;
  DateTime startingYear;
  List<String> courses;
  List<AppCountry> countries;

  CoursesCountriesInformation({
    @required this.startingMonth,
    @required this.startingYear,
    @required this.courses,
    @required this.countries,
  });

  factory CoursesCountriesInformation.empty() => CoursesCountriesInformation(
        startingMonth: DateTime.now(),
        startingYear: DateTime.now(),
        courses: [],
        countries: [],
      );

  factory CoursesCountriesInformation.fromMap(Map data) {
    apiLogs("CoursesCountriesInformation.fromMap Data : $data");
    try {
      return CoursesCountriesInformation(
        courses: List<String>.from(data[APIKeys.courses] ?? []),
        countries: List<AppCountry>.from((data[APIKeys.countries] ?? []).map((data) => AppCountry.fromMap(data))),
        startingMonth:
            toDateTimeFromString(data[APIKeys.startingMonth]) ?? CoursesCountriesInformation.empty().startingMonth,
        startingYear:
            toDateTimeFromString(data[APIKeys.startingYear]) ?? CoursesCountriesInformation.empty().startingYear,
      );
    } catch (e, s) {
      apiLogs("CoursesCountriesInformation.fromMap Exception : $e\n$s");
    }

    return CoursesCountriesInformation.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.courses: this.courses,
        APIKeys.countries: this.countries.map((country) => country.toMap()).toList(),
        APIKeys.startingYear: dateYearFormatter.format(this.startingYear),
        APIKeys.startingMonth: dateMonthFormatter.format(this.startingMonth),
      };

  log() {
    apiLogs("=======LogCoursesCountriesInformation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class ExperienceInformation {
  List<Experience> experiences;

  ExperienceInformation({
    @required this.experiences,
  });

  factory ExperienceInformation.empty() => ExperienceInformation(
        experiences: [],
      );

  factory ExperienceInformation.fromMap(Map data) {
    apiLogs("ExperienceInformation.fromMap Data : $data");
    try {
      return ExperienceInformation(
        experiences: List<Experience>.from((data[APIKeys.experiences] ?? []).map((data) => Experience.fromMap(data))),
      );
    } catch (e, s) {
      apiLogs("ExperienceInformation.fromMap Exception : $e\n$s");
    }

    return ExperienceInformation.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.experiences: this.experiences.map((data) => data.toMap()).toList(),
      };

  log() {
    apiLogs("=======LogExperienceInformation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class ExamInformation {
  List<Exam> exams;

  ExamInformation({
    @required this.exams,
  });

  factory ExamInformation.empty() => ExamInformation(
        exams: [],
      );

  factory ExamInformation.fromMap(Map data) {
    apiLogs("ExamInformation.fromMap Data : $data");
    try {
      return ExamInformation(
        exams: List<Exam>.from((data[APIKeys.exams] ?? []).map((data) => Exam.fromMap(data))),
      );
    } catch (e, s) {
      apiLogs("ExamInformation.fromMap Exception : $e\n$s");
    }

    return ExamInformation.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.exams: this.exams.map((data) => data.toMap()).toList(),
      };

  log() {
    apiLogs("=======LogExamInformation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}

class Education {
  String type;
  String board;
  String subject;
  DateTime fromDate;
  DateTime toDate;

  Education({
    @required this.type,
    @required this.board,
    @required this.subject,
    @required this.fromDate,
    @required this.toDate,
  });

  factory Education.empty() => Education(
        type: "",
        board: "",
        subject: "",
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
      );

  factory Education.emptyWithType() => Education(
        type: educationTypeList[0],
        board: "",
        subject: "",
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
      );

  factory Education.fromMap(Map data) {
    apiLogs("Education.fromMap Data : $data");
    try {
      return Education(
        type: data[APIKeys.type] ?? Education.empty().type,
        board: data[APIKeys.board] ?? "",
        subject: data[APIKeys.subject] ?? "",
        fromDate: toDateTimeFromString(data[APIKeys.fromDate]) ?? Education.empty().fromDate,
        toDate: toDateTimeFromString(data[APIKeys.toDate]) ?? Education.empty().fromDate,
      );
    } catch (e, s) {
      apiLogs("Education.fromMap Exception : $e\n$s");
    }

    return Education.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.type: this.type,
        APIKeys.board: this.board,
        APIKeys.subject: this.subject,
        APIKeys.fromDate: dateYearFormatter.format(this.fromDate),
        APIKeys.toDate: dateYearFormatter.format(this.toDate),
      };

  log() {
    apiLogs("=======LogEducation=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : ${v is Education ? v.toMap() : v}");
    });
  }
}

class Experience {
  String position;
  String organisationName;
  String description;
  DateTime fromDate;
  DateTime toDate;

  Experience({
    @required this.position,
    @required this.organisationName,
    @required this.description,
    @required this.fromDate,
    @required this.toDate,
  });

  factory Experience.empty() => Experience(
        position: "",
        organisationName: "",
        description: "",
        fromDate: DateTime.now(),
        toDate: DateTime.now(),
      );

  factory Experience.fromMap(Map data) {
    apiLogs("Experience.fromMap Data : $data");
    try {
      return Experience(
        position: data[APIKeys.position] ?? Experience.empty().position,
        organisationName: data[APIKeys.organisationName] ?? "",
        description: data[APIKeys.description] ?? "",
        fromDate: toDateTimeFromString(data[APIKeys.fromDate]) ?? Experience.empty().fromDate,
        toDate: toDateTimeFromString(data[APIKeys.toDate]) ?? Experience.empty().fromDate,
      );
    } catch (e, s) {
      apiLogs("Experience.fromMap Exception : $e\n$s");
    }

    return Experience.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.position: this.position,
        APIKeys.organisationName: this.organisationName,
        APIKeys.description: this.description,
        APIKeys.fromDate: dateYearFormatter.format(this.fromDate),
        APIKeys.toDate: dateYearFormatter.format(this.toDate),
      };

  log() {
    apiLogs("=======LogExperience=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : ${v is Experience ? v.toMap() : v}");
    });
  }
}

class AppCountry {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;

  AppCountry({this.isoCode, this.iso3Code, this.phoneCode, this.name});

  factory AppCountry.empty() => AppCountry(
        name: "",
        isoCode: "",
        iso3Code: "",
        phoneCode: "",
      );

  factory AppCountry.fromMap(Map data) {
    apiLogs("AppCountry.fromMap Data : $data");
    try {
      return AppCountry(
        name: data[APIKeys.name] ?? "",
        isoCode: data[APIKeys.isoCode] ?? "",
        iso3Code: data[APIKeys.iso3Code] ?? "",
        phoneCode: data[APIKeys.phoneCode] ?? "",
      );
    } catch (e, s) {
      apiLogs("AppCountry.fromMap Exception : $e\n$s");
    }

    return AppCountry.empty();
  }

  factory AppCountry.fromCountry(Country country) => AppCountry(
        name: country.name,
        isoCode: country.isoCode,
        iso3Code: country.iso3Code,
        phoneCode: country.phoneCode,
      );

  Map<String, String> toMap() => {
        APIKeys.name: this.name,
        APIKeys.isoCode: this.isoCode,
        APIKeys.iso3Code: this.iso3Code,
        APIKeys.phoneCode: this.phoneCode
      };
}

class Exam {
  String type;
  List<Subject> subjects;
  DateTime takenOn;

  Exam({
    @required this.type,
    @required this.subjects,
    @required this.takenOn,
  });

  factory Exam.empty() => Exam.emptyWithType(examType[0]);

  factory Exam.emptyWithType(String type) {
    Exam exam = Exam(
      type: type,
      subjects: [],
      takenOn: DateTime.now(),
    );

    switch (type) {
      case ExamType.GRE:
        exam.subjects = [
          Subject(title: "Quants", maxMarks: 170, marks: 0),
          Subject(title: "Verbal", maxMarks: 170, marks: 0),
          Subject(title: "AWA", maxMarks: 6, marks: 0),
        ];

        break;
      case ExamType.GMAT:
        exam.subjects = [
          Subject(title: "Quants", maxMarks: 400, marks: 0),
          Subject(title: "Verbal", maxMarks: 400, marks: 0),
          Subject(title: "AWA", maxMarks: 6, marks: 0),
        ];
        break;
      case ExamType.IELTS:
        exam.subjects = [
          Subject(title: "Listening", maxMarks: 9, marks: 0),
          Subject(title: "Reading", maxMarks: 9, marks: 0),
          Subject(title: "Writing", maxMarks: 9, marks: 0),
          Subject(title: "Speaking", maxMarks: 9, marks: 0),
        ];
        break;
      case ExamType.TOEFL:
        exam.subjects = [
          Subject(title: "Listening", maxMarks: 30, marks: 0),
          Subject(title: "Reading", maxMarks: 30, marks: 0),
          Subject(title: "Writing", maxMarks: 30, marks: 0),
          Subject(title: "Speaking", maxMarks: 30, marks: 0),
        ];
        break;
      case ExamType.PTE:
        exam.subjects = [
          Subject(title: "Listening", maxMarks: 90, marks: 0),
          Subject(title: "Reading", maxMarks: 90, marks: 0),
          Subject(title: "Writing", maxMarks: 90, marks: 0),
          Subject(title: "Speaking", maxMarks: 90, marks: 0),
        ];
        break;
    }

    return exam;
  }

  factory Exam.fromMap(Map data) {
    apiLogs("Exam.fromMap Data : $data");
    try {
      return Exam(
        type: data[APIKeys.type] ?? Exam.empty().type,
        subjects: List.from(data[APIKeys.subjects] ?? List()).map((sub) => Subject.fromMap(sub)).toList(),
        takenOn: toDateTimeFromString(data[APIKeys.takenOn]) ?? Exam.empty().takenOn,
      );
    } catch (e, s) {
      apiLogs("Exam.fromMap Exception : $e\n$s");
    }

    return Exam.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.type: this.type,
        APIKeys.subjects: this.subjects.map((sub) => sub.toMap()).toList(),
        APIKeys.takenOn: dateSendFormatter.format(this.takenOn),
      };

  log() {
    apiLogs("=======LogExam=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : ${v is Exam ? v.toMap() : v}");
    });
  }
}

class Subject {
  String title;
  double maxMarks;
  double marks;

  Subject({
    @required this.title,
    @required this.maxMarks,
    @required this.marks,
  });

  factory Subject.empty() => Subject(
        title: "",
        maxMarks: 0,
        marks: 0,
      );

  factory Subject.fromMap(Map data) {
    apiLogs("Subject.fromMap Data : $data");
    try {
      return Subject(
        title: data[APIKeys.title] ?? "",
        maxMarks: toDouble(data[APIKeys.maxMarks]),
        marks: toDouble(data[APIKeys.marks]),
      );
    } catch (e, s) {
      apiLogs("Subject.fromMap Exception : $e\n$s");
    }

    return Subject.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.title: this.title,
        APIKeys.maxMarks: this.maxMarks,
        APIKeys.marks: this.marks,
      };

  log() {
    apiLogs("=======LogSubject=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : ${v is Subject ? v.toMap() : v}");
    });
  }
}
