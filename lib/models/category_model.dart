import 'package:meta/meta.dart';
import 'package:qbix/services/a_services.dart';
import 'package:qbix/utils/a_utils.dart';

class CategoryDataBank {
  String id;
  String name;
  String description;
  String createdAt;
  String createdBy;

  CategoryDataBank({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.createdAt,
    @required this.createdBy,
  });

  factory CategoryDataBank.empty() => CategoryDataBank(
        id: "",
        name: "",
        description: "",
        createdAt: getCurrentTime(),
        createdBy: auth.currentUser.emailId,
      );

  factory CategoryDataBank.fromMap({
    @required String id,
    @required Map data,
  }) {
    apiLogs("CategoryDataBank.fromMap Data : $data");
    try {
      return CategoryDataBank(
        id: id,
        name: data[APIKeys.name] ?? "",
        description: data[APIKeys.description] ?? "",
        createdAt: data[APIKeys.createdAt] ?? "",
        createdBy: data[APIKeys.createdBy] ?? "",
      );
    } catch (e, s) {
      apiLogs("CategoryDataBank.fromMap Exception : $e\n$s");
    }

    return CategoryDataBank.empty();
  }

  Map<String, dynamic> toMap() => {
        APIKeys.id: this.id,
        APIKeys.name: this.name,
        APIKeys.description: this.description,
        APIKeys.createdAt: this.createdAt,
        APIKeys.createdBy: this.createdBy,
      };

  log() {
    apiLogs("=======LogCategoryDataBank=======");
    this.toMap().forEach((k, v) {
      apiLogs("$k : $v");
    });
  }
}
