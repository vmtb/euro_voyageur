import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivo/screens/home_page.dart';
import 'package:trivo/screens/splash_page.dart';
import 'package:trivo/utils/app_styles.dart';
import 'package:trivo/utils/config.dart';
import 'package:uni_links/uni_links.dart';

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
  // await Firebase.initializeApp();

  /* FCM Notifications*/
  // await setupFlutterNotificationsCreateChannel();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //   log("message recieved");
  //   log(event.notification!.body);
  //   showFlutterNotification(event);
  // });
  // final RemoteMessage? _message = await FirebaseMessaging.instance.getInitialMessage();

  Uri? link = await initUniLinks();
  log(link);
  if(link!=null) {
    log("unilink ${link.host}");
  }

  /*Run app*/
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends ConsumerStatefulWidget { 
  const MyApp(  {
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
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heureux voyageur',
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
      home: const SplashPage(),
    );
  }
}

