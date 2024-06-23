import 'package:flutter/material.dart';

import '../themes/textstyle.dart';

Widget customListTile(Icon icon, String title, String subtitle){
  return ListTile(
    leading: Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: icon,
    ),
    title: Text(title),
    subtitle: Text(subtitle),
    titleTextStyle: CustomTextStyle.textStyle10,
    subtitleTextStyle: CustomTextStyle.textStyle3,
    contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 24),
  );
}