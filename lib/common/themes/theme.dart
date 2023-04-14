import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _textStyle = TextStyle(
    fontWeight: FontWeight.w500,
  );

  static final appbarTitle = _textStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );

  static final productLabel = _textStyle.copyWith(
    fontSize: 15,
  );

  static final inputText = _textStyle.copyWith(
    fontSize: 15,
  );

  static final bodyText = _textStyle.copyWith(
    fontSize: 15,
  );

  static final buttonLabel = _textStyle.copyWith(
    fontSize: 14,
  );

  static final pageIndicator = _textStyle.copyWith(
    fontSize: 12,
  );

  static final snackBar = _textStyle.copyWith(
    fontSize: 14,
  );

  static final dialogTitle = _textStyle.copyWith(
    fontSize: 18,
  );

  static final dialogContent = _textStyle.copyWith(
    fontSize: 15,
  );

  static const highlightColor = Colors.green;

  static const double imageRadius = 16;
}