import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class ApiHelper {
  final String appBaseUrl = 'https://templatebackend-3599bc73313e.herokuapp.com/api/';
  // final String appBaseUrl = 'https://templates-backend.onrender.com/api/';

  static const String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  Future<Map<dynamic, dynamic>?> getSettings() async {
    try {
      String uri = '${appBaseUrl}siteSettings';
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      print(response.body);
      Map<dynamic, dynamic> categoriesData = jsonDecode(response.body);
      return categoriesData;
    } catch (e) {
      return null;
    }
  }

  Future<Map<dynamic, dynamic>?> getCategories() async {
    try {
      String uri = '${appBaseUrl}category/AllCategories';
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      print(response.body);
      Map<dynamic, dynamic> categoriesData = jsonDecode(response.body);
      return categoriesData;
    } catch (e) {
      return null;
    }
  }

  Future<Map<dynamic, dynamic>?> getTemplates({String offset = '1'}) async {
    try {
      String uri = '${appBaseUrl}template/AllTemplates?offset=${offset}&limit=14';
      log(uri.toString());
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      Map<dynamic, dynamic> categoriesData = jsonDecode(response.body);
      return categoriesData;
    } catch (e) {
      return null;
    }
  }

  Future<Map<dynamic, dynamic>?> getSingleTemplate(String id) async {
    try {
      String uri = '${appBaseUrl}template/SingleTemplate/$id';
      log('url: $uri');
      http.Response response = await http.get(Uri.parse(uri)).timeout(Duration(seconds: timeoutInSeconds));
      Map<dynamic, dynamic> categoriesData = jsonDecode(response.body);
      return categoriesData;
    } catch (e) {
      return null;
    }
  }
}
