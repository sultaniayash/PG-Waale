import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qbix/models/appointment_models.dart';
import 'package:qbix/models/register_models.dart';
import 'package:qbix/models/user_model.dart';
import 'package:qbix/reactive_components/base_reactive_wiget.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';
import 'package:qbix/utils/error_message.dart';

import '../app_config.dart';
import 'auth_service.dart';

Firestore firestore = Firestore(app: FirebaseApp(name: App.appName));

Future<FirebaseApp> initFirebaseApp() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: Platform.isAndroid ? FireBaseSettingsAndroid.appName : FireBaseSettingsIOS.appName,
    options: FirebaseOptions(
      googleAppID: Platform.isAndroid ? FireBaseSettingsAndroid.googleAppID : FireBaseSettingsIOS.googleAppID,
      gcmSenderID: FireBaseSettings.gcmSenderID,
      apiKey: FireBaseSettings.apiKey,
      projectID: FireBaseSettings.projectID,
    ),
  );
  return app;
}

class FireBaseSettings {
  static const String apiKey = "AIzaSyCw61erwVh1vG66B2KziivOcKvwQTR0c3c";
  static const String projectID = "qbix-2ab4f";
  static const String gcmSenderID = "6854133777";
}

class FireBaseSettingsAndroid {
  static const String appName = "Qbix";
  static const String googleAppID = "1:6854133777:android:d660c28ec4dd4c7f4a89b0";
}

class FireBaseSettingsIOS {
  static const String appName = "Qbix";
  static const String googleAppID = "1:1001750066357:ios:5bb5ec91a59bbb28a73afc";
}

class FirestoreCollection {
  static const String dbRoute = "db_v1";
  static const String appData = "app_data";
  static const String counsellors = "counsellors";
  static const String students = "students";
  static const String master = "master";
  static const String appointments = "appointments";
  static const String transactions = "transactions";
  static const String events = "events";
  static const String studentEvents = "student_events";
  static const String dataBanks = "data_banks";
  static const String dataBankCategory = "data_bank_category";
  static const String dataBankSubCategory = "data_bank_sub_category";
  static const String subCategoryDocuments = "sub_category_documents";
  static const String tasks = "tasks";
  static const String studentTasks = "student_tasks";
}

class FirebaseApi {
  final String path;
  CollectionReference ref;

  FirebaseApi(this.path) {
    ref = firestore.collection(FirestoreCollection.dbRoute).document(FirestoreCollection.appData).collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  DocumentReference getDocumentRef(String id) {
    return ref.document(id);
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<void> addDocument({String id, Map data}) {
    return ref.document(id).setData(data);
  }

  Future<void> updateDocument({String id, Map<String, dynamic> data}) {
    return ref.document(id).setData(data, merge: true);
  }
}

class FirebaseSignIn {
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<FirebaseUser> createUser({
    @required String email,
    @required String password,
  }) async {
    final AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser _firebaseUser = authResult.user;
    if (!_firebaseUser.isEmailVerified) {
      await _firebaseUser.sendEmailVerification();
    }
    return _firebaseUser;
  }

  static Future<FirebaseUser> signIn({
    @required String email,
    @required String password,
  }) async {
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    FirebaseUser _firebaseUser = authResult.user;
    if (!_firebaseUser.isEmailVerified) {
      await _firebaseUser.sendEmailVerification();
    }
    return _firebaseUser;
  }

  static Future<Null> sendPasswordResetEmail({@required String email}) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  static Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final AuthResult authResult = await _firebaseAuth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return authResult.user;
      } else {
        throw PlatformException(
          code: ErrorMessage.ERROR_ABORTED_BY_USER.toCode(),
          message: ErrorMessage.ERROR_ABORTED_BY_USER.toMessage(),
        );
      }
    } else {
      throw PlatformException(
        code: ErrorMessage.ERROR_ABORTED_BY_USER.toCode(),
        message: ErrorMessage.ERROR_ABORTED_BY_USER.toMessage(),
      );
    }
  }

  static Future<String> checkUserLeadStatus() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseApi(FirestoreCollection.students).getDocumentById(auth.currentUser.uid);
      if (documentSnapshot.exists) {
        await auth.updateUserInSharedPreference(
            User.fromMap(loggedIn: auth.currentUser.loggedIn, data: documentSnapshot.data));
        return auth.currentUser.leadStatus;
      }
    } catch (e, s) {
      appLogs("checkIfUserInformationSaved $e\n$s");
    }
    return "";
  }

  static Future<bool> checkIsInfoComplete() async {
    try {
      await FirebaseSignIn.updateUserData();
      return auth.currentUser.isInfoComplete;
    } catch (e, s) {
      appLogs("checkIsInfoComplete Error $e\n$s");
    }
    return false;
  }

  static Future<Null> updateUserData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseApi(FirestoreCollection.students).getDocumentById(auth.currentUser.uid);
      if (documentSnapshot.exists) {
        await auth.updateUserInSharedPreference(
            User.fromMap(loggedIn: auth.currentUser.loggedIn, data: documentSnapshot.data));
      }
    } catch (e, s) {
      appLogs("updateUserData $e\n$s");
    }
  }
}

