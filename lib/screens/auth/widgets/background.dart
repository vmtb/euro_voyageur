import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:trivo/components/app_button_round.dart';
import 'package:trivo/components/app_input.dart';
import 'package:trivo/components/app_text.dart';
import 'package:trivo/utils/app_const.dart';
import 'package:trivo/utils/app_func.dart';

class Background extends ConsumerWidget {
  final Widget child;

  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: getSize(context).height,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: 0,
            child: SvgPicture.asset("assets/img/bottom_login.svg"),
          ),
          Positioned(
            bottom: -50,
            right: 0,
            child: SvgPicture.asset("assets/img/top_login.svg"),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            bottom: 100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset("assets/img/logo.png"),
                  ),
                  const AppText(
                    "Bienvenue sur 1xBetPay ",
                    size: 30,
                    isNormal: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                        height: getSize(context).height/2,
                        child: child),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
