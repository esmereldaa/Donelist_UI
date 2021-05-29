// To parse this JSON data, do
//
//     final value = valueFromJson(jsonString);

import 'dart:convert';

List<Value> valueFromJson(String str) =>
    List<Value>.from(json.decode(str).map((x) => Value.fromJson(x)));

String valueToJson(List<Value> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

DataUser userFromJson(String str) => DataUser.fromJson(json.decode(str));

String userToJson(DataUser data) => json.encode(data.toJson());

class Value {
  Value({
    this.listId,
    this.userId,
    this.taskData,
    this.date,
  });

  int listId;
  int userId;
  String taskData;
  DateTime date;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        listId: json["list_id"],
        userId: json["user_id"],
        taskData: json["task_data"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "list_id": listId,
        "user_id": userId,
        "task_data": taskData,
        "date": date.toIso8601String(),
      };
}

class DataUser {
  DataUser({
    this.userId,
    this.token,
    this.uname,
    this.email,
  });

  int userId;
  String token;
  String uname;
  String email;

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        userId: json["user_id"],
        token: json["token"],
        uname: json["uname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "token": token,
        "uname": uname,
        "email": email,
      };
}
