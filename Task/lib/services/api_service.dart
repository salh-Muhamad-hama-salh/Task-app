import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://127.0.0.1:3000/api/tasks';

  // Get all tasks
  static Future<List<dynamic>> getAllTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Create new task
  static Future<Map<String, dynamic>?> createTask(
      Map<String, dynamic> taskData) async {
    try {
      print('Sending task data: ${json.encode(taskData)}');
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskData),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            'Failed to create task: ${errorData['message'] ?? response.body}');
      }
    } catch (e) {
      print('Error creating task: $e');
      return null;
    }
  }

  // Update task
  static Future<Map<String, dynamic>?> updateTask(
      String id, Map<String, dynamic> taskData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskData),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error updating task: $e');
      return null;
    }
  }

  // Delete task
  static Future<bool> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  // Toggle task completion
  static Future<Map<String, dynamic>?> toggleCompletion(String id) async {
    try {
      final response = await http.patch(Uri.parse('$baseUrl/$id/toggle'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to toggle task');
      }
    } catch (e) {
      print('Error toggling task: $e');
      return null;
    }
  }
}
