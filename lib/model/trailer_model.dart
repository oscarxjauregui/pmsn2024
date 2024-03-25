class TrailerModel {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  
  TrailerModel({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory TrailerModel.fromMap(Map<String, dynamic> trailer) {
    return TrailerModel(
      id: trailer['id'].toString(),
      key: trailer['key'],
      name: trailer['name'],
      site: trailer['site'],
      type: trailer['type']
    );
  }
}