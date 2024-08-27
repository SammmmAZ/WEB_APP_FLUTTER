import 'package:http/http.dart' as http;

String url = "http://localhost:8080";

Future<String> fetchInventory() async {
  final response = await http.get(Uri.parse(url));
  return response.body;
}

void main(List<String> args) {
  fetchInventory().then(
    (value) {
      print(value);
    },
  );
}
