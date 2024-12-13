import 'package:dio/dio.dart';

import '../constants/constants.dart';

extension ResponseExtension on Response {
  DioException toDioException() {
    return DioException.badResponse(
        statusCode: statusCode!,
        requestOptions: requestOptions,
        response: this);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}
