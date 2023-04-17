import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_const.dart';

class AppImageNetwork extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final bool isProgress;

  AppImageNetwork(
      {Key? key,
      required this.url,
      this.fit = BoxFit.contain,
      this.isProgress = false})
      : super(key: key);
  String urrl = "" ;
  @override
  Widget build(BuildContext context) {
    if(url.isEmpty) {
      urrl =default_user_pic;
    }else{
      urrl = url;
    }
    return isProgress
        ? const CupertinoActivityIndicator()
        : urrl.startsWith('http')? CachedNetworkImage(
            fit: fit,
            placeholder: (BuildContext context, String url) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: urrl,
          ): Image.file(File(urrl), fit: fit);
  }
}
