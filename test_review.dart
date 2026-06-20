import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final res = await http.get(Uri.parse('https://e-commerce-api-five-gilt.vercel.app/api/products/66a2e2645cc4b44ff1e13df9/reviews'));
  print(res.statusCode);
  print(res.body);
}
