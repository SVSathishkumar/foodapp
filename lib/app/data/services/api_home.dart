import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHome {
  static const String baseUrl = "http://192.168.1.1:3000/";

  static Future<List<dynamic>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/items'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] != null && jsonData['data'].isNotEmpty) {
          return jsonData['data'];
        } else {
          return [];
        }
      } else {
        print("API Status Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("API Fetch Error: $e");
      return [];
    }
  }
}
