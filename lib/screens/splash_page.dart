import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timer_controller/timer_controller.dart';
import 'package:trivo/screens/onboarding_screen.dart';
import 'package:trivo/utils/app_const.dart';
import 'package:trivo/utils/helper_preferences.dart';

import '../utils/app_func.dart';
import 'home_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  Uri? link;
  SplashPage(link, {Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  late TimerController _controller;
  double lat = 0;
  double lng = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TimerController.seconds(1);
    _controller.start();
    setupPermission();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TimerControllerListener(
      listener: (BuildContext context, TimerValue value) async {
        String? ob = await HelperPreferences.retrieveDynamicValue("onboarding");
        if(lat==0&&lng==0){
          await getMyParams();
        }
        String? q = await HelperPreferences.retrieveDynamicValue("q");
        ref.read(latProvider.notifier).state = lat;
        ref.read(lngProvider.notifier).state = lng;

        if ((ob != "" && ob != null)) {
          navigateToNextPage(context,  HomePage(lat, lng, q: q??"", uri: widget.link,), back: false);
        } else {
          navigateToNextPage(context, const OnBoardingScreen(), back: false);
        }
      },
      listenWhen: (previousValue, currentValue) {
        log(previousValue);
        log(currentValue);
        return currentValue.remaining == 0;
      },
      controller: _controller,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 50,
              right: 50,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/img/logo.png"),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 40,
                right: 0,
                left: 0,
                child: Column(
                  children: const [
                    CircularProgressIndicator(),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Future<void> setupPermission() async {
    if ((await Permission.location.request()).isGranted) {
      getMyParams();
    }
  }

  Future<bool> getMyParams() async {
    log("getting my position");
    try {
      Position p = await _determinePosition();
      lat = p.latitude;
      lng = p.longitude;
      log("$lat $lng");
    } catch (e) {
      log(e);
    }
    setState(() {});
    log("end getting my position");
    return true;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

}
