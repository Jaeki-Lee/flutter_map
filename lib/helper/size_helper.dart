import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  // debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  // debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  // debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

double getRatioWidth(
    BuildContext context, double maxWidth, double maxObjectWidth) {
  double targetDeviceWidth = displayWidth(context);

  return targetDeviceWidth / maxWidth * maxObjectWidth;
}

double getRatioHeight(
    BuildContext context, double maxHeight, double maxObjectHeight) {
  double targeDeviceHeight = displayHeight(context);

  return targeDeviceHeight / maxHeight * maxObjectHeight;
}
