// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class NetworkUtility {
  Future<String?> fetchUrl(Uri uri, {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    return null;
  }
}
