import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app_prefs.dart';
import '../../init_dependencies.dart';
import '../common/cubits/app_user/app_user_cubit.dart';
import '../constants/constants.dart';
import '../utils/get_unix_timestamp.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";

const String TOKEN = 'token';
const String USER_ID = "user_id";
const String REFRESH_TOKEN = 'refreshToken';
const String EXPIRES_IN = "expiresIn";

class DioFactory {
  final AppPreferences appPreferences;

  DioFactory(this.appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    // String language = await _appPreferences.getAppLanguage();
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
    };

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: headers,
      receiveTimeout: Constants.apiTimeOut,
      sendTimeout: Constants.apiTimeOut,
    );

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        // requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ));
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.uri.path != '/auth/login' &&
            options.uri.path != '/auth/refresh-token' &&
            !(options.uri.path == '/users' && options.method == "POST")) {
          // get access token and expiresIn timestamp.
          String token = await appPreferences.getToken();
          int expiresIn = await appPreferences.getExpiresIn();

          AppUserCubit appUserCubit = serviceLocator<AppUserCubit>();
          int userId = appUserCubit.state is AppUserLoggedIn
              ? (appUserCubit.state as AppUserLoggedIn).user.id
              : 0;
          // cancel if token is empty.
          if (token.trim().isEmpty) {
            appUserCubit.updateUser(null);
            return;
          }

          // refresh refreshToken if it was expired.
          bool success = await refreshRefreshToken(dio, token, expiresIn);
          if (!success) return;

          // attract access token to send request.
          options.headers[AUTHORIZATION] = 'Bearer $token';
          options.headers[USER_ID] = userId;
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        // check unauthorized request error.
        if (error.response?.statusCode == 400 &&
            (error.response?.data['error'] ==
                    "Your refresh token is still valid." ||
                error.response?.data['error'] == "Refresh token is invalid.")) {
          await deleteAllUserInfo();
        }
        if (error.response?.statusCode == 401) {
          // refresh access token.
          bool success = await refreshToken(dio);

          // retry sending request.
          if (success) {
            return handler.resolve(await _retry(error.requestOptions, dio));
          }
        }
        handler.resolve(Response(
            requestOptions: error.requestOptions,
            statusCode: error.response?.statusCode,
            data: error.response?.data));
      },
    ));

    return dio;
  }

  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, Dio dio) async {
    final token = await appPreferences.getToken();

    // delete user state if token is null.
    if (token.isEmpty) serviceLocator<AppUserCubit>().updateUser(null);

    // send request with same options.
    final options = Options(
        method: requestOptions.method,
        headers: {...requestOptions.headers, AUTHORIZATION: token});
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken(Dio dio) async {
    final refreshToken = await appPreferences.getRefreshToken();
    final expiresIn = await appPreferences.getExpiresIn();

    final unixTimestamp = getCurrentUnixTimestamp();

    // refresh access token if it is not expired.
    if (unixTimestamp < expiresIn) {
      await appPreferences.setToken(Constants.empty);

      final res = await dio
          .post('auth/refresh-token', data: {"refreshTokenId": refreshToken});

      // save token.
      if (res.statusCode == 200) {
        await appPreferences.setToken(res.data[TOKEN]);
      } else {
        // delete token if refresh token fail.
        await deleteAllUserInfo();
        return false;
      }
    } else {
      // return false if the refresh token was expired.
      return false;
    }

    return true;
  }

  Future<bool> refreshRefreshToken(Dio dio, String token, int expiresIn) async {
    if (token.isEmpty) {
      await deleteAllUserInfo();
      return false;
    }

    int userId =
        (serviceLocator<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final unixTimestamp = getCurrentUnixTimestamp();

    if (unixTimestamp > expiresIn) {
      appPreferences.setExpiresIn(unixTimestamp + 5);

      dio.options.headers[AUTHORIZATION] = token;
      final res = await dio.get('auth/refresh-token/$userId');
      if (res.statusCode == 200) {
        await appPreferences.setRefreshToken(res.data[REFRESH_TOKEN]['id']);
        await appPreferences
            .setExpiresIn(getUnixTimestampAfter(Constants.expiresInTime));
        await appPreferences.setToken(res.data[TOKEN]);
      } else {
        await deleteAllUserInfo();
        return false;
      }
    }
    return true;
  }

  Future<void> deleteAllUserInfo() async {
    serviceLocator<AppUserCubit>().updateUser(null);
    await appPreferences.setToken(Constants.empty);
    await appPreferences.setExpiresIn(Constants.zero);
    await appPreferences.setRefreshToken(Constants.empty);
  }
}
