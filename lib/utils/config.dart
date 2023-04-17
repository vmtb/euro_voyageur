
import 'dart:convert';
import 'dart:math' as m;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trivo/screens/home_page.dart';
import 'package:trivo/utils/helper_preferences.dart';

import 'app_func.dart';

class NavKey{
  static final navKey = GlobalKey<NavigatorState>();
}

class Configurations{

  static bool isFlutterLocalNotificationsInitialized = false;

}

class Configurations2{

}

String mainKey = "";
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> setupFlutterNotificationsCreateChannel() async {
  if (Configurations.isFlutterLocalNotificationsInitialized) {
    // return;
  }
  channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,);

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  Configurations.isFlutterLocalNotificationsInitialized = true;

  flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_firebase_notification'),
    iOS: IOSInitializationSettings(),
  ), onSelectNotification: (e){
    var message= jsonDecode(e!);
    log('Message clicked outside!');
    String title = message['title'];
    String user = message['user'];
    String q = "";
    if(title.contains("Nouveau message")){
      q = "messages?to=$user";
      HelperPreferences.saveStringValue("q", q);
    }else {
      q= "entraide/$user";
      HelperPreferences.saveStringValue("q", q);
    }
    log(q);
    navigateToNextPage(NavKey.navKey.currentState!.context, HomePage(), back: false);
    //Navigator.push(NavKey.navKey.currentState!.context, );

  });
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  //AndroidNotification? android = message.notification?.android;
  if (notification != null) {
    flutterLocalNotificationsPlugin.show(
      m.Random().nextInt(1500),
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //icon: 'launch_background',
          icon: 'ic_firebase_notification',
        ),
      ),
      payload: jsonEncode(message.data)
    );


  }


  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    log('Message clicked!');
    log(message);
    String title = message.data['title'];
    String user = message.data['user'];
    String q = "";
    if(title.contains("Nouveau message")){
      q = "messages?to=$user";
      HelperPreferences.saveStringValue("q", q);
    }else {
      q= "entraide/$user";
      HelperPreferences.saveStringValue("q", q);
    }
    Navigator.push(NavKey.navKey.currentState!.context, MaterialPageRoute(builder: (context)=>HomePage()));
  });
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  // if(currentEnv==ENV_MODE.dev) {
  //   await Firebase.initializeApp(name: 'secondary', options: FirebaseOptions(apiKey: Configurations2().apiKey,
  //       appId: Configurations2().appId, messagingSenderId: Configurations2().messagingSenderId,
  //       projectId: Configurations2().projectId, storageBucket: Configurations2().storageBucket));
  // }

  await setupFlutterNotificationsCreateChannel();
  log("Handling a background message: ${message.messageId}");
  showFlutterNotification(message);
}

