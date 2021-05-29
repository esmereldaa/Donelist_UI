import 'package:flutter/material.dart';
import 'package:project_donelist/service/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class DaftarPage extends StatefulWidget {
  DaftarPage({Key key}) : super(key: key);

  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  ApiService _apiService = ApiService();
  bool _isFieldEmailValid;
  bool _isFieldUnameValid;
  bool _isFieldPasswordValid;
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerUname = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  String token = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldState,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: size.width * 0.9,
              height: size.height * 0.1,
              child: Center(child: _buildTextFieldUname()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: size.width * 0.9,
              height: size.height * 0.1,
              child: Center(child: _buildTextFieldEmail()),
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: size.width * 0.9,
              height: size.height * 0.1,
              child: Center(child: _buildTextFieldPassword()),
            ),
            MaterialButton(
                onPressed: () {
                  if (_isFieldPasswordValid == null ||
                      _isFieldEmailValid == null ||
                      _isFieldUnameValid == null ||
                      !_isFieldPasswordValid ||
                      !_isFieldEmailValid ||
                      !_isFieldUnameValid) {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text("Please Fill All Data"),
                    ));
                    return;
                  }
                  String email = _controllerEmail.text.toString();
                  String password = _controllerPassword.text.toString();
                  String uname = _controllerUname.text.toString();
                  _apiService.daftar(uname, email, password).then((isSuccess) =>
                      {
                        print(isSuccess),
                        if (isSuccess != "false")
                          {
                            print(isSuccess),
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Berhasil Daftar"),
                            )),
                            _apiService.login(email, password).then((value) => {
                                  if (value != "false")
                                    {
                                      _scaffoldState.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text("Login"),
                                      )),
                                      token = isSuccess,
                                      saveToken()
                                    }
                                  else
                                    {print("gagal login")}
                                }),
                          }
                        else
                          {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Gagal Daftar"),
                            ))
                          }
                      });
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: size.width * 0.8,
                  height: size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff5b66ff),
                  ),
                  child: Center(
                      child: Text(
                    'Daftar',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 20,
                      color: const Color(0xfffffbfb),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  )),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldPassword() {
    return TextField(
      obscureText: true,
      controller: _controllerPassword,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: _isFieldPasswordValid == null || _isFieldPasswordValid
            ? null
            : "Password is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPasswordValid) {
          setState(() => _isFieldPasswordValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldUname() {
    return TextField(
      controller: _controllerUname,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Nama",
        errorText: _isFieldUnameValid == null || _isFieldUnameValid
            ? null
            : "Nama is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldUnameValid) {
          setState(() => _isFieldUnameValid = isFieldValid);
        }
      },
    );
  }

  Future<void> saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _text = token;
    await prefs.setString('tokenSaved', _text);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => HomePage(
                  token: token,
                )),
        (Route<dynamic> route) => false);
  }
}
