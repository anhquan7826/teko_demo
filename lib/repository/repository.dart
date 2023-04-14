import 'package:dio/dio.dart';

abstract class Repository {
  static final _dio = Dio();

  Dio get dio => _dio;
}