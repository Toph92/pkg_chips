import 'package:flutter/material.dart';

class ChipUpdateNotification extends Notification {
  //final String? value;
  dynamic item;
  ChipUpdateNotification({/*this.value,*/ required this.item});
}

/* class ChipDateNotification extends Notification {
  final DateTime? value;
  dynamic item;
  ChipDateNotification({this.value, this.item});
} */

class ChipDeleteNotification extends Notification {
  dynamic item;
  ChipDeleteNotification({required this.item});
}

mixin ChipMixin {
  bool displayBottomMessage = false;

  wdBottomMessage(String? message) => Positioned(
        bottom: 1,
        left: 33,
        child: AnimatedOpacity(
          opacity: displayBottomMessage ? 1 : 0,
          duration: Duration(milliseconds: displayBottomMessage ? 1000 : 100),
          child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 300)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return IgnorePointer(
                    child: Text(message ?? "",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700)),
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ),
      );
}