class FirebaseRepo {
  static Stream<QuerySnapshot> getTasksForStudent({
    @required String uid,
  }) {
    return FirebaseApi(FirestoreCollection.students)
        .ref
        .document(uid)
        .collection(FirestoreCollection.studentTasks)
        .orderBy(APIKeys.dueDate, descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDataBanks() {
    return FirebaseApi(FirestoreCollection.dataBanks).ref.snapshots();
  }

  static Stream<QuerySnapshot> getDataBankCategory(String country) {
    return FirebaseApi(FirestoreCollection.dataBanks)
        .getDocumentRef(country)
        .collection(FirestoreCollection.dataBankCategory)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDataBankSubCategory(String country, String categoryId) {
    return FirebaseApi(FirestoreCollection.dataBanks)
        .getDocumentRef(country)
        .collection(FirestoreCollection.dataBankCategory)
        .document(categoryId)
        .collection(FirestoreCollection.dataBankSubCategory)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDataBankDocuments(
    String country,
    String categoryId,
    String subCategoryId,
  ) {
    return FirebaseApi(FirestoreCollection.dataBanks)
        .getDocumentRef(country)
        .collection(FirestoreCollection.dataBankCategory)
        .document(categoryId)
        .collection(FirestoreCollection.dataBankSubCategory)
        .document(subCategoryId)
        .collection(FirestoreCollection.subCategoryDocuments)
        .snapshots();
  }

  static Stream<QuerySnapshot> getDataBankDocumentByType(String country, String categoryId, String subCategoryId,
      {String fileType}) {
    return FirebaseApi(FirestoreCollection.dataBanks)
        .getDocumentRef(country)
        .collection(FirestoreCollection.dataBankCategory)
        .document(categoryId)
        .collection(FirestoreCollection.dataBankSubCategory)
        .document(subCategoryId)
        .collection(FirestoreCollection.subCategoryDocuments)
        .where(APIKeys.type, isEqualTo: fileType)
        .snapshots();
  }

  static Stream<QuerySnapshot> getEvents() {
    return FirebaseApi(FirestoreCollection.events).ref.orderBy(APIKeys.date, descending: true).snapshots();
  }

  static Stream<QuerySnapshot> getStudentEvents() {
    return FirebaseApi(FirestoreCollection.students)
        .ref
        .document(auth.currentUser.uid)
        .collection(FirestoreCollection.studentEvents)
        .orderBy(APIKeys.date, descending: true)
        .snapshots();
  }

  static ReactiveRef<Map> getStudent(String id) {
    return new ReactiveRef(FirebaseApi(FirestoreCollection.students).getDocumentRef(id));
  }

  static Stream<QuerySnapshot> getAllCounsellors() {
    return FirebaseApi(FirestoreCollection.counsellors).ref.snapshots();
  }

  static Stream<QuerySnapshot> getConfirmedAppointmentsForStudent({
    @required String uid,
  }) {
    return FirebaseApi(FirestoreCollection.appointments)
        .ref
        .where(APIKeys.studentId, isEqualTo: uid)
        .where(APIKeys.status, isEqualTo: AppointmentStatus.CONFIRMED)
        .snapshots();
  }

  static Stream<QuerySnapshot> getAppointmentsForStudent({
    @required String uid,
  }) {
    return FirebaseApi(FirestoreCollection.appointments).ref.where(APIKeys.studentId, isEqualTo: uid).snapshots();
  }

  static ReactiveRef<Map> getDayInfo({
    @required DateTime day,
    @required String counsellorEmailId,
  }) {
    appLogs(
        'getAllCounsellors counsellorEmailId : $counsellorEmailId/${dateSendFormatter.format(day)}/${APIKeys.info}');
    return new ReactiveRef(FirebaseApi(FirestoreCollection.counsellors)
        .ref
        .document(counsellorEmailId)
        .collection(dateSendFormatter.format(day))
        .document(APIKeys.info));
  }

  static ReactiveRef<Map> getAppointmentById({
    @required String id,
  }) {
    appLogs('getAppointmentById id : $id');
    return new ReactiveRef(FirebaseApi(FirestoreCollection.appointments).ref.document(id));
  }

  static Future<Map<String, dynamic>> getFirstAppointmentData() async {
    Map<String, dynamic> data = Map();

    QuerySnapshot querySnapshot = await FirebaseApi(FirestoreCollection.appointments)
        .ref
        .where(APIKeys.studentId, isEqualTo: auth.currentUser.uid)
        .getDocuments();

    if (querySnapshot.documents.isNotEmpty) {
      return querySnapshot.documents.first.data;
    }
    return data;
  }

  static Future<Null> rescheduleAppointment({
    @required Appointment appointment,
    @required String rescheduledTo,
  }) async {
    //TODO:add batch
    appLogs('getAppointmentById id : ${appointment.id}');
    await FirebaseApi(FirestoreCollection.appointments).ref.document(appointment.id).updateData({
      APIKeys.status: AppointmentStatus.CANCELLED,
      APIKeys.updatedAt: getCurrentTime(),
      APIKeys.to: rescheduledTo,
    });
    await FirebaseApi(FirestoreCollection.counsellors)
        .ref
        .document(appointment.counsellorId)
        .collection(appointment.date)
        .document(appointment.timeSlot.id)
        .updateData({
      APIKeys.status: AppointmentStatus.CANCELLED,
      APIKeys.updatedAt: getCurrentTime(),
      APIKeys.to: rescheduledTo
    });
  }

  static Future<Null> cancelAppointment({
    @required Appointment appointment,
  }) async {
    //TODO:add batch
    appLogs('getAppointmentById id : ${appointment.id}');
    await FirebaseApi(FirestoreCollection.appointments).ref.document(appointment.id).updateData({
      APIKeys.status: AppointmentStatus.CANCELLED,
      APIKeys.updatedAt: getCurrentTime(),
    });
    await FirebaseApi(FirestoreCollection.counsellors)
        .ref
        .document(appointment.counsellorId)
        .collection(appointment.date)
        .document(appointment.timeSlot.id)
        .updateData({
      APIKeys.status: AppointmentStatus.CANCELLED,
      APIKeys.updatedAt: getCurrentTime(),
    });
  }

  static Future<Null> addMasterCountries() async {
    List<AppCountry> dataList = List.from(countryAppList).map((data) => AppCountry.fromCountry(data)).toList();
    await firestore
        .collection(FirestoreCollection.dbRoute)
        .document(FirestoreCollection.master)
        .setData({APIKeys.countries: dataList.map((data) => data.toMap()).toList()}, merge: true);
  }
}
