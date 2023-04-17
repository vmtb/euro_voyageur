
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../components/app_text.dart';
import 'app_const.dart';

log(dynamic text) {
  if (kDebugMode) {
    print(text);
  }
}

enum2String(enumItem) {
  return EnumToString.convertToString(enumItem);
}

Size getSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

navigateToNextPage(BuildContext context, Widget widget, {bool back = true}) {
  if (back) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  } else {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => widget));
  }
}

navigateToNextPageWithTransition(BuildContext context, Widget widget,
    {bool back = true}) {
  if (back) {
    Navigator.push(
      context,
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return widget;
      }, transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }),
    );
  } else {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return widget;
      }, transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      }),
    );
  }
}

showFlushBar(BuildContext context, String title, String message) {
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.black.withOpacity(0.85),
    duration: const Duration(seconds: 3),
    borderRadius: BorderRadius.circular(5),
    titleText: Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
          fontSize: 16.0,
          color: Colors.white,
          fontFamily: "ShadowsIntoLightTwo"),
    ),
  ).show(context);
}

void showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: SizedBox(
            width: 40,
            height: 60,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      });
}

Center errorLoading(err, stack) {
  log(err);
  log(stack);
  return const Center(
      child: Text("Une erreur s'est produite pendant le chargement...."));
}

Center loadingError() {
  return const Center(
    child: CupertinoActivityIndicator(),
  );
}

showLogoutModal(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      backgroundColor: backgroundDefaultScaffold,
      builder: (context) {
        return Container(
          height: getSize(context).height / 1.5,
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                  height: 100, child: Image.asset("assets/img/logo_short.png")),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                thickness: 1,
              ),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        );
      });
}

void showConfirmAlert(
  BuildContext context,
  String title,
  String message,
  String confirmText,
  String rejectText,
  Function() onPressed,
) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: title,
    desc: message,
    onWillPopActive: true,
    useRootNavigator: false,
    closeFunction: () {
      Navigator.pop(context);
    },
    buttons: [
      DialogButton(
        child: AppText(
          confirmText,
          color: Colors.white,
        ),
        onPressed: onPressed,
        width: 120,
      ),
      DialogButton(
        child: AppText(
          rejectText,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        width: 120,
      )
    ],
  ).show();
}
