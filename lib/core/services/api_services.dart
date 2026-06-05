import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/check_in/models/scanned_employee.dart';

class ApiService {
  
  static const String baseUrl = 'http://192.168.1.186:8000/api/v1';

  // 1. Fetch employee details when QR code is scanned
  Future<ScannedEmployee> fetchEmployee(String qrPayload) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/employees/$qrPayload'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return ScannedEmployee.fromJson(data);
      } else {
        throw Exception('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 2. Submit the clock-in request to Laravel
  Future<bool> submitClockIn(String employeeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clock/in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'employee_id': employeeId,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}