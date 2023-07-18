import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Images.dart';
import 'package:capcut_template/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../Models/TemplateObject.dart';
import '../Utils/Functions.dart';

class SingleTemplateScreen extends StatefulWidget {
  final Settings settings;
  final TemplateObject template;
  SingleTemplateScreen(
      {Key? key, required this.settings, required this.template})
      : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _getLikes();
    print(widget.template.video_link);

    _controller = VideoPlayerController.network(
      widget.template.video_link,
    );
    _controller.setLooping(true);

    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        videoInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
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
        child: videoInitialized
            ? _bodyView()
            : Center(
                child: Image.asset(
                  Images.loading,
                  width: 60,
                ),
              ),
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
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _templateImageView(),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        widget.template.Creater_name,
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
                              widget.template.Template_Name,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppThemeColor.grayColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.template.Usage_detail,
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
          ),
          GestureDetector(
            onTap: () {
              print(
                  'Url is ${widget.settings.Redirect_url}${widget.template.Template_ID}');
              launchUrlByLink(
                  url:
                      //
                      // 'https://www.youtube.com/watch?v=Vp2lTtf7pzo&ab_channel=FilmSpotTrailer');
                      '${widget.settings.Redirect_url}${widget.template.Template_ID}');
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
        // Wrap the play or pause in a call to `setState`. This ensures the
        // correct icon is shown.
        setState(() {
          // If the video is playing, pause it.
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            // If the video is paused, play it.
            _controller.play();
          }
        });
      },
      child: Container(
        // height: screenWidth * 1.3,
        // width: screenWidth,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(
          //   fit: BoxFit.cover,
          //   image: NetworkImage(
          //     widget.template.poster_link,
          //   ),
          // ),
        ),
        alignment: Alignment.topCenter,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     const Expanded(
        //       child: SizedBox(),
        //     ),
        //
        //   ],
        // ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use
                  // the data it provides to limit the aspect ratio of the video.
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a
                  // loading spinner.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Icon(
              _controller.value.isPlaying
                  ? Icons.pause_circle
                  : Icons.play_circle,
              color: AppThemeColor.pureWhiteColor,
              size: 45,
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBarView() {
    bool liked = checkLiked(template: widget.template);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
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
                    _likes.add(widget.template.id);
                  });
                  await prefs!.setStringList('likes', _likes);
                } else {
                  setState(() {
                    _likes.remove(widget.template.id);
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
