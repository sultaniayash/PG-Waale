import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qbix/utils/a_utils.dart';

class DownloadFile {
  static var httpClient = new HttpClient();

  static Future<File> downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}

class FileService {
  static String getFileTypeFormName(String fileName) {
    if (fileName == null) return AppFileType.TEXT;

    if (fileName.isEmpty) return AppFileType.TEXT;

    String fileExtension = fileName.split(".")?.last?.toLowerCase();

    if (fileExtension == null) return "";
    if (fileExtension.isEmpty) return "";

    if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') return AppFileType.IMAGE;
    if (fileExtension == 'mp4' || fileExtension == 'avi' || fileExtension == 'm4v') return AppFileType.VIDEO;
    if (fileExtension == 'pdf') return AppFileType.PDF;
    return AppFileType.FILE;
  }

  static Future<File> selectImage({@required ImageSource source}) async {
    File file;
    file = await ImagePicker.pickImage(source: source);
    return file;
  }

  static Future<File> selectFile({String fileExtension}) async {
    File file = await FilePicker.getFile(fileExtension: fileExtension);
    return file;
  }
}
