class Category {
  late String id;
  late int sequence;
  late String name;
  late String slug;
  late String createdAt;
  late String updatedAt;
  late int v;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.sequence,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    print(
        'name getting :${json['_id']} - ${json['name']} - ${json['slug']} - ${json['createdAt']} - ${json['updatedAt']} - ${json['__v']}');
    return Category(
      id: json['_id'],
      name: json['name'],
      slug: json['slug'],
      sequence: json['sequence'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['sequence'] = sequence;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}
