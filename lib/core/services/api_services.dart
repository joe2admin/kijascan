import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/check_in/models/scanned_employee.dart';
import '../../features/clocked_in/models/clocked_in_record.dart';
import '../../features/history/models/history_record.dart';
import '../../utils/constants/app_constant.dart';

class ApiService {
  static String get baseUrl => ApiConstants.baseUrl;

  /// Resolves a Laravel image path or URL to a full network URL.
  /// Handles: null, already-full URLs, and relative /storage/... paths.
  static String? resolveImageUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    final baseHost = baseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');
    final path = raw.startsWith('/') ? raw : '/$raw';
    // If the path doesn't start with /storage, and it's just profile_pictures/xxx
    if (!path.startsWith('/storage/')) {
      return '$baseHost/storage$path';
    }
    return '$baseHost$path';
  }

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
      } else if (response.statusCode == 404) {
        throw Exception('Failed to load employee');
      } else {
        throw Exception('Failed to load employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load employee');
    }
  }

  // 2. Submit clock-in request
Future<bool> submitClockIn(String employeeId) async {
  try {
    final now = DateTime.now();

    // Format date as YYYY-MM-DD
    final attendanceDate =
        "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";

    // Determine shift
    final hour = now.hour;
    final shift = (hour >= 7 && hour < 16) ? 'day' : 'night';

    final response = await http.post(
      Uri.parse('$baseUrl/clock/in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'employee_id': employeeId,
        'attendance_date': attendanceDate,
        'shift': shift,
      }),
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
      final response = await http.get(Uri.parse('$baseUrl/clock/active'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> data = responseJson['data'] ?? [];
        return data
            .map(
              (item) => ClockedInRecord.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to load active clocks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // 5. Fetch clock history (completed shifts)
  Future<List<HistoryRecord>> fetchHistory() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clock/history'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        final List<dynamic> data = responseJson['data'] ?? [];
        return data
            .map((item) => HistoryRecord.fromJson(item as Map<String, dynamic>))
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
          'employee_ids': employeeIds
              .map((id) => int.tryParse(id) ?? 0)
              .toList(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
