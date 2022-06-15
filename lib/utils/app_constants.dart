import 'package:country_pickers/country.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String logTAG = "LOGS";
const String apiTAG = "API";
const String screenTag = "SCREEN";

const int otpTimeOutInSeconds = 30;
const int mobileNumberLength = 10;
const int timeOutCode = 504;
const int serverErrorCode = 500;
const int timeOutSecond = 30;
const int errorStatusCode = 0;
const int minChildrenCount = 9;

DateFormat dateReadFormatter = DateFormat(DateFormats.inDayMonthYearTime).add_jm();
DateFormat dateDOBFormatter = DateFormat(DateFormats.inDayMonthYear);
DateFormat dateSendFormatter = DateFormat(DateFormats.inSendFormat);
DateFormat dateYearFormatter = DateFormat(DateFormats.inYear);
DateFormat dateMonthYearFormatter = DateFormat(DateFormats.inMonthYear);
DateFormat dateMonthFormatter = DateFormat(DateFormats.inMonth);
DateFormat timeFormatter = DateFormat(DateFormats.inTime);
DateFormat dayOfMonthFormatter = DateFormat(DateFormats.inDayOfWeek);
DateFormat dayOfWithDateFormatter = DateFormat(DateFormats.inWithDayOfWeekDayMonthYear);
DateFormat dayMonthFormatter = DateFormat(DateFormats.inDayMonth);
DateFormat dayFormatter = DateFormat(DateFormats.inDay);
DateFormat monthFormatter = DateFormat(DateFormats.inMonth);
DateFormat serverDateTimeFormatter = DateFormat(DateFormats.serverDateTime);
DateFormat dateHourMinTimeFormatter = DateFormat(DateFormats.inHourMin);

class DateFormats {
  static const String inTime = 'jm';
  static const String inMonth = 'MMM';
  static const String inYear = 'yyyy';
  static const String inMonthYear = 'MMM yyyy';
  static const String inDayMonthYear = 'dd MMM, yyyy';
  static const String inWithDayOfWeekDayMonthYear = 'EEEE, dd MMM yyyy';
  static const String inSendFormat = 'yyyy-MM-dd';
  static const String inDayMonthYearTime = 'dd MMM yyyy';
  static const String inDayOfWeek = 'EEEE';
  static const String inDayMonth = 'dd MMM';
  static const String inDay = 'dd';
  static const String serverDateTime = 'yyyy-MM-dd HH:mm:ss';
  static const String inHourMin = 'HH:mm';
}

class Constants {
  /*Delay Constants*/

  static const int delayExtraSmall = 100;
  static const int delaySmall = 200;
  static const int delayMedium = 500;
  static const int delayLarge = 1000;
  static const int delayXL = 1500;
  static const int delayXXL = 2000;

  static const int emailVerificationCallBack = 10000;

  static const double cardElevation = 5.0;
  static const double lineHeight = 0.5;
  static const double splashOpacity = 0.85;
  static const int dashNumber = 8;
  static const int dashNumberVertical = 25;
  static const int dashNumberVertical2 = 15;
  static const int personalInformationFocusNodes = 5;
  static const int companyInformationFocusNodes = 6;
  static const int flex = 1;
  static const int maxLineAppBar = 2;
  static const int errorMaxLines = 2;
  static const int paymentAmount = 400000;

  static const String defaultUserPassword = "QBIX@2019";
  static const String qrCodePrefix = "QBIX-";
}

class LeadStatus {
  static const String NEW = 'new';
  static const String LOST = 'lost';
  static const String FOLLOW_UP = 'follow_up';
  static const String APPOINTMENT = 'appointment';
  static const String PRE_PAYMENT = 'pre_payment';
  static const String QBIXIAN = 'qbixian';
}

class AppFileType {
  static const String TEXT = 'text';
  static const String IMAGE = 'image';
  static const String VIDEO = 'video';
  static const String PDF = 'pdf';
  static const String FILE = 'file';
}

class LeadFilters {
  static const String allLeads = "All Leads";
  static const String todayFollowUp = "Today's Follow up";
  static const String newLeads = "New Leads";
  static const String lostLeads = "Lost Leads";
  static const String followUpLeads = "Follow up Leads";
  static const String appointmentLead = "Appointment Lead";
  static const String prePaymentLeads = "Pre Payment Leads";
}

