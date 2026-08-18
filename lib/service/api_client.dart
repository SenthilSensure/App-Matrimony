import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
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

  Future<Either<String, String>> apiClient(
      {required String? path,
        Map<String, String>? header,
        required ApiMethod? method,
        Map<dynamic, dynamic>? body}) async {

    /// Check internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());

    // if (connectivityResult != ConnectivityResult.mobile &&
    //     connectivityResult != ConnectivityResult.wifi) {
    //   return const Left('Please check your internet connection');
    // }

    Map<String, String> headers;
    if (header == null) {
      headers = {'Content-Type': 'application/json'};
    } else {
      headers = header;
    }

    var responseData;
    final url = _baseUrl + path!;
    appPrint(' $_tagRequest  $method   $url \n $headers');
    appPrint(' ${json.encode(body)}');

    try {
      switch (method) {
        case null:
          {}
          break;
        case ApiMethod.get:
          {
            responseData = await http
                .get(Uri.parse(url), headers: headers)
                .timeout(timeoutDuration);
          }
          break;
        case ApiMethod.post:
          {
            responseData = await http
                .post(Uri.parse(url), headers: headers, body: json.encode(body))
                .timeout(timeoutDuration);
          }
          break;
        case ApiMethod.patch:
          {
            responseData = await http
                .patch(Uri.parse(url), headers: headers, body: json.encode(body))
                .timeout(timeoutDuration);
          }
          break;
        case ApiMethod.postHeader:
          {
            responseData = await http
                .post(Uri.parse(url), headers: headers, body: json.encode(body))
                .timeout(timeoutDuration);
          }
          break;
        case ApiMethod.postMultipart:
          break;
      }
    } on TimeoutException catch (e) {
      appPrint("res --->  $e");
      return const Left('Server timeout! try again later');
    } on SocketException catch (_) {
      appPrint("res --->  SocketException $responseData");
      return const Left('Please check your internet connection');
    } catch (e) {
      appPrint("res --->  $e");
      return Left(e.toString());
    }
    appPrint("res --->  $responseData");

    appPrint(
        '$_tagResponse ${responseData.statusCode} - $url \n ${responseData.body}');
    if (responseData.statusCode == 200) {
      return Right(responseData.body);
    } else if (responseData.statusCode == 400) {
      Map<String, dynamic> res = jsonDecode(responseData.body);
      return Left(res['message'] ?? 'Something went wrong');
    } else if (responseData.statusCode == 201) {
      Map<String, dynamic> res = jsonDecode(responseData.body);
      return Left(res['message'] ?? 'Something went wrong');
    } else if (responseData.statusCode == 204) {
      return const Left('No Data available');
    } else if (responseData.statusCode == 422) {
      Map<String, dynamic> res = jsonDecode(responseData.body);
      return Left(res['message'] ?? 'Something went wrong');
    } else if (responseData.statusCode == 206) {
      return const Left('errorResponse.message');
    } else {
      Map<String, dynamic> res = jsonDecode(responseData.body);
      return Left(res['message'] ?? 'Server down! Try later');
    }
  }
}
