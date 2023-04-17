import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivo/screens/home_page.dart';
import 'package:trivo/utils/app_styles.dart';
import 'package:trivo/utils/config.dart';
import 'package:trivo/utils/helper_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'controllers/settings_controller.dart';
import 'screens/splash_page.dart';
import 'utils/app_func.dart';

Future<Uri?> initUniLinks()async{
  Uri? initialLink;
  try{
     initialLink = await getInitialUri();
    print(initialLink);
  } on PlatformException {
    print('platfrom exception unilink');
  }
  return initialLink;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /*Firebase initialization*/
  await Firebase.initializeApp();

  /*FCM Notifications*/
  await setupFlutterNotificationsCreateChannel();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    log("message recieved");
    log(event.notification!.body);
    showFlutterNotification(event);
  });
  final RemoteMessage? _message = await FirebaseMessaging.instance.getInitialMessage();

  Uri? link = await initUniLinks();
  log(link);
  if(link!=null) {
    log("unilink ${link.host}");
  }

  /*Run app*/
  runApp(ProviderScope(child: MyApp(link, _message)));
}


class MyApp extends ConsumerStatefulWidget {
  final Uri? link;
  final RemoteMessage? message;
  const MyApp(this.link, this.message, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.link!=null) {
      log("unilink2 ${widget.link!.toString()}");
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.message != null) {
        String title = widget.message!.data['title'];
        String user = widget.message!.data['user'];
        String q = "";
        if(title.contains("Nouveau message")){
          q = "messages?to=$user";
          HelperPreferences.saveStringValue("q", q);
        }else {
          q= "entraide/$user";
          HelperPreferences.saveStringValue("q", q);
        }
        log("pushed notif clicked $q");
        log(q);
        try {
          Future.delayed(const Duration(milliseconds: 1000), () async {
             navigateToNextPage(context, HomePage(0, 0, q:q ,), back: false);
           });
        } catch (e,ee) {
          log(e);
          log(ee);
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fruiteefy',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavKey.navKey,
      theme: AppStyles.themeData(false, context),
      darkTheme: AppStyles.themeData(false, context),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr')
      ],
      home: SplashPage(widget.link),
    );
  }
}

