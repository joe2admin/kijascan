import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/check_in/models/scanned_employee.dart';
import '../../features/clocked_in/models/clocked_in_record.dart';
import '../../features/history/models/history_record.dart';
import '../../utils/constants/app_constant.dart';

class ApiService {
  static String get baseUrl => ApiConstants.baseUrl;

  // 1. Fetch employee details when QR code is scanned
  Future<ScannedEmployee> fetchEmployee(String qrPayload) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/employees/$qrPayload'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final Map<String, dynamic> employeeData = responseJson['data'] ?? {};
        return ScannedEmployee.fromJson(employeeData);
      } else {
        throw Exception('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 2. Submit clock-in request
  Future<bool> submitClockIn(String employeeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clock/in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'employee_id': employeeId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 3. Submit clock-out request for a single employee
  Future<bool> submitClockOut(String employeeId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clock/out'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'employee_id': employeeId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 4. Fetch all currently clocked-in employees (active shifts)
  Future<List<ClockedInRecord>> fetchActiveClockedIn() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clock/active'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> data = responseJson['data'] ?? [];
        return data
            .map((item) =>
                ClockedInRecord.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
            'Failed to load active clocks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 5. Fetch clock history (completed shifts)
  Future<List<HistoryRecord>> fetchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clock/history'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> data = responseJson['data'] ?? [];
        return data
            .map((item) =>
                HistoryRecord.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load history: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 6. Bulk clock-out: clock out multiple employees at once
  Future<bool> submitBulkClockOut(List<String> employeeIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clock/bulk-out'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'employee_ids': employeeIds.map((id) => int.tryParse(id) ?? 0).toList(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
