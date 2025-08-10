class Todo {
  String? id;
  DateTime todoDate;
  DateTime createdAt;
  String title;
  bool isReminder;
  bool isDone;
  int? notificationId;

  Todo({
    this.id,
    required this.todoDate,
    required this.createdAt,
    required this.title,
    required this.isDone,
    required this.isReminder,
    this.notificationId,
  });

  Todo.fromJson(Map<String, dynamic> json)
    : title = json["title"],
      todoDate = DateTime.parse(json["todoDate"]),
      createdAt = DateTime.parse(json["createdAt"]),
      isReminder = json["isReminder"],
      isDone = json["isDone"],
      notificationId = json["notificationId"],
      id = json["id"];

  Map<String, dynamic> toJson() => {
    "title": title,
    "todoDate": todoDate.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "isReminder": isReminder,
    "isDone": isDone,
    "notificationId": notificationId,
    "id": id,
  };
}
