import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../utils/constants/app_messages.dart';
import 'api_methods.dart';
import 'api_urls.dart';

class ApiClient {
  final String _baseUrl = baseUrl;

  final String _tagRequest = '====== Request =====>';
  final String _tagResponse = '====== Response =====>';

  final timeoutDuration = const Duration(seconds: 180);

  Future<Either<String, String>> apiClient({
    required String? path,
    Map<String, String>? header,
    required ApiMethod? method,
    Map<dynamic, dynamic>? body,
  }) async {
    final Map<String, String> headers =
        header ?? {'Content-Type': 'application/json'};

    http.Response? responseData;
    final url = _baseUrl + (path ?? '');
    appPrint(' $_tagRequest  $method   $url \n $headers');
    appPrint(' ${json.encode(body)}');

    try {
      switch (method) {
        case null:
          break;
        case ApiMethod.get:
          responseData = await http
              .get(Uri.parse(url), headers: headers)
              .timeout(timeoutDuration);
          break;
        case ApiMethod.post:
        case ApiMethod.postHeader:
          responseData = await http
              .post(Uri.parse(url), headers: headers, body: json.encode(body))
              .timeout(timeoutDuration);
          break;
        case ApiMethod.patch:
          responseData = await http
              .patch(Uri.parse(url), headers: headers, body: json.encode(body))
              .timeout(timeoutDuration);
          break;
        case ApiMethod.postMultipart:
          return const Left('Multipart requests are not supported here');
      }
    } on TimeoutException catch (e) {
      appPrint("res --->  $e");
      return const Left('Server timeout! try again later');
    } on SocketException catch (_) {
      appPrint("res --->  SocketException");
      return const Left('Please check your internet connection');
    } on http.ClientException catch (e) {
      // On web every network level failure (server down, wrong host/port,
      // missing CORS headers, mixed content) surfaces as "Failed to fetch".
      appPrint("res --->  ClientException $e");
      return Left(kIsWeb
          ? 'Unable to reach the server.\n\n'
              '• Make sure the API is running at $_baseUrl\n'
              '• The server must allow CORS for this origin\n'
              '(Open the browser console for the exact reason)'
          : 'Unable to reach the server. Please try again later');
    } catch (e) {
      appPrint("res --->  $e");
      return Left(e.toString());
    }

    if (responseData == null) {
      return const Left('No response received from server');
    }

    appPrint(
        '$_tagResponse ${responseData.statusCode} - $url \n ${responseData.body}');
    final int statusCode = responseData.statusCode;

    // 1. Success: any 2xx status code (200 OK, 201 Created, 204 No Content, etc.)
    if (statusCode >= 200 && statusCode < 300) {
      if (statusCode == 204 || responseData.body.isEmpty) {
        return const Right('{}');
      }
      return Right(responseData.body);
    }

    // 2. Try to extract a meaningful error message from the response body
    String? serverMessage;
    try {
      final dynamic decoded = jsonDecode(responseData.body);
      if (decoded is Map<String, dynamic>) {
        final dynamic msg = decoded['message'] ?? decoded['error'] ?? decoded['msg'];
        if (msg is String && msg.trim().isNotEmpty) {
          serverMessage = msg;
        } else if (msg is List && msg.isNotEmpty) {
          // Handles APIs that return an array of validation errors
          serverMessage = msg.map((e) => e.toString()).join(', ');
        } else if (decoded['errors'] != null) {
          serverMessage = decoded['errors'].toString();
        }
      }
    } catch (_) {
      // Body is not JSON (could be HTML or plain text, e.g. proxy/server errors)
      final String rawBody = responseData.body.trim();
      if (rawBody.isNotEmpty && !rawBody.startsWith('<') && rawBody.length < 150) {
        serverMessage = rawBody;
      }
    }

    // 3. Fallback to a clear, status-specific message if the server gave none
    if (serverMessage == null || serverMessage.isEmpty) {
      switch (statusCode) {
        case 400:
          serverMessage = 'Bad request. Please verify the submitted data.';
          break;
        case 401:
          serverMessage = 'Session expired or unauthorized. Please login again.';
          break;
        case 403:
          serverMessage = 'Access denied.';
          break;
        case 404:
          serverMessage = 'Requested service or resource not found (404).';
          break;
        case 422:
          serverMessage = 'Validation failed. Please check the entered fields.';
          break;
        default:
          serverMessage = statusCode >= 500
              ? 'Server error ($statusCode). Please try again later.'
              : 'Something went wrong ($statusCode).';
      }
    }

    return Left(serverMessage);
  }
}
