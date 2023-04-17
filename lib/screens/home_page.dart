import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trivo/utils/helper_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_const.dart';
import '../utils/app_func.dart';

StateProvider latProvider = StateProvider<double>((ref) => 0);
StateProvider lngProvider = StateProvider<double>((ref) => 0);

class HomePage extends ConsumerStatefulWidget {
  HomePage(  {
    Key? key,
      }) : super(key: key);

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey webViewKey = GlobalKey();
  bool isLoadingHere = false;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions sharedSettings = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: false,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
        applicationNameForUserAgent: 'Fruiteefy',
        userAgent:
            'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.5304.105 Mobile Safari/537.36',
        // enable iOS service worker feature limited to defined App Bound Domains
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  String homeUrl = "https://heureuxvoyageur.com";
  String initialUrl = "https://heureuxvoyageur.com";

  late Uri initialUri;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialUri = Uri.parse(initialUrl);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log("back");
        String? currentUrl = (await webViewController!.getUrl())!.path;
        log(currentUrl);
        bool canGoBack = await webViewController!.canGoBack();
        if (canGoBack) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: getSize(context).height,
          width: getSize(context).width,
          child: Stack(
            children: [
              Positioned(
                top: 40,
                bottom: 0,
                left: 0,
                right: 0,
                child: FutureBuilder<bool>(
                  future: isNetworkAvailable(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    final bool networkAvailable = snapshot.data ?? false;

                    // Android-only
                    final cacheMode =
                        networkAvailable ? AndroidCacheMode.LOAD_DEFAULT : AndroidCacheMode.LOAD_CACHE_ELSE_NETWORK;

                    // iOS-only
                    final cachePolicy = networkAvailable
                        ? IOSURLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY
                        : IOSURLRequestCachePolicy.RETURN_CACHE_DATA_ELSE_LOAD;

                    final webViewInitialSettings = sharedSettings.copy();
                    webViewInitialSettings.android.cacheMode = cacheMode;


                    return InAppWebView(
                      key: webViewKey,
                      initialUrlRequest: URLRequest(url: initialUri, iosCachePolicy: cachePolicy),
                      initialUserScripts: UnmodifiableListView<UserScript>([
                        //UserScript(source: scrpt, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
                      ]),
                      onProgressChanged: (controller, progress) {
                        isLoadingHere = progress < 46;
                        log("Progesss => $progress");
                        setState(() {});
                      },
                      initialOptions: webViewInitialSettings,
                      onWebViewCreated: (controller) async {
                        log("created");
                        webViewController = controller;

                        controller.addJavaScriptHandler(
                          handlerName: 'toaster',
                          callback: (args) {
                            for(var arg in args){
                              if(arg.toString().startsWith("username")){
                                if(arg.toString().split(":").length>1) {
                                  HelperPreferences.saveStringValue("email", arg.toString().split(":")[1]);
                                }
                              }
                              if(arg.toString().startsWith("password")){
                                if(arg.toString().split(":").length>1) {
                                  HelperPreferences.saveStringValue("password", arg.toString().split(":")[1]);
                                }
                              }
                            }
                            log(args);
                          },
                        );
                      },
                      shouldOverrideUrlLoading: (controller, navigationAction) async {
                        final uri = navigationAction.request.url;
                        if (uri != null &&
                            navigationAction.isForMainFrame &&
                            uri.host != homeUrl &&
                            await canLaunchUrl(uri)) {
                          launchUrl(uri);
                          return NavigationActionPolicy.CANCEL;
                        }
                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStart: (controller, uri) async {
                      },
                      onConsoleMessage: (controller, msg) {
                        log(msg);
                      },
                      onLoadStop: (controller, url) async {
                        if (await isNetworkAvailable() && !(await isPWAInstalled())) {
                          setPWAInstalled();
                        }
                        log("load stop");
                      },
                      onLoadError: (controller, err, error, stack) async {
                        if (!(await isNetworkAvailable())) {
                          if (!(await isPWAInstalled())) {}
                          //await controller.loadData(data: kHTMLErrorPageNotInstalled);
                        }
                      },
                      onLoadHttpError: (controller, request, error, stack) async {
                        if (!(await isNetworkAvailable())) {
                          if (!(await isPWAInstalled())) {
                            //await controller.loadData(data: kHTMLErrorPageNotInstalled);
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              if (isLoadingHere)
                const Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()))),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> isNetworkAvailable() async {
    // check if there is a valid network connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      return false;
    }

    // check if the network is really connected to Internet
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }

    return true;
  }
}
