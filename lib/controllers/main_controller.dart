 import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_const.dart';
import '../utils/app_func.dart';

/// Marcos
///

class MainController{
  final Ref ref;

  MainController(this.ref);

  //Send notification with firebase messaging
  Future<void> sendNotif(String title, String body, String userId, {bool isToAdmin=false, String mainKey="", String type=""}) async {
    String tokens = "";
    // if(isToAdmin){
    //   List<UserModel> admins = await ref.read(userController).getAdmins();
    //   for (var element in admins) {
    //     tokens+=element.fcm+";";
    //   }
    // }else{
    //   UserModel userModel= await ref.read(userController).getUser(userId);
    //   tokens = userModel.fcm;
    // }

    if(tokens.isEmpty){
      log("TOKENS IS EMPTY");
      return;
    }

    Map<String, dynamic> params = {
      "tokens": tokens,
      "title": title,
      "body": body,
      "to": isToAdmin?"admins":userId,
      "type": type,
      "key": mainKey,
      "time": DateTime.now().millisecondsSinceEpoch
    };

    try {
      var res = await Dio().post(urlFCM,
          data: FormData.fromMap(params),
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
              headers: {'Content-type': 'application/json; charset=UTF-8'}));
      log(res);
    } catch (e) {
      log(e);
    }
  }

}