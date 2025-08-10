class AppUser {
  String? id;
  String name;
  String email;
  DateTime creationDate;

  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.creationDate,
  });

  AppUser.fromJson(Map<String, dynamic> json)
    : name = json["name"],
      creationDate = DateTime.parse(json["creationDate"]),
      email = json["email"],
      id = json["id"];

  Map<String, dynamic> toJson() => {
    "name": name,
    "creationDate": creationDate.toIso8601String(),
    "email": email,
    "id": id,
  };
}
