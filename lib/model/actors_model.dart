class ActorsModel {
  final String id;
  final String knownForDepartment;
  final String name;
  final String profilePath;
  final String character;
  
  ActorsModel({
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.profilePath,
    required this.character,
  });

  factory ActorsModel.fromMap(Map<String, dynamic> actor) {
    return ActorsModel(
      id: actor['id'].toString(),
      knownForDepartment: actor['known_for_department'],
      name: actor['name'],
      profilePath: actor['profile_path'] != null ? actor['profile_path'] : "",
      character: actor['character'],
    );
  }
}