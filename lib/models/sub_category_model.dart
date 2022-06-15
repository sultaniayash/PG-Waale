import 'package:meta/meta.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';

class SubCategoryDataBank {
  String id;
  String name;
  String description;
  String createdAt;
  String createdBy;

  SubCategoryDataBank({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.createdAt,
    @required this.createdBy,
  });

  factory SubCategoryDataBank.empty() => SubCategoryDataBank(
        id: "",
        name: "",
        description: "",
        createdAt: getCurrentTime(),
        createdBy: auth.currentUser.emailId,
      );

  factory SubCategoryDataBank.fromMap({
    @required String id,
    @required Map data,
  }) {
    apiLogs("SubCategoryDataBank.fromMap Data : $data");
    try {
      return SubCategoryDataBank(
        id: id,
        name: data[APIKeys.name] ?? "",
        description: data[APIKeys.description] ?? "",
        createdAt: data[APIKeys.createdAt] ?? "",
        createdBy: data[APIKeys.createdBy] ?? "",
      );
    } catch (e, s) {
      apiLogs("SubCategoryDataBank.fromMap Exception : $e\n$s");
    }

    return SubCategoryDataBank.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.name: this.name,
        APIKeys.description: this.description,
        APIKeys.createdAt: this.createdAt,
        APIKeys.createdBy: this.createdBy,
      };

  log() {
    apiLogs("=======LogSubCategoryDataBank=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
