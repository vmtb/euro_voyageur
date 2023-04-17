
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/main_controller.dart';
import '../controllers/user_controller.dart';
import 'app_const.dart';


final messaging = Provider<FirebaseMessaging>((ref) => FirebaseMessaging.instance);

final userController = Provider<UserController>((ref)=>UserController(ref));
final mainController = Provider<MainController>((ref)=>MainController(ref));

final lockApp = StateProvider<bool>((ref)=>false);
