// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsideas/functions.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/home_page/home_page.dart';

class FileUploader {
  String size;
  String thumbnailUrl;
  String fileUrl;
  int fileMessageId, thumbnailMessageId;
  String fileName;
  String type;

  FileUploader({
    required this.size,
    required this.thumbnailUrl,
    required this.fileUrl,
    required this.fileMessageId,
    required this.thumbnailMessageId,
    required this.fileName,
    required this.type, // Added required for the 'type' parameter
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'thumbnailUrl': thumbnailUrl,
      'fileUrl': fileUrl,
      'fileMessageId': fileMessageId,
      'thumbnailMessageId': thumbnailMessageId,
      'fileName': fileName,
      'type': type, // Include 'type' field
    };
  }

  factory FileUploader.fromJson(Map<String, dynamic> json) {
    return FileUploader(
      size: json['size'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      fileMessageId: json['fileMessageId'] ?? 0,
      thumbnailMessageId: json['thumbnailMessageId'] ?? 0,
      fileName: json['fileName'] ?? '',
      type: json['type'] ?? '', // Include 'type' field
    );
  }

  static List<FileUploader> fromMapList(List<dynamic> list) {
    return list.map((item) => FileUploader.fromJson(item)).toList(); // Changed fromJson to FileUploader.fromJson
  }
}

String getFileType(String name) {
  List<String> imageExtensions = [
    "png",
    "jpeg",
    "jpg",
    "gif",
    "bmp",
    "tiff",
    "tif",
    "eps",
    "raw"
  ];
  List<String> videoExtensions = [
    "mp4",
    "avi",
    "mkv",
    "mov",
    "wmv",
    "flv",
    "mpg",
    "mpeg",
    "webm"
  ];

  String extension = name.split(".").last.toLowerCase();

  if (imageExtensions.contains(extension))
    return 'image';
  else if (videoExtensions.contains(extension)) return 'video';

  return 'document';
}

class Uploader extends StatefulWidget {
  final String path;

  final bool isTempMode;
  final List<FileUploader>? IVF;
  final bool allowMultiple;
  final FileType type;

  final Function(List<FileUploader>)? getIVF;

