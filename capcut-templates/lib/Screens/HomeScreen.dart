import 'package:capcut_template/Api/ApiHelper.dart';
import 'package:capcut_template/Models/Category.dart';
import 'package:capcut_template/Models/Settings.dart';
import 'package:capcut_template/Models/TemplateObject.dart';
import 'package:capcut_template/Screens/LikedScreen.dart';
import 'package:capcut_template/Utils/Colors.dart';
import 'package:capcut_template/Utils/Router.dart';
import 'package:capcut_template/Utils/dimensions.dart';
import 'package:flutter/material.dart';
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
  List<String> _likes = [];
  // List<String> names = ['Arslan', 'Zimal'];

  int _selectedTab = 1;
  Category? _selectedCategory;
  Category? _leavedCategory;
  String searchText = '';

  SharedPreferences? prefs;

  Future<void> _getCategories() async {
    List<Category> categoriesDataList = [];

    await ApiHelper().getCategories().then((categoriesData) {
      if (categoriesData != null) {
        // print(categoriesData['category']);
        List<dynamic> listOfCategories = categoriesData['category'];

        for (var value in listOfCategories) {
          print('single Category$value');
          setState(() {
            categoriesDataList.add(
              Category.fromJson(value),
            );
          });
        }
        setState(() {
          categories = categoriesDataList
            ..sort((a, b) => a.sequence.compareTo(b.sequence));
          _selectedCategory =
              categories.singleWhere((element) => element.name == 'For You');
        });
      }
    });
  }

  Future<void> _getTemplates() async {
    // print('m Called');
    templates.clear();
    await ApiHelper().getTemplates().then((templateData) {
      if (templateData != null) {
        // print(templateData['templates']);
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
      bool situation1 = singleTemplate.Creater_name.toLowerCase()
              .split(searchText.toLowerCase())
              .length >
          1;
      bool situation2 = singleTemplate.Template_Name.toLowerCase()
              .split(searchText.toLowerCase())
              .length >
          1;

      bool situation3 = false;
      singleTemplate.Tags.split('#').forEach((singleTag) {
        if (singleTag.toLowerCase().split(searchText.toLowerCase()).length >
            1) {
          // print(singleTag);
          situation3 = true;
        }
      });

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

    return sortedItems;
  }

  @override
  void initState() {
    _getCategories();
    _getTemplates();
    // _getLikes();
    super.initState();
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
              _selectedCategory = categories
                  .singleWhere((element) => element.name == 'Trending');
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
      body: _selectedTab != 0
          ? _bodyView()
          : LikedScreen(settings: widget.settings),
    );
  }

  Widget _bodyView() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        children: [
          _appBarView(),
          _selectedTab != 2
              ? _categoriesView()
              : const SizedBox(
                  height: 15,
                ),
          _templetesView(),
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
                          color: _selectedCategory == categories[index]
                              ? AppThemeColor.pureWhiteColor
                              : AppThemeColor.pureBlackColor,
                          fontWeight: _selectedCategory == categories[index]
                              ? FontWeight.w700
                              : FontWeight.w400,
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
        onRefresh: () => _getTemplates(),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              children: getSortTemplates()
                  .map(
                    (singleTemplate) =>
                        _singleTemplateView(template: singleTemplate),
                  )
                  .toList(),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
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
          height: 30,
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
              // border: Border.all(color: AppThemeColor.grayColor),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  30,
                ),
              ),
            ),
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search,
                  size: 20,
                  color: AppThemeColor.dullFontColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 7),
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                    style: const TextStyle(
                      fontSize: Dimensions.fontSizeDefault,
                    ),
                    onChanged: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}