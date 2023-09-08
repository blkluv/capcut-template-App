// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';
import 'dart:developer';

import 'package:capcut_template/Api/ApiHelper.dart';
import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Images.dart';
import 'package:capcut_template/Utils/Router.dart';
import 'package:capcut_template/Utils/add_helper.dart';
import 'package:capcut_template/Utils/add_provider.dart';
import 'package:capcut_template/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../Models/TemplateObject.dart';
import '../Utils/Functions.dart';

class SingleTemplateScreen extends StatefulWidget {
  Settings? settings;
  TemplateObject? template;
  final String? tempId;
  SingleTemplateScreen({Key? key, required this.settings, required this.template, this.tempId}) : super(key: key);

  @override
  State<SingleTemplateScreen> createState() => _SingleTemplateScreenState();
}

class _SingleTemplateScreenState extends State<SingleTemplateScreen> {
  double screenWidth = 1000;
  double screenHeight = 1000;
  bool mute = false;
  bool videoInitialized = false;
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  List<String> _likes = [];
  SharedPreferences? prefs;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    if (widget.tempId != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _loadSignleTemplate(widget.tempId!).then((value) {
          _getLikes();
          print(widget.template!.video_link);
          _controller = VideoPlayerController.network(widget.template!.video_link);
          _controller.setLooping(true);
          _initializeVideoPlayerFuture = _controller.initialize().then((value) {
            setState(() {
              videoInitialized = true;
            });
          });
          // SchedulerBinding.instance.addPostFrameCallback((_) {
          //   _loadInterstitialAd();
          // });
          // loadBannerAd();
          // Timer.periodic(const Duration(seconds: 3), (timer) {
          //   if (_interstitialAd != null) {
          //     _interstitialAd?.show();
          //   } else {
          //     log('interstetial add not loaded');
          //   }
          // });
        });
      });
    } else {
      _getLikes();
      print(widget.template!.video_link);
      _controller = VideoPlayerController.network(widget.template!.video_link);
      _controller.setLooping(true);
      _initializeVideoPlayerFuture = _controller.initialize().then((value) {
        setState(() {
          videoInitialized = true;
        });
      });
      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   _loadInterstitialAd();
      // });
      // loadBannerAd();
      Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_interstitialAd != null) {
          _interstitialAd?.show();
        } else {
          log('interstetial add not loaded');
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  Future<void> _loadSignleTemplate(String id) async {
    log('_getSingleTemplate');

    await ApiHelper().getSingleTemplate(id).then((templateData) {
      if (templateData != null) {
        log('******** data: $templateData');
        TemplateObject template = TemplateObject.fromJson(templateData['template']);
        setState(() {
          widget.template = template;
        });
      }
    });
    ApiHelper().getSettings().then((settingsData) {
      if (settingsData != null) {
        print(settingsData['setting']);
        setState(() {
          widget.settings = Settings.fromJson(settingsData['setting']);
        });
      }
    });
  }

  void _loadInterstitialAd() {
    if (Provider.of<AddProvider>(context, listen: false).checkIfIsPlayAdd()) {
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
            );
            setState(() {
              _interstitialAd = ad;
            });
            log('InterstitialAd loaded: ${_interstitialAd!.responseInfo}}');
          },
          onAdFailedToLoad: (err) {
            log('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );
      Provider.of<AddProvider>(context, listen: false).playAdd();
    } else {
      log('add not played count: ${Provider.of<AddProvider>(context, listen: false).addPlayCount}');
      Provider.of<AddProvider>(context, listen: false).playAdd();
    }
  }

  Future<void> loadBannerAd() async {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
          log('banner ad loaded${_bannerAd!.responseInfo}');
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  Future<void> _getLikes() async {
    SharedPreferences prefsData = await SharedPreferences.getInstance();
    setState(() {
      prefs = prefsData;
    });

    List<String>? likesData = prefs!.getStringList('likes');
    if (likesData != null) {
      setState(() {
        _likes = likesData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppThemeColor.backGroundColor,
      body: SafeArea(
        child: widget.template != null
            ? videoInitialized
                ? _bodyView()
                : Center(child: Image.asset(Images.loading, width: 60))
            : Center(child: Image.asset(Images.loading, width: 60)),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Wrap the play or pause in a call to `setState`. This ensures the
      //     // correct icon is shown.
      //     setState(() {
      //       // If the video is playing, pause it.
      //       if (_controller.value.isPlaying) {
      //         _controller.pause();
      //       } else {
      //         // If the video is paused, play it.
      //         _controller.play();
      //       }
      //     });
      //   },
      //   // Display the correct icon depending on the state of the player.
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: const BoxDecoration(
        color: AppThemeColor.backGroundColor,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _appBarView(),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _templateImageView(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            widget.template!.Creater_name,
                            style: const TextStyle(
                              fontSize: Dimensions.fontSizeDefault,
                              color: AppThemeColor.pureBlackColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.template!.Template_Name,
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeLarge,
                                    fontWeight: FontWeight.w700,
                                    color: AppThemeColor.pureBlackColor,
                                  ),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 13,
                              // ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppThemeColor.grayColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.template!.Usage_detail,
                                  style: const TextStyle(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: AppThemeColor.pureWhiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_bannerAd != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Url is ${widget.settings!.Redirect_url}${widget.template!.Template_ID}');
              launchUrlByLink(
                  url:
                      //
                      // 'https://www.youtube.com/watch?v=Vp2lTtf7pzo&ab_channel=FilmSpotTrailer');
                      '${widget.settings!.Redirect_url}${widget.template!.Template_ID}');
            },
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppThemeColor.darkColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                'Use Template on CapCut',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppThemeColor.pureWhiteColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _templateImageView() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 15),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(color: Colors.black),
        alignment: Alignment.topCenter,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Icon(
                _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: AppThemeColor.pureWhiteColor,
                size: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBarView() {
    bool liked = checkLiked(template: widget.template!);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (widget.tempId == null) {
              Navigator.pop(context);
            } else {
              RouterClass().homeScreenRoute(context: context, settings: widget.settings!);
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppThemeColor.pureBlackColor,
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: () async {
                if (!liked) {
                  setState(() {
                    _likes.add(widget.template!.id);
                  });
                  await prefs!.setStringList('likes', _likes);
                } else {
                  setState(() {
                    _likes.remove(widget.template!.id);
                  });
                  await prefs!.setStringList('likes', _likes);
                }
              },
              child: Container(
                // decoration: BoxDecoration(
                //     color: AppThemeColor.lightGrayColor,
                //     borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.all(4),
                child: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: AppThemeColor.darkColor,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  mute = !mute;
                  if (mute) {
                    _controller.setVolume(0);
                  } else {
                    _controller.setVolume(10);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                // decoration: BoxDecoration(
                //   color: AppThemeColor.lightGrayColor,
                //   borderRadius: BorderRadius.circular(8),
                // ),
                child: Icon(
                  mute ? Icons.volume_off_outlined : Icons.volume_up_outlined,
                  color: AppThemeColor.pureBlackColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  bool checkLiked({required TemplateObject template}) {
    bool yes = false;
    for (var singleTemplate in _likes) {
      if (template.id == singleTemplate) {
        yes = true;
      }
    }
    return yes;
  }
}
