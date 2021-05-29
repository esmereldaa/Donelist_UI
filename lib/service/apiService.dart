import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:project_donelist/model/getDataModel.dart';

class ApiService {
  final String linkURL = "http://10.0.2.2:8000/api/v1";

  Future<String> login(String email, String password) async {
    var responeStatus;
    String token;
    var data = FormData.fromMap({
      'email': email,
      'password': password,
    });
    Dio dio = new Dio();
    await dio
        .post(linkURL + "/login", data: data)
        .then((response) => responeStatus = response.data)
        .catchError((error) => print(error));
    print(responeStatus);
    token = responeStatus["token"];
    if (responeStatus["statusCode"] == "201" ||
        responeStatus["statusCode"] == "200") {
      return token;
    } else {
      return "false";
    }
  }

  Future<List<Value>> getPosts(String token) async {
    String toURL = linkURL + "/" + token + "/getData";
    http.Response res = await http.get(toURL);

    if (res.statusCode == 200) {
      print("2");
      print(json.decode(res.body).runtimeType);
      if (json.decode(res.body) is String) {
      } else {
        List<dynamic> body = json.decode(res.body);
        print(body);
        List<Value> doneList = body
            .map(
              (dynamic item) => Value.fromJson(item),
            )
            .toList();

        return doneList;
      }
    } else {
      throw "Can't get posts.";
    }
  }

  Future<List<DataUser>> getUser(String token) async {
    String toURL = linkURL + "/" + token + "/getUser";
    http.Response res = await http.get(toURL);

    if (res.statusCode == 200) {
      print("getUser");
      Map<String, dynamic> map = json.decode(res.body);
      print(map);
      List<dynamic> body = map["value"];
      List<DataUser> posts = body
          .map(
            (dynamic item) => DataUser.fromJson(item),
          )
          .toList();
      return posts;
    } else {
      throw "Can't get posts.";
    }
  }

  Future<bool> setData(String token, String task) async {
    var responeStatus;
    var data = FormData.fromMap({
      'donedata': task,
    });
    Dio dio = new Dio();
    await dio
        .post(linkURL + "/" + token + "/setData", data: data)
        .then((response) => responeStatus = response.data)
        .catchError((error) => print(error));
    print(responeStatus);
    if (responeStatus["statusCode"] == "201" ||
        responeStatus["statusCode"] == "200") {
      return true;
    } else {
      return false;
    }
  }

  Future<String> daftar(String uname, String email, String password) async {
    var responeStatus;
    String token;
    var data = FormData.fromMap({
      'uname': uname,
      'email': email,
      'password': password,
    });
    Dio dio = new Dio();
    print(daftar);
    await dio
        .post(linkURL + "/createAccount", data: data)
        .then((response) => responeStatus = response.data)
        .catchError((error) => print(error));
    print(responeStatus);
    token = responeStatus["token"];
    if (responeStatus["statusCode"] == "201" ||
        responeStatus["statusCode"] == "200") {
      return token;
    } else {
      return "false";
    }
  }
}
