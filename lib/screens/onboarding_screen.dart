import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onboarding/onboarding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trivo/components/app_text.dart';
import 'package:trivo/screens/home_page.dart';
import 'package:trivo/utils/app_const.dart';
import 'package:trivo/utils/app_func.dart';
import 'package:trivo/utils/helper_preferences.dart';

import '../utils/app_styles.dart';

final List<String> subs = [
  "Vous recherchez des graines, semis, plantes, fruits et légumes à petit prix autour de chez ?\nDécouvrez les offres mises en ligne par les jardiniers amateurs sur notre application !",
  "Vous êtes un passionné de jardinage? Mettez des photos de votre jardin et montrez aux autres tout ce que vous cultivez avec passion...\nTrop de production dans votre beau potager? Vendez ou troquez facilement vos surplus autour de chez vous !",
  "Une question concernant une plante?\nUn doute au potager? Posez votre question à notre communauté de jardiniers via la rubrique \"Entraide\".",
  "Une grainothèque fonctionne un peu comme une bibliothèque partagée: on peut y trouver des graines et en déposer dans un esprit de partage et de troc.\nNous installons des grainothèques privées ou publiques dans le but de valoriser des variétés potagères et florales bio et anciennes."
];

class OnBoardingScreen extends ConsumerStatefulWidget {
  const OnBoardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends ConsumerState<OnBoardingScreen> {
  late int index;

  @override
  void initState() {
    super.initState();
    index = 0;
  }

  Widget _skipButton({void Function(int)? setIndex}) {
    return Row(
      children: [
        Material(
          borderRadius: defaultSkipButtonBorderRadius,
          color: AppColor.secondary,
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index--;
                setIndex(index);
              }
            },
            child: Padding(
              padding: defaultSkipButtonPadding,
              child: Text(
                'Retour',
                style: defaultSkipButtonTextStyle.copyWith(fontFamily: 'Bugaki', fontSize: 17),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Material(
          borderRadius: defaultSkipButtonBorderRadius,
          color: AppColor.primary,
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index++;
                setIndex(index);
              }
            },
            child: Padding(
              padding: defaultSkipButtonPadding,
              child: Text(
                'Suivant',
                style: defaultSkipButtonTextStyle.copyWith(fontFamily: 'Bugaki', fontSize: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Material _nextButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: AppColor.primary,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index++;
            setIndex(index);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Suivant',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Widget _signupButton({void Function(int)? setIndex}) {
    return Row(
      children: [
        Material(
          borderRadius: defaultSkipButtonBorderRadius,
          color: AppColor.primary,
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              if (setIndex != null) {
                index--;
                setIndex(index);
              }
            },
            child: const Padding(
              padding: defaultSkipButtonPadding,
              child: Text(
                'Précédent',
                style: defaultSkipButtonTextStyle,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Material(
          borderRadius: defaultProceedButtonBorderRadius,
          color: AppColor.primary,
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () async {
              HelperPreferences.saveDynamicValue("onboarding", "value");
              if(lat==0&&lng==0){
                await getMyParams();
              }
              navigateToNextPage(context, HomePage(lat, lng), back: false);
            },
            child: const Padding(
              padding: defaultProceedButtonPadding,
              child: Text(
                'Démarrer',
                style: defaultProceedButtonTextStyle,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final onboardingPagesList = [
      PageModel(
        widget: Stack(
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 60,
                child: _buildItemOnB("onboard1.png", "Les offres autour", subs[0])),
          ],
        ),
      ),
      PageModel(
        widget: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 60,
              child: _buildItemOnB("onboard2.png", "Les jardins", subs[1]),
            ),
          ],
        ),
      ),
      PageModel(
        widget: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 60,
              child: _buildItemOnB("onboard3.png", "Entraide", subs[2]),
            ),
          ],
        ),
      ),
      PageModel(
        widget: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 60,
              child: _buildItemOnB("onboard4.png", "Les grainothèques", subs[3]),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: getScaffCont(context),
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return ColoredBox(
            color: getScaffCont(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  index == pagesLength - 1
                      ? _signupButton(setIndex: setIndex)
                      : index == 0
                          ? _nextButton(setIndex: setIndex)
                          : _skipButton(setIndex: setIndex)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildItemOnB(String s, String t, String c) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            SizedBox(height: getSize(context).height * 0.35, child: Image.asset("assets/img/$s")),
            const SizedBox(
              height: 20,
            ),
            AppText(
              t,
              size: 20 ,
              weight: FontWeight.bold,
            ),
            const SizedBox( 
              height: 20,
            ),
            AppText(
              c,
              size: 20,
              align: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  double lat = 0;
  double lng = 0;

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
