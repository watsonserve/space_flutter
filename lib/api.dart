import 'dart:convert';
import 'package:http/http.dart' as http;

final _origin = 'http://localhost:8088';

class StdPkg {
  final bool status;
  final String msg;
  final dynamic data;

  const StdPkg({required this.status, required this.msg, required this.data});

  factory StdPkg.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'status': bool status, 'msg': String msg, 'data': dynamic data} => StdPkg(
        status: status,
        msg: msg,
        data: data,
      ),
      _ => throw const FormatException('Failed to load stdpkg.'),
    };
  }
}

Future<List<String>> fetchPictures(int off, int rn) async {
  final response = await http.get(
    Uri.parse('$_origin/Pictures/'),
    headers: {
      'Range': 'items=$off-${off+rn}'
    }
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load album');
  }

  final resp = StdPkg.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  List<String> hashList = (resp.data as List).cast<String>();
  return hashList;
}

String getPreviewUrl(String key) => '$_origin/preview/$key.webp';
String getThumbwUrl(String key) => '$_origin/thumb/$key.webp';
