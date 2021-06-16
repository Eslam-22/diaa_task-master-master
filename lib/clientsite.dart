import 'dart:io';
import 'package:diaa_task/notification_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'networking/fetching_urls.dart';
import 'networking/url_results.dart';

class ClientSite extends StatefulWidget {
  @override
  _ClientSiteState createState() => _ClientSiteState();
}

class _ClientSiteState extends State<ClientSite> {
  String phone = "";
  String message = "";
  String url = "";
  Future<RequestModel> fetch;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  RequestModel resonseModel;
  List<String> linksList = [];

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    gettingData();
  }

  gettingData() async {
    String fcmtoken = await _firebaseMessaging.getToken();

    NotificationCenter(context).initConfigure();
    fetchurl(fcmtoken).then((value) {
      setState(() {
        resonseModel = value;
      });
      resonseModel.allow.forEach((element) {
        linksList.add(element);
      });
    });
  }

  _launchURL({bool isPhoneCall, bool isIntigram = false}) async {
    if (isIntigram == false) {
      if (isPhoneCall) {
        url = "tel://$phone";
      } else {
        url = "whatsapp://send?phone=+$phone&text=$message";
      }
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  externalUrl(dataUrl) async {
    if (await canLaunch(dataUrl)) {
      await launch(dataUrl);
    } else {
      throw 'Could not launch $dataUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xfff44235),
          title: Text(
            "عقار الكويت",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: resonseModel == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : WebView(
                initialUrl: 'https://q8aqar.com/app/1/',
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (NavigationRequest request) {
                  print("request url : ${request.url}");
                  if (request.url.contains("https://wa.me/") &&
                      request.url.contains("text")) {
                    phone = request.url
                        .toString()
                        .split("https://wa.me/")[1]
                        .split("?text")[0];
                    message = request.url.toString().split("text=")[1];
                    _launchURL(isPhoneCall: false);
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("https://wa.me/9")) {
                    phone = "9" +
                        request.url.toString().split("https://wa.me/9")[1];
                    // .split("96566242264")[0];
                    message = "";
                    _launchURL(isPhoneCall: false);
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("tel:")) {
                    print("phonephone ");
                    phone = request.url.toString().split("tel:")[1];
                    _launchURL(isPhoneCall: true);

                    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  } else if (request.url.contains("instagram") ||
                      request.url.contains("twitter") ||
                      request.url.contains("mailto")) {
                    url = request.url;
                    _launchURL(isPhoneCall: false, isIntigram: true);
                    return NavigationDecision.prevent;
                  } else {
                    for (int x = 0; x < linksList.length; x++) {
                      if (request.url.contains(linksList[x])) {
                        return NavigationDecision.navigate;
                      }
                    }

                    externalUrl(request.url);
                  }
                },
              ));
  }
}
