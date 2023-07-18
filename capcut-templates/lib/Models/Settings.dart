class Settings {
  late String id;
  late String image;
  late String siteSubtitle;
  late String siteTitle;
  late String Redirect_url;
  late String updatedAt;

  Settings({
    required this.id,
    required this.image,
    required this.siteSubtitle,
    required this.siteTitle,
    required this.Redirect_url,
    required this.updatedAt,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    print(
        'image getting :${json['_id']} - ${json['image']} - ${json['siteSubtitle']} - ${json['siteTitle']} - ${json['Redirect_url']} - ${json['__updatedAt']}');
    return Settings(
      id: json['_id'],
      image: json['image'],
      siteSubtitle: json['siteSubtitle'],
      siteTitle: json['siteTitle'],
      Redirect_url: json['Redirect_url'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['image'] = image;
    data['siteSubtitle'] = siteSubtitle;
    data['siteTitle'] = siteTitle;
    data['Redirect_url'] = Redirect_url;
    data['__updatedAt'] = updatedAt;
    return data;
  }
}
