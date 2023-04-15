import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar({
  Widget? title,
  List<Widget>? actions,
}) {
  return AppBar(
    title: title,
    centerTitle: true,
    actions: actions,
  );
}