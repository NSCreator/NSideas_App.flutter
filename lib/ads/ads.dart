import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page/home_page.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePageAd {
  final BuildContext context;
  late RewardedAd rewardedAd;
  bool adPlayedSuccessfully = false;
  String type;

  HomePageAd(this.context, {required this.type});

  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => AlertDialog(
        title: Text("Loading"),
        content: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void hideLoadingIndicator() {
    Navigator.of(context).pop();
  }

  void _setFullScreenContentCallback() {
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdShowedFullScreenContent");
        adPlayedSuccessfully = false;
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print("$ad onAdDismissedFullScreenContent");
        ad.dispose();
        adPlayedSuccessfully = true;
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print("$ad onAdFailedToShowFullScreenContent: $error");
        ad.dispose();
        adPlayedSuccessfully = false;
      },
      onAdImpression: (RewardedAd ad) => print("$ad Impression occurred"),
    );
  }

  Future<void> _showRewardedAd() async {
    rewardedAd.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
        num amount = rewardItem.amount;

      },
    );
  }

  Future<bool> _loadRewardedAd() async {
    final Completer<bool> adLoadCompleter = Completer<bool>();

    RewardedAd.load(
      adUnitId: AdVideo.bannerAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print("Failed to load rewarded ad, Error: $error");
          adLoadCompleter.complete(false);

        },
        onAdLoaded: (RewardedAd ad) async {
          print("$ad loaded");
          showToastText("Ad loaded");
          rewardedAd = ad;
          _setFullScreenContentCallback();
          await _showRewardedAd();
          adLoadCompleter.complete(true);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt(type, DateTime.now().millisecondsSinceEpoch);
        },
      ),
    );

    return adLoadCompleter.future;
  }

  Future<bool> _checkImageOpenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? lastOpenTime = prefs.getInt(type);

    if (lastOpenTime == null) {

      return await _loadRewardedAd();

    } else {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = (currentTime - lastOpenTime) ~/ 1000;

      if (difference >= 43200) {

        return await _loadRewardedAd();
      } else {
        double remainingTime = ((43200 - difference) / 60) / 60;
        showToastText("Ad within ${remainingTime.round()} Hours");
        return true;
      }
    }

  }

  Future<bool> startAdLoading() async {
    try {
      showLoadingIndicator();
      bool ad= await _checkImageOpenStatus();
      hideLoadingIndicator();
      return ad;
    } catch (e) {
      print("Error loading ad: $e");

      return false;
    }
  }
}

class AdVideo {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7097300908994281/9491925792';
    } else {
      return 'ca-app-pub-7097300908994281/8849115979';
    }
  }
}

class CustomAdsBannerForPdfs extends StatefulWidget {
  CustomAdsBannerForPdfs();

  @override
  _CustomAdsBannerForPdfsState createState() => _CustomAdsBannerForPdfsState();
}

class _CustomAdsBannerForPdfsState extends State<CustomAdsBannerForPdfs> {
  BannerAd? _bannerAd; // Make BannerAd nullable
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      _loadBannerAd();
    }).catchError((error) {
      print('Failed to initialize MobileAds: $error');
    });
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-7097300908994281/6301919894",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd!.load().catchError((error) {
      print('Failed to load banner ad: $error');
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose(); // Use null-aware operator
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isBannerAdLoaded && _bannerAd != null
          ? _bannerAd!.size.height.toDouble()
          : 50,
      child: _bannerAd != null ? AdWidget(ad: _bannerAd!) : SizedBox(),
    );
  }
}

