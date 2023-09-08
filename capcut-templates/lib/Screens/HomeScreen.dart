// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:capcut_template/Api/ApiHelper.dart';
import 'package:capcut_template/Models/Category.dart';
import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Models/TemplateObject.dart';
import 'package:capcut_template/Screens/LikedScreen.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Images.dart';
import 'package:capcut_template/Utils/Router.dart';
import 'package:capcut_template/Utils/add_helper.dart';
import 'package:capcut_template/Utils/dimensions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final Settings settings;
  const HomeScreen({Key? key, required this.settings}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenWidth = 1000;
  double screenHeight = 1000;
  List<Category> categories = [];
  List<TemplateObject> templates = [];
  int _selectedTab = 1;
  Category? _selectedCategory;
  Category? _leavedCategory;
  String searchText = '';
  BannerAd? _bannerAd;
  SharedPreferences? prefs;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TextEditingController searchController = TextEditingController();
  bool showLoader = false;
  final ScrollController scrollController = ScrollController();
  int _offset = 1;
  late List<int> _offsetList = [1];
  bool _isLoading = false;
  int _totalSize = 0;

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

  Future<void> _getCategories() async {
    List<Category> categoriesDataList = [];

    await ApiHelper().getCategories().then((categoriesData) {
      if (categoriesData != null) {
        // print(categoriesData['category']);
        List<dynamic> listOfCategories = categoriesData['category'];

        for (var value in listOfCategories) {
          print('single Category$value');
          if (value['name'] != 'Trending') {
            setState(() {
              categoriesDataList.add(
                Category.fromJson(value),
              );
            });
          }
        }
        setState(() {
          categories = categoriesDataList..sort((a, b) => a.sequence.compareTo(b.sequence));
          _selectedCategory = categories.singleWhere((element) => element.name == 'For You');
        });
      }
    });
  }

  Future<void> _getTemplates() async {
    // print('m Called');
    templates.clear();
    await ApiHelper().getTemplates(offset: _offset.toString()).then((templateData) {
      if (templateData != null) {
        // print(templateData['templates']);
        _totalSize = templateData['totalsize'];
        List<dynamic> listOfTemplates = templateData['templates'];
        //
        for (var value in listOfTemplates) {
          print('single Template$value');
          setState(() {
            templates.add(
              TemplateObject.fromJson(value),
            );
          });
        }
      }
    });
  }

  List<TemplateObject> getSortTemplates() {
    List<TemplateObject> sortedItems = [];

    for (var singleTemplate in templates) {
      bool situation1 = singleTemplate.Creater_name.toLowerCase().split(searchText.toLowerCase()).length > 1;
      bool situation2 = singleTemplate.Template_Name.toLowerCase().split(searchText.toLowerCase()).length > 1;

      bool situation3 = false;
      singleTemplate.Tags.split('#').forEach((singleTag) {
        if (singleTag.toLowerCase().split(searchText.toLowerCase()).length > 1) {
          // print(singleTag);
          situation3 = true;
        }
      });
      if (_selectedCategory != null) {
        if (_selectedCategory!.name != 'For You') {
          if (singleTemplate.category == _selectedCategory!.id) {
            if (situation1 || situation2 || situation3) {
              sortedItems.add(singleTemplate);
            }
          }
        } else {
          if (situation1 || situation2 || situation3) {
            sortedItems.add(singleTemplate);
          }
        }
      }
    }

    return sortedItems;
  }

  void _paginate() async {
    int pageSize = (_totalSize / 10).ceil();
    if (_offset < pageSize && !_offsetList.contains(_offset + 1)) {
      setState(() {
        _offset = _offset + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await ApiHelper().getTemplates(offset: _offset.toString()).then((templateData) {
        if (templateData != null) {
          List<dynamic> listOfTemplates = templateData['templates'];
          for (var value in listOfTemplates) {
            print('single Template$value');
            setState(() {
              templates.add(
                TemplateObject.fromJson(value),
              );
            });
          }
        }
      });
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("c1c77da3-29d3-4cb4-aa00-e49a30f3592e");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      log("Accepted permission: $accepted");
    });
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      log('notification raw payload: ${result.notification.rawPayload}');
      log('notification body: ${result.notification.body}');
      Map<String, dynamic> custom = jsonDecode(result.notification.rawPayload!['custom']);
      if (custom != null) {
        log('notification custom: ${custom['a']['template_id']}');
        log("........................check notify.....................");
        RouterClass().singleTemplateScreenRoute(context: context, tempId: custom['a']['template_id']);
      }
    });
    setState(() {
      showLoader = true;
    });
    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        showLoader = false;
      });
    });
    loadBannerAd();
    _getCategories();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getTemplates();
      scrollController.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !_isLoading) {
          log('paginate');
          if (mounted) {
            _paginate();
          }
        }
      });
    });

    super.initState();
  }

  @override
  dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedTab = index;
            if (_selectedTab == 2) {
              _leavedCategory = _selectedCategory;
              _selectedCategory = categories.singleWhere((element) => element.name == 'Trending');
            } else if (_selectedTab == 0) {
              _leavedCategory = _selectedCategory;
            } else {
              _selectedCategory = _leavedCategory;
            }
          });
        },
        currentIndex: _selectedTab,
        selectedItemColor: AppThemeColor.pureBlackColor,
        selectedIconTheme: const IconThemeData(
          color: AppThemeColor.pureBlackColor,
        ),
        unselectedIconTheme: const IconThemeData(
          color: AppThemeColor.dullFontColor,
        ),
        items: const [
          BottomNavigationBarItem(
            label: 'Favourite',
            icon: Icon(
              Icons.favorite,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Template',
            icon: Icon(
              Icons.video_collection,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Trending',
            icon: Icon(
              Icons.trending_up,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _selectedTab != 0 ? _bodyView() : LikedScreen(settings: widget.settings),
          // if (_bannerAd != null && !showLoader)
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Container(
          //       width: _bannerAd!.size.width.toDouble(),
          //       height: _bannerAd!.size.height.toDouble(),
          //       child: AdWidget(ad: _bannerAd!),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: showLoader
          ? Center(child: Image.asset(Images.loading, width: 60))
          : Column(
              children: [
                _appBarView(),
                _selectedTab != 2 ? _categoriesView() : const SizedBox(height: 15),
                _templetesView(),
                _isLoading
                    ? Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(bottom: 20),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }

  Widget _categoriesView() {
    return Container(
      width: screenWidth,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = categories[index];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      margin: const EdgeInsets.only(
                        right: 10,
                      ),
                      decoration: _selectedCategory == categories[index]
                          ? BoxDecoration(
                              color: AppThemeColor.pureBlackColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: AppThemeColor.dullFontColor,
                              ),
                            )
                          : BoxDecoration(
                              color: AppThemeColor.backGroundColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1.5,
                                color: AppThemeColor.lightGrayColor,
                              ),
                            ),
                      child: Text(
                        categories[index].name,
                        style: TextStyle(
                          fontSize: Dimensions.fontSizeDefault,
                          color: _selectedCategory == categories[index] ? AppThemeColor.pureWhiteColor : AppThemeColor.pureBlackColor,
                          fontWeight: _selectedCategory == categories[index] ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _templetesView() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _offset = 1;
            _offsetList = [1];
          });
          await _getCategories();
          await _getTemplates();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: getSortTemplates()
                    .map(
                      (singleTemplate) => _singleTemplateView(template: singleTemplate),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _singleTemplateView({required TemplateObject template}) {
    // bool liked = checkLiked(template: template);
    double tabWidth = (screenWidth / 2) - 25;
    return InkWell(
      onTap: () async {
        analytics.logEvent(name: 'template_opened', parameters: {
          'id': template.id,
          'name': template.Template_Name,
          'creator': template.Creater_name,
          'category': template.category,
        }).then((value) => log('event'), onError: (e) {
          log('event error: $e');
        });
        RouterClass().singleTemplateScreenRoute(
          context: context,
          settings: widget.settings,
          template: template,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: tabWidth,
            height: tabWidth * 1.7,
            // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  template.poster_link,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.video_collection_outlined,
                          size: Dimensions.fontSizeExtraSmall,
                          color: AppThemeColor.pureWhiteColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          template.Clips,
                          style: const TextStyle(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: AppThemeColor.pureWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppThemeColor.dullBlackColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.cut,
                            size: Dimensions.fontSizeExtraSmall,
                            color: AppThemeColor.pureWhiteColor,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            template.Usage_detail.split(' ').first,
                            style: const TextStyle(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: AppThemeColor.pureWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 6),
                child: Text(
                  template.Template_Name,
                  style: const TextStyle(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w700,
                    color: AppThemeColor.pureBlackColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              GestureDetector(
                onTap: () {
                  log('tap');
                  setState(() {
                    searchText = template.Creater_name;
                    searchController.text = template.Creater_name;
                  });
                },
                child: SizedBox(
                  width: tabWidth,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: Dimensions.fontSizeSmall,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        template.Creater_name,
                        style: const TextStyle(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: AppThemeColor.dullFontColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appBarView() {
    return Container(
      decoration: const BoxDecoration(color: AppThemeColor.backGroundColor),
      child: SafeArea(
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppThemeColor.dullWhiteColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            // padding: const EdgeInsets.all(6),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: AppThemeColor.dullFontColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 7),
                hintText: 'Search Template...',
              ),
              style: const TextStyle(fontSize: Dimensions.fontSizeDefault),
              onChanged: (text) {
                setState(() {
                  searchText = text;
                  // searchController.text = text;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
