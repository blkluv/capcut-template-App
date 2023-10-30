import 'package:capcut_template/Api/ApiHelper.dart';
import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Models/TemplateObject.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Router.dart';
import 'package:capcut_template/Utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedScreen extends StatefulWidget {
  final Settings settings;
  const LikedScreen({Key? key, required this.settings}) : super(key: key);

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  double screenWidth = 1000;
  double screenHeight = 1000;

  List<TemplateObject> templates = [];
  List<String> _likes = [];

  SharedPreferences? prefs;
  String searchText = '';

  Future<void> _getTemplates() async {
    // print('m Called');
    await ApiHelper().getTemplates().then((templateData) {
      if (templateData != null) {
        // print(templateData['templates']);
        List<dynamic> listOfTemplates = templateData['templates'];
        //
        for (var value in listOfTemplates) {
          // print('single Template$value');
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
          situation3 = true;
        }
      });

      bool situation4 = _likes.contains(singleTemplate.id);

      if (situation1 || situation2 || situation3) {
        if (situation4) {
          sortedItems.add(singleTemplate);
        }
      }
    }

    return sortedItems;
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
  void initState() {
    _getTemplates();
    _getLikes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppThemeColor.darkColor,
      //   title: const Text('My Favorites'),
      // ),
      body: SafeArea(
        child: _bodyView(),
      ),
    );
  }

  Widget _bodyView() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: AppThemeColor.backGroundColor,
      child: Column(
        children: [
          _appBarView(),
          const SizedBox(
            height: 10,
          ),
          _templetesView(),
        ],
      ),
    );
  }

  Widget _templetesView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SingleChildScrollView(
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
    );
  }

  Widget _singleTemplateView({required TemplateObject template}) {
    double tabWidth = (screenWidth / 2) - 25;
    return InkWell(
      onTap: () => RouterClass().singleTemplateScreenRoute(
        context: context,
        settings: widget.settings,
        template: template,
      ),
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
              SizedBox(
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
              // controller: searchController,
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
    // return Container(
    //   decoration: const BoxDecoration(color: AppThemeColor.backGroundColor),
    //   child: SafeArea(
    //     child: Container(
    //       height: 30,
    //       margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
    //       padding: const EdgeInsets.symmetric(horizontal: 20),
    //       decoration: const BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(10),
    //           bottomRight: Radius.circular(10),
    //         ),
    //       ),
    //       child: Container(
    //         decoration: const BoxDecoration(
    //           color: AppThemeColor.dullWhiteColor,
    //           // border: Border.all(color: AppThemeColor.grayColor),
    //           borderRadius: BorderRadius.all(
    //             Radius.circular(
    //               30,
    //             ),
    //           ),
    //         ),
    //         padding: const EdgeInsets.all(6),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             const Icon(
    //               Icons.search,
    //               size: 20,
    //               color: AppThemeColor.dullFontColor,
    //             ),
    //             const SizedBox(
    //               width: 8,
    //             ),
    //             Expanded(
    //               child: TextFormField(
    //                 decoration: const InputDecoration(
    //                   contentPadding: EdgeInsets.symmetric(vertical: 8),
    //                   border: InputBorder.none,
    //                   hintText: 'Search...',
    //                 ),
    //                 style: TextStyle(
    //                   fontSize: Dimensions.fontSizeDefault,
    //                 ),
    //                 onChanged: (text) {
    //                   setState(() {
    //                     searchText = text;
    //                   });
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
