import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_it/share_it.dart';

class Photo extends StatefulWidget {
  final String url;
  final String docName, extension;
  Photo(this.url, this.docName, this.extension);

  static var httpClient = new HttpClient();

  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  File file1;

  Future<File> _downloadFile(String url, String filename) async {
    var request = await Photo.httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename' + '.' + widget.extension);
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Spectra Associates',
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                file1 = await _downloadFile(widget.url, widget.docName);
                ShareIt.file(path: file1.path, type: ShareItFileType.image);
              },
            ),
          ],
        ),
        body: Container(
          child: CachedNetworkImage(
            imageUrl: widget.url,
            placeholder: (context, url) => Center(
              child: new CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
        ));
  }
}
