import 'package:dio/dio.dart';

import '../model/custom_exception.dart';
import '../model/project_details.dart';
import '../model/token.dart';

class ApiService {
  static final Dio _dioClient = Dio()
    ..options.baseUrl = "https://support-zapper.onrender.com/api/v1";

  static Future<Token?> authorizeToProject(ProjectDetails project) async {
    final Map<String, dynamic> data = {
      'organization': project.organization,
      'project': project.project,
      'token': project.token,
    };

    Response<Map<String, dynamic>?> response =
        await _dioClient.post<Map<String, dynamic>?>(
      '/authorize',
      data: data,
    );

    if (response.data != null) {
      return Token.fromJson(
        response.data!,
      );
    }

    return null;
  }

  static Future<int?> createBugTicket({
    required CustomException exception,
    required Token token,
  }) async {
    final Map<String, dynamic> data = {
      "bug": {
        "message": exception.message,
        "type": exception.type.name,
        "error_path": exception.exceptionPath,
        "error_details": {
          "status_code": exception.statusCode,
          "response": exception.response,
          "request": exception.request,
        },
        "customer_info": exception.userInfo,
        "device_info": exception.deviceInfo.toJson(),
      },
    };

    Response<Map<String, dynamic>?> response =
        await _dioClient.post<Map<String, dynamic>?>(
      '/create_ticket',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${token.token}',
        },
      ),
    );

    if (response.data != null) {
      return response.data?['ado_id'] as int;
    }

    return null;
  }
}
