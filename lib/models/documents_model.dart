import 'package:meta/meta.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';

class AppDocument {
  String id;
  String name;
  String url;
  String description;
  String fileName;
  String type;
  String createdAt;
  String createdBy;

  AppDocument({
    @required this.id,
    @required this.name,
    @required this.url,
    @required this.description,
    @required this.fileName,
    @required this.type,
    @required this.createdAt,
    @required this.createdBy,
  });

  factory AppDocument.empty() => AppDocument(
        id: "",
        name: "",
        url: "",
        description: "",
        fileName: "",
        type: "",
        createdAt: getCurrentTime(),
        createdBy: auth.currentUser.emailId,
      );

  factory AppDocument.fromMap({
    @required String id,
    @required Map data,
  }) {
    apiLogs("AppDocument.fromMap Data : $data");
    try {
      return AppDocument(
        id: id,
        name: data[APIKeys.name] ?? "",
        url: data[APIKeys.url] ?? "",
        type: data[APIKeys.type] ?? "",
        description: data[APIKeys.description] ?? "",
        fileName: data[APIKeys.fileName] ?? "",
        createdAt: data[APIKeys.createdAt] ?? "",
        createdBy: data[APIKeys.createdBy] ?? "",
      );
    } catch (e, s) {
      apiLogs("AppDocument.fromMap Exception : $e\n$s");
    }

    return AppDocument.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.name: this.name,
        APIKeys.url: this.url,
        APIKeys.type: this.type,
        APIKeys.description: this.description,
        APIKeys.fileName: this.fileName,
        APIKeys.createdAt: this.createdAt,
        APIKeys.createdBy: this.createdBy,
      };

  log() {
    apiLogs("=======LogAppDocument=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
