import 'dart:convert';

import 'package:device_tracking_flutter_app/core/api/status_code.dart';

// ignore_for_file: avoid_dynamic_calls, unnecessary_lambdas
// ignore_for_file: public_member_api_docs, sort_constructors_first
class WrgResponse<T> {
  final T? data;
  final ApiError? error;
  WrgResponse({this.data, this.error});

  bool get isSuccess => data != null;
}

class ApiMessage {
  final String message;
  ApiMessage({required this.message});

  factory ApiMessage.fromMap(Map<String, dynamic> map) {
    return ApiMessage(message: map['message']);
  }
}

class ApiError {
  final StatusCode status;
  final String name;
  final String message;
  final List<FieldError>? details;

  ApiError({
    required this.status,
    required this.name,
    required this.message,
    this.details,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'name': name,
      'message': message,
      'details': details?.map((x) => x.toMap()).toList(),
    };
  }

  factory ApiError.fromMap(Map<String, dynamic> map) {
    return ApiError(
      status: map['status'],
      name: map['name'],
      message: map['message'],
      details:
          !map.containsKey('details') || !map['details'].containsKey('errors')
          ? null
          : map['details']['errors'].map<FieldError>((detail) {
              return FieldError.fromMap(detail);
            }).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiError.fromJson(String source) =>
      ApiError.fromMap(json.decode(source) as Map<String, dynamic>);
}

class FieldError {
  final List<String> path;
  final String message;
  final String name;
  FieldError({required this.path, required this.message, required this.name});

  factory FieldError.fromMap(Map<String, dynamic> map) {
    final error = FieldError(
      path: (map['path'] as List).map((e) {
        return '$e';
      }).toList(),
      message: map['message'] as String,
      name: map['name'] as String,
    );
    return error;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'path': path, 'message': message, 'name': name};
  }

  String toJson() => json.encode(toMap());

  factory FieldError.fromJson(String source) =>
      FieldError.fromMap(json.decode(source) as Map<String, dynamic>);
}