  Uploader(
      {this.allowMultiple = false,
        required this.type,
        this.IVF,
        this.isTempMode=false,
        required this.path,
        this.getIVF});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  bool isLoading = false;
  String process = "Not Selected";
  List<FileUploader> files = [];

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    setData();
    // de();
  }

// de() async {
//   for(int i =85;i<107;i++){
//     String url = 'https://api.telegram.org/bot$sub_esrkr/deleteMessage';
//     Map<String, dynamic> body = {
//       'chat_id': telegramId,
//       'message_id': i,
//     };
//
//     var response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(body),
//     );
//
//     if (response.statusCode == 200) {
//   showToastText("Deleted : $i");
//     } else {
//       print(
//           'Failed to delete file from Telegram bot. Status code: ${response.statusCode}');
//
//
//     }
//   }
// }
  setData() {
    setState(() {
      if (widget.IVF != null) files = widget.IVF!;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<Map<String, dynamic>> _getPdfImageAndUpload(String pdfPath) async {
    final document = await PdfDocument.openFile(pdfPath);
    final page = await document.getPage(1);
    final pageImage = await page.render(width: page.width, height: page.height);
    final imageData = pageImage!.bytes;
    await document.close();
    if (!_isDisposed) {
      final result = await uploadImageToTelegram(imageData);
      if (result.isNotEmpty) {
        String thumbnail_fileId = result['thumbnail_fileId'];
        int thumbnail_messageId = result['thumbnail_messageId'];
        return {
          'thumbnail_messageId': thumbnail_messageId,
          "thumbnail_fileId": thumbnail_fileId
        };
      } else {
        showToastText('Failed to upload image from PDF');
        return {};
      }
    }

    return {};
  }

  Future<Map<String, dynamic>> uploadImageToTelegram(
      Uint8List imageData) async {
    var file = File(
        '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(imageData);
    String url = 'https://api.telegram.org/bot${widget.isTempMode?testingToken:token}/sendPhoto';
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['chat_id'] = telegramId;
    request.files.add(await http.MultipartFile.fromPath(
      'photo', // field name
      file.path, // path to the image file
    ));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseJson = json.decode(await response.stream.bytesToString());
      String? thumbnail_fileId =
      responseJson['result']['photo'].last['file_id'];
      int thumbnail_messageId = responseJson['result']['message_id'];

      await file.delete();

      return {
        'thumbnail_messageId': thumbnail_messageId,
        'thumbnail_fileId': thumbnail_fileId
      };
    } else {
      print('Failed to upload image to Telegram: ${response.statusCode}');
      return {}; // Return an empty map if there's an error
    }
  }

  Future<String> uploadFileToFirebaseStorage(
      String fileName, Uint8List fileData) async {
    try {
      Reference storageReference =
      FirebaseStorage.instance.ref().child(widget.path).child(fileName);
      await storageReference.putData(fileData);
      String fileUrl = await storageReference.getDownloadURL();

      print('Uploaded file URL: $fileUrl');
      return fileUrl;
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
      throw e;
    }
  }

  sendFileToTelegramBot() async {
    int fileNo = 0;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.type,
      allowMultiple: widget.allowMultiple,
    );
    if (result != null && result.files.isNotEmpty) {
      try {
        for (var file in result.files) {
          setState(() {
            isLoading = true;
          });
          String type = getFileType(file.name);
          File pickedFile = File(file.path!);
          int fileSizeInBytes = pickedFile.lengthSync();
          int fileSizeInMegabytes =
              fileSizeInBytes ~/ (1024 * 1024); // Convert bytes to MB
          setState(() {
            process = "Uploading ${++fileNo}/${result.files.length}";
          });
          if (fileSizeInMegabytes > 19 && widget.type == FileType.any) {
            String thumbnail_fileId = "";
            int thumbnail_messageId = 0;
            String fileName = file.name;
            Uint8List fileData = await pickedFile.readAsBytes();
            int fileSize = pickedFile.lengthSync();
            String fileUrl =
            await uploadFileToFirebaseStorage(fileName, fileData);
            Map<String, dynamic> pdfResult =
            await _getPdfImageAndUpload(file.path!);
            if (pdfResult.isNotEmpty) {
              thumbnail_messageId = pdfResult['thumbnail_messageId'];
              thumbnail_fileId = pdfResult['thumbnail_fileId'];
            }

            files.add(FileUploader(
              size: formatFileSize(fileSize),
              fileUrl: fileUrl,
              thumbnailMessageId: thumbnail_messageId,
              fileName: fileName,
              fileMessageId: 0,
              thumbnailUrl: thumbnail_fileId,
              type: type,
            ));
          } else {
            String url = type == "image"
                ? 'https://api.telegram.org/bot${widget.isTempMode?testingToken:token}/sendPhoto'
                : type == "video"
                ? 'https://api.telegram.org/bot${widget.isTempMode?testingToken:token}/sendVideo'
                : 'https://api.telegram.org/bot${widget.isTempMode?testingToken:token}/sendDocument';

            var request = http.MultipartRequest('POST', Uri.parse(url));
            request.fields['chat_id'] = telegramId;
            String fieldKey;

            if (type == "image") {
              fieldKey = 'photo';
            } else if (type == "video") {
              fieldKey = 'video';
            } else {
              fieldKey = 'document';
            }
            request.files.add(
              await http.MultipartFile.fromPath(fieldKey, pickedFile.path),
            );
            var response = await request.send();
            if (response.statusCode == 200) {
              final responseJson =
              json.decode(await response.stream.bytesToString());
              
              if (type == "image") {
                files.add(FileUploader(
                    thumbnailMessageId: 0,
                    thumbnailUrl: "",
                    fileUrl: responseJson['result']['photo'].last['file_id'],
                    fileMessageId: responseJson['result']['message_id'],
                    fileName: file.name,
                    type: "image",
                    size: formatFileSize(int.parse(responseJson['result']
                    ["photo"]
                        .last['file_size']
                        .toString()))));
              } else if (type == "video") {
                files.add(FileUploader(
                  thumbnailMessageId: 0,
                  thumbnailUrl: "",
                  fileUrl: responseJson['result']['video']['file_id'].toString(),
                  fileMessageId: responseJson['result']['message_id'],
                  fileName: file.name,
                  type: "video",
                  size: formatFileSize(int.parse(
                      responseJson['result']["video"]['file_size'].toString())),
                ));
              } else {
                String thumbnail_fileId = "";
                int thumbnail_messageId = 0;
                if (file.path!.split(".").last.toLowerCase() == "pdf") {
                  if (responseJson['result']["document"]
                      .containsKey('thumbnail')) {
                    thumbnail_fileId = responseJson['result']["document"]
                    ['thumbnail']['file_id'];
                  } else {
                    Map<String, dynamic> pdfResult =
                    await _getPdfImageAndUpload(file.path!);
                    if (pdfResult.isNotEmpty) {
                      thumbnail_messageId = pdfResult['thumbnail_messageId'];
                      thumbnail_fileId = pdfResult['thumbnail_fileId'];
                    }
                  }
                }
                files.add(FileUploader(
                  thumbnailMessageId: thumbnail_messageId,
                  size: formatFileSize(int.parse(responseJson['result']
                  ["document"]['file_size']
                      .toString())),
                  fileUrl: responseJson['result']["document"]['file_id'].toString(),
                  fileName: responseJson['result']["document"]['file_name']
                      .toString(),
                  fileMessageId: responseJson['result']['message_id'],
                  thumbnailUrl: thumbnail_fileId,
                  type: type,
                ));
              }
            } else {
              setState(() {
                process =
                'Failed to send file. Status code: ${response.statusCode}';
                print(
                    "Failed to send file. Status code: ${response.statusCode}");
              });
              return null;
            }
          }
          setState(() {
            process = "Done ${fileNo}/${result.files.length}";
          });
        }
      } catch (e) {
        setState(() {
          process = "Error : $e";
          print("Error :$e");
        });
        return null;
      }
    } else {
      setState(() {
        process = 'No file selected.';
      });
      showToastText('No file selected.');
      return null;
    }
    setState(() {
      if (files.isNotEmpty) {
        isLoading = false;
        widget.getIVF!(files);
        process = "Uploading Done!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            "Process : $process",
            style: TextStyle(color: Colors.white60),
          ),
        ),
        if (files.isNotEmpty)ReorderableListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          children: List.generate(
              files.length,
                  (index) => Container(
                padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                margin: EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10)
                ),
                key: ValueKey(index),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${files[index].fileName}",
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "   ${files[index].size} ",
                                style: TextStyle(color: Colors.white),
                                maxLines: 1,
                              )
                            ],
                          ),
                          InkWell(
                              onTap: () async {
                                if (isOwner()) {
                                  if (files[index]
                                      .fileUrl
                                      .startsWith("https://")) {
                                    Clipboard.setData(ClipboardData(
                                        text: files[index].fileUrl));
                                  } else {
                                    String url = await getFileUrl(
                                        files[index].fileUrl);
                                    Clipboard.setData(
                                        ClipboardData(text: url));
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard'),
                                    ),
                                  );
                                } else {
                                  showToastText("U Can't Copy");
                                }
                              },
                              child: Text(
                                "${files[index].fileUrl}",
                                style: TextStyle(color: Colors.white54),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await deleteFileFromTelegramBot(
                            files[index].fileMessageId);
                        await deleteFileFromTelegramBot(
                            files[index].thumbnailMessageId);

                        setState(() {
                          files.removeAt(index);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              )
          ),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              files.insert(newIndex, files.removeAt(oldIndex));
              widget.getIVF != files;
            });
          },
        ),
        InkWell(
          onTap: () {
            if (isAnonymousUser()) {
              showToastText("Please log in with your college ID.");
              return;
            }
            sendFileToTelegramBot();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.upload,
                  color: Colors.white60,
                ),
                if (widget.type == FileType.image)
                  Text(
                    " Upload Image${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                else if (widget.type == FileType.video)
                  Text(
                    " Upload Video${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                else
                  Text(
                    " Upload File${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                if (isLoading)
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange,
                      ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}


Future<bool> deleteFileFromTelegramBot(int messageId) async {
  String url = 'https://api.telegram.org/bot$token/deleteMessage';
  Map<String, dynamic> body = {
    'chat_id': telegramId,
    'message_id': messageId.toString(),
  };

  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print(
        'Failed to delete file from Telegram bot. Status code: ${response.statusCode}');
    return false;
  }
}
String formatFileSize(int fileSizeInBytes) {
  const int KB = 1024;
  const int MB = KB * 1024;
  const int GB = MB * 1024;

  if (fileSizeInBytes >= GB) {
    return '${(fileSizeInBytes / GB).toStringAsFixed(2)} GB';
  } else if (fileSizeInBytes >= MB) {
    return '${(fileSizeInBytes / MB).toStringAsFixed(2)} MB';
  } else if (fileSizeInBytes >= KB) {
    return '${(fileSizeInBytes / KB).toStringAsFixed(2)} KB';
  } else {
    return '$fileSizeInBytes bytes';
  }
}
