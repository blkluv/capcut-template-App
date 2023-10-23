class TemplateObject {
  late String id;
  late String Template_Name;
  late String Template_ID;
  late String video_link;
  late String poster_link;
  late String Usage_detail;
  late String category;
  late String Clips;
  late String Creater_name;
  late String Creater_desc;
  late String createdAt;
  late String updatedAt;
  late String Tags;
  late int v;

  TemplateObject({
    required this.id,
    required this.Template_Name,
    required this.Template_ID,
    required this.video_link,
    required this.poster_link,
    required this.Usage_detail,
    required this.category,
    required this.Clips,
    required this.Creater_name,
    required this.Creater_desc,
    required this.createdAt,
    required this.updatedAt,
    required this.Tags,
    required this.v,
  });

  factory TemplateObject.fromJson(Map<String, dynamic> json) {
    // print(
    //     // 'Template_Name getting :${json['_id']} - ${json['Template_Name']} - ${json['slug']} - ${json['createdAt']} - ${json['updatedAt']} - ${json['__v']}');
    //     '${json['category']['_id']}');
    return TemplateObject(
      id: json['_id'],
      Template_Name: json['Template_Name'],
      Template_ID: json['Template_ID'],
      video_link: json['video_link'],
      poster_link: json['poster_link'],
      Usage_detail: json['Usage_detail'],
      category: (json['category'] != null && (json['category'] as List).isNotEmpty) ? json['category'][0]['_id'] : '',
      Clips: json['Clips'],
      Creater_name: json['Creater_name'],
      Creater_desc: json['Creater_desc'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      Tags: json['Tags'],
      v: json['__v'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['_id'] = id;
  //   data['Template_Name'] = Template_Name;
  //   data['Template_ID'] = Template_ID;
  //   data['video_link'] = video_link;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['Usage_detail'] = Usage_detail;
  //   data['__v'] = v;
  //   return data;
  // }
}
