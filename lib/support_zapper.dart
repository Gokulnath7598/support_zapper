import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_service/api_service.dart';
import 'model/custom_exception.dart';
import 'model/device_info.dart';
import 'model/exception_type.dart';
import 'model/project_details.dart';
import 'model/token.dart';

class ExceptionHandler {
  static Token? _token;
  static final DeviceInfo _deviceInfo = DeviceInfo();
  static Map<String, dynamic>? _userDetails;

  static Future<void> initialize(
      {bool shouldCreateTicketsForExceptions = kDebugMode,
      required String organization,
      required String project,
      required String accessToken,
      required Map<String, dynamic> userDetails}) async {
    if (shouldCreateTicketsForExceptions) {
      try {
        ProjectDetails? projectDetails = ProjectDetails(
          versionControl: VersionControl.azureDevops,
          organization: organization,
          project: project,
          token: accessToken,
        );
        _userDetails = userDetails;
        _token = await ApiService.authorizeToProject(projectDetails);
        if (_token == null) {
          debugPrint(
            "\n*** 🚫 PROJECT DETAILS IS SUSPICIOUS, SUPPORT ZAPPER EXCEPTION LISTENER IS NOT INITIALIZED 💀 ***\n",
          );
          return;
        } else {
          if (Platform.isAndroid) {
            AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
            _deviceInfo
              ..id = info.id
              ..name = '${info.brand} ${info.model}'
              ..version = info.version.release
              ..type = 'Android';
          } else if (Platform.isIOS) {
            IosDeviceInfo info = await DeviceInfoPlugin().iosInfo;
            _deviceInfo
              ..name = '${info.name} ${info.model}'
              ..version = info.systemVersion
              ..type = 'IOS';
          }
          debugPrint(
            "\n*** ✅ AUTHORIZATION SUCCESSFUL, SUPPORT ZAPPER EXCEPTION LISTENER ENABLED 😎 ***\n",
          );
          _initializeExceptionHandler();
        }
      } on DioException catch (e) {
        debugPrint(
          "\n*** 🚫 SUPPORT ZAPPER Initiation failed $e 💀 ***\n",
        );
        return;
      } catch (e) {
        debugPrint(
          "\n*** 🚫 SUPPORT ZAPPER Initiation failed $e 💀 ***\n",
        );
        return;
      }
    }
  }

  static void _initializeExceptionHandler() async {
    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.dumpErrorToConsole(details);
      Object exception = details.exception;
      ExceptionType exceptionToBeThrown = ExceptionType.unKnownException;
      int? statusCode;
      dynamic response;
      dynamic request;
      String? exceptionMessage;
      String? exceptionPath = details.stack.toString().split('\n').first;
      if (exception is Exception) {
        if (exception is DioException) {
          response = exception.response?.data;
          request = {
            "method": exception.requestOptions.method,
            "path": exception.requestOptions.path,
            "headers": exception.requestOptions.headers,
            "data": exception.requestOptions.data,
          };
          if (exception.response?.statusCode == 401) {
            exceptionToBeThrown = ExceptionType.unAuthorized;
            statusCode = 401;
          } else if (exception.response?.statusCode == 404) {
            exceptionToBeThrown = ExceptionType.notFound;
            statusCode = 404;
          } else if (exception.response?.statusCode == 500) {
            exceptionToBeThrown = ExceptionType.internalServerError;
            statusCode = 500;
          } else if (exception.type == DioExceptionType.connectionTimeout) {
            exceptionToBeThrown = ExceptionType.connectionTimeout;
          } else if (exception.type == DioExceptionType.receiveTimeout) {
            exceptionToBeThrown = ExceptionType.receiveTimeout;
          } else if (exception.type == DioExceptionType.sendTimeout) {
            exceptionToBeThrown = ExceptionType.sendTimeout;
          } else {
            exceptionToBeThrown = ExceptionType.unKnownDioException;
          }
        } else {
          exceptionMessage = exception.toString();
        }
      } else if (exception is FlutterError) {
        if (exception.message.toLowerCase().contains(
              'renderflex overflowed by',
            )) {
          exceptionToBeThrown = ExceptionType.renderFlexOverflow;
          exceptionMessage = exception.message;
        } else {
          exceptionMessage = exception.toString();
        }
      } else {
        if(exception.toString().toLowerCase().contains('null check operator used on a null value')){
          exceptionToBeThrown = ExceptionType.nullError;
        }
        exceptionMessage = exception.toString();
      }
      if (_token != null) {
        try {
          int? adoId = await ApiService.createBugTicket(
            exception: CustomException(
              exceptionPath: exceptionPath,
              type: exceptionToBeThrown,
              statusCode: statusCode,
              exceptionMessage: exceptionMessage,
              response: response,
              request: request,
              deviceInfo: _deviceInfo,
              userInfo: _userDetails ?? {},
            ),
            token: _token!,
          );
          if (adoId != null) {
            debugPrint(
              "\n*** 🐞 SUPPORT ZAPPER TICKET Logged Successfully $adoId 🐞 ***\n",
            );
          } else {
            debugPrint(
              "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed 💀 ***\n",
            );
          }
        } on DioException catch (e) {
          debugPrint(
            "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed $e 💀 ***\n",
          );
        } catch (e) {
          debugPrint(
            "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed $e 💀 ***\n",
          );
        }
      }
    };
  }

  static Future<int?> createTicket({required String message}) async {
    if (_token != null) {
      try {
        int? adoId = await ApiService.createBugTicket(
          exception: CustomException(
            type: ExceptionType.custom,
            exceptionMessage: message,
            deviceInfo: _deviceInfo,
            userInfo: _userDetails ?? {},
          ),
          token: _token!,
        );
        if (adoId != null) {
          debugPrint(
            "\n*** 🐞 SUPPORT ZAPPER TICKET Logged Successfully ID $adoId 🐞 ***\n",
          );
          return adoId;
        } else {
          debugPrint(
            "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed 💀 ***\n",
          );
        }
      } on DioException catch (e) {
        debugPrint(
          "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed $e 💀 ***\n",
        );
      } catch (e) {
        debugPrint(
          "\n*** 🚫 SUPPORT ZAPPER Ticket Logging failed $e 💀 ***\n",
        );
      }
    }
    return null;
  }
}
