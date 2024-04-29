// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsideas/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:nsideas/home_page/home_page.dart';



class IVFUploader {
  String type,size,file_name;
  int file_messageId,thumbnail_messageId;
  String file_url,thumbnail_url;

  IVFUploader({
    required this.type,
    required this.file_url,
    required this.file_name,
    required this.size,
    required this.file_messageId,
    required this.thumbnail_url,
    required this.thumbnail_messageId,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "file_messageId": file_messageId,
    "file_name": file_name,
    "size": size,
    "file_url": file_url,
    "thumbnail_url": thumbnail_url,
    "thumbnail_messageId": thumbnail_messageId,
  };

  static IVFUploader fromJson(Map<String, dynamic> json) =>
      IVFUploader(
        file_messageId: json['file_messageId'] ?? 0, // Assuming messageId is an integer
        thumbnail_messageId: json['thumbnail_messageId'] ?? 0, // Assuming messageId is an integer
        type: json['type'] ?? "",
        file_name: json['file_name'] ?? "",
        file_url: json['file_url'] ?? "",
        size: json['size'] ?? "",
        thumbnail_url: json['thumbnail_url'] ?? "",
      );

  static List<IVFUploader> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class Uploader extends StatefulWidget {
  final String path;
  final bool allowMultiple;
  final FileType type;
  final List<IVFUploader>? ivf;

  final Function(List<IVFUploader>)? getIVF;


  Uploader({

    this.allowMultiple = false,
    required this.type,
    required this.path,
    this.getIVF,
    this.ivf,
  });

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  List<IVFUploader> ivf = [];


  bool _isDisposed = false;

  @override
  void initState() {

    super.initState();
    setData();
  }
  setData(){
    setState(() {
      if(widget.ivf!=null)ivf = widget.ivf!;

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
    String url = 'https://api.telegram.org/bot$token/sendPhoto';
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.type,
      allowMultiple: widget.allowMultiple,
    );

    if (result != null && result.files.isNotEmpty) {
      try {
        for (var file in result.files) {
          File pickedFile = File(file.path!);
          int fileSizeInBytes = pickedFile.lengthSync();
          int fileSizeInMegabytes =
              fileSizeInBytes ~/ (1024 * 1024); // Convert bytes to MB
          if ((fileSizeInMegabytes > 19) &&
              (file.path!.split(".").last == "pdf")) {
            String thumbnail_fileId = "";
            int thumbnail_messageId = 0;

            String fileName = file.name;
            Uint8List fileData = await pickedFile.readAsBytes();
            int fileSize = pickedFile.lengthSync();
            String fileUrl =
            await uploadFileToFirebaseStorage(fileName, fileData);
            Map<String, dynamic> result =
            await _getPdfImageAndUpload(file.path!);
            if (result.isNotEmpty) {
              thumbnail_messageId = result['thumbnail_messageId'];
              thumbnail_fileId = result['thumbnail_fileId'];
            }

            ivf.add(IVFUploader(
                size: formatFileSize(fileSize),
                file_url: fileUrl,
                file_name:fileName,
                thumbnail_messageId: thumbnail_messageId,
                file_messageId: 0,
                thumbnail_url: thumbnail_fileId, type: 'file'));
          } else {
            String url = widget.type == FileType.image
                ? 'https://api.telegram.org/bot$token/sendPhoto'
                : widget.type == FileType.video
                ? 'https://api.telegram.org/bot$token/sendVideo'
                : 'https://api.telegram.org/bot$token/sendDocument';

            var request = http.MultipartRequest('POST', Uri.parse(url));
            request.fields['chat_id'] = telegramId;
            String fieldKey = widget.type == FileType.image
                ? 'photo'
                : widget.type == FileType.video
                ? 'video'
                : 'document';
            request.files.add(
                await http.MultipartFile.fromPath(fieldKey, pickedFile.path));

            var response = await request.send();

            if (response.statusCode == 200) {
              final responseJson =
              json.decode(await response.stream.bytesToString());
              String fileId;

              if (widget.type == FileType.image) {
                fileId = responseJson['result']['photo'].last['file_id'];

                ivf.add(IVFUploader(
                  type: formatFileSize(int.parse(responseJson['result']["photo"]
                      .last['file_size']
                      .toString())),
                  file_url: fileId,
                  file_messageId: responseJson['result']['message_id'], thumbnail_url: '', thumbnail_messageId: 0,size: "", file_name: ''
                ));
              } else if (widget.type == FileType.video) {
                fileId = responseJson['result']['video']['file_id'];

                ivf.add(IVFUploader(
                  type: formatFileSize(int.parse(
                      responseJson['result']["video"]['file_size'].toString())),
                  file_url: fileId,
                  file_messageId: responseJson['result']['message_id'],
                  thumbnail_url: '', thumbnail_messageId: 0,size: "", file_name: ''
                ));
              } else {
                fileId = responseJson['result']["document"]['file_id'];

                String thumbnail_fileId = "";
                int thumbnail_messageId = 0;
                if (file.path!.split(".").last == "pdf") {
                  if (responseJson['result']["document"].containsKey('thumb')) {
                    thumbnail_fileId =
                    responseJson['result']["document"]['thumb']['file_id'];
                  } else {
                    Map<String, dynamic> result =
                    await _getPdfImageAndUpload(file.path!);
                    if (result.isNotEmpty) {
                      thumbnail_messageId = result['thumbnail_messageId'];
                      thumbnail_fileId = result['thumbnail_fileId'];
                    }
                  }
                }

                ivf.add(IVFUploader(
                    thumbnail_messageId: thumbnail_messageId,
                    size: formatFileSize(int.parse(responseJson['result']
                    ["document"]['file_size']
                        .toString())),
                    file_url: fileId.toString(),
                    file_name: responseJson['result']["document"]['file_name']
                        .toString(),
                    file_messageId: responseJson['result']['message_id'],
                    thumbnail_url: thumbnail_fileId, type: ''));
              }
            } else {
              print('Failed to send file. Status code: ${response.statusCode}');
              return null;
            }
          }
        }
      } catch (e) {
        print('Error: $e');
        return null;
      }
    } else {
      print('No file selected.');
      showToastText('No file selected.');
      return null;
    }
    setState(() {
      if (widget.getIVF != null && ivf.isNotEmpty) {
        widget.getIVF!(ivf);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(" Total : Files ${ivf.length}, IV ${ivf.length}"),
        if (ivf.isNotEmpty)
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: ivf.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return Row(
                  children: [

                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text("${ivf[index].file_messageId}"),
                            InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: ivf[index].file_url));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard'),
                                    ),
                                  );
                                },
                                child: Text("${ivf[index].file_url}")),
                            InkWell(
                              onTap: () async {
                                bool val = await deleteFileFromTelegramBot(
                                    ivf[index].file_messageId);
                                if(val) setState(() {
                                  ivf.removeAt(index);
                                });
                                else{
                                  showToastText("Not Deleted");
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Text(
                                    " Remove",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                          ],
                        )),
                  ],
                );
              }),

        InkWell(
          onTap: () {
            sendFileToTelegramBot();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload),
                if (widget.type == FileType.image)
                  Text(
                    " Upload Image${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20),
                  )
                else if (widget.type == FileType.video)
                  Text(
                    " Upload Video${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20),
                  )
                else
                  Text(
                    " Upload File${widget.allowMultiple ? 's' : ''}",
                    style: TextStyle(fontSize: 20),
                  )
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