List<String> leadStatusList = [
  LeadStatus.NEW,
  LeadStatus.LOST,
  LeadStatus.FOLLOW_UP,
  LeadStatus.APPOINTMENT,
  LeadStatus.PRE_PAYMENT,
  LeadStatus.QBIXIAN,
];
List<String> paymentModeList = [
  PaymentMode.CASH,
  PaymentMode.ONLINE,
];

class PaymentMode {
  static const String CASH = 'CASH';
  static const String ONLINE = 'ONLINE';
}

class AppointmentCreatedByType {
  static const String STUDENT = 'student';
  static const String COUNSELLOR = 'counsellor';
}

class AppointmentStatus {
  static const String CONFIRMED = 'confirmed';
  static const String IN_PROGRESS = 'in_progress';
  static const String FINISHED = 'finished';
  static const String CANCELLED = 'cancelled';
  static const String RESCHEDULED = 'rescheduled';
}

class AppointmentReasons {
  static const String INITIAL_COUNSELLING = 'Initial_counselling';
}

Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();

class ExamType {
  static const String GRE = 'GRE';
  static const String GMAT = 'GMAT';
  static const String IELTS = 'IELTS';
  static const String TOEFL = 'TOEFL';
  static const String PTE = 'PTE';
}

List<String> genderList = ['Male', 'Female', 'Do not say'];
List<String> educationTypeList = ['12th', 'Diploma'];

List<String> examType = [
  ExamType.GRE,
  ExamType.GMAT,
  ExamType.IELTS,
  ExamType.TOEFL,
  ExamType.PTE,
];

class TaskStatus {
  static const String ASSIGNED = 'NEW';
  static const String IN_PROGRESS = 'IN PROGRESS';
  static const String COMPLETED = 'COMPLETED';
  static const String DUE = 'DUE';
}

List<Country> countryAppList = [
  Country(
    isoCode: "BE",
    phoneCode: "32",
    name: "Belgium",
    iso3Code: "BEL",
  ),
  Country(
    isoCode: "CA",
    phoneCode: "1",
    name: "Canada",
    iso3Code: "CAN",
  ),
  Country(
    isoCode: "CZ",
    phoneCode: "420",
    name: "Czech Republic",
    iso3Code: "CZE",
  ),
  Country(
    isoCode: "DK",
    phoneCode: "45",
    name: "Denmark",
    iso3Code: "DNK",
  ),
  Country(
    isoCode: "FI",
    phoneCode: "358",
    name: "Finland",
    iso3Code: "FIN",
  ),
  Country(
    isoCode: "FR",
    phoneCode: "33",
    name: "France",
    iso3Code: "FRA",
  ),
  Country(
    isoCode: "DE",
    phoneCode: "49",
    name: "Germany",
    iso3Code: "DEU",
  ),
  Country(
    isoCode: "IE",
    phoneCode: "353",
    name: "Ireland",
    iso3Code: "IRL",
  ),
  Country(
    isoCode: "IT",
    phoneCode: "39",
    name: "Italy",
    iso3Code: "ITA",
  ),
  Country(
    isoCode: "NL",
    phoneCode: "31",
    name: "Netherlands",
    iso3Code: "NLD",
  ),
  Country(
    isoCode: "NZ",
    phoneCode: "64",
    name: "New Zealand",
    iso3Code: "NZL",
  ),
  Country(
    isoCode: "NO",
    phoneCode: "47",
    name: "Norway",
    iso3Code: "NOR",
  ),
  Country(
    isoCode: "SG",
    phoneCode: "65",
    name: "Singapore",
    iso3Code: "SGP",
  ),
  Country(
    isoCode: "ES",
    phoneCode: "34",
    name: "Spain",
    iso3Code: "ESP",
  ),
  Country(
    isoCode: "SE",
    phoneCode: "46",
    name: "Sweden",
    iso3Code: "SWE",
  ),
  Country(
    isoCode: "CH",
    phoneCode: "41",
    name: "Switzerland",
    iso3Code: "CHE",
  ),
  Country(
    isoCode: "GB",
    phoneCode: "44",
    name: "United Kingdom",
    iso3Code: "GBR",
  ),
  Country(
    isoCode: "US",
    phoneCode: "1",
    name: "United States",
    iso3Code: "USA",
  ),
  Country(
    isoCode: "OTHERS",
    phoneCode: "00",
    name: "Others",
    iso3Code: "OTHERS",
  ),
];
