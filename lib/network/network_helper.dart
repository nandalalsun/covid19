import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper{
 final String url;
  NetworkHelper({this.url});

  Future<dynamic> getData() async {
    print('url is: $url');
    http.Response response =
        await http.get('$url');
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
    return null;
  }

}
