
import 'device_info.dart';
import 'exception_type.dart';

class CustomException implements Exception {
  CustomException({
    required this.type,           // Type of Exception
    String? exceptionMessage,     // Exception's Message/Description
    required this.deviceInfo,     // Device's Info
    required this.userInfo,       // User's Info
    this.response,                // Api Response, if Exception is a DioException
    this.request,                 // Api Request, if Exception is a DioException
    this.statusCode,              // Api Response code, if Exception is a DioException
  }) : message = (exceptionMessage != null && exceptionMessage.isNotEmpty)
            ? exceptionMessage
            : type == ExceptionType.unAuthorized
                ? 'Unauthorized'
                : type == ExceptionType.notFound
                    ? 'Resource Not Found'
                    : type == ExceptionType.connectionTimeout
                        ? 'Connection Timeout'
                        : type == ExceptionType.internalServerError
                            ? 'Internal Server Error'
                            : type == ExceptionType.receiveTimeout
                                ? 'Receive Timeout'
                                : type == ExceptionType.sendTimeout
                                    ? 'Send Timeout'
                                    : type == ExceptionType.unKnownDioException
                                        ? 'Unknown Dio Exception'
                                        : type == ExceptionType.unKnownException
                                            ? 'Unknown Exception'
                                            : 'Unknown Exception';

  final ExceptionType type;
  final String message;
  final int? statusCode;
  final dynamic response;
  final dynamic request;
  final Map<String, dynamic> userInfo;
  final DeviceInfo deviceInfo;

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'status_code': statusCode,
      'response': response,
      'request': request,
      'user_info': userInfo,
      'device_info': deviceInfo.toJson(),
    };
  }
}
