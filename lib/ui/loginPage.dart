import 'package:flutter/material.dart';
import 'package:project_donelist/service/apiService.dart';
import 'package:project_donelist/ui/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ApiService _apiService = ApiService();
  bool _isFieldEmailValid;
  bool _isFieldPasswordValid;
  TextEditingController _controllerEmail = TextEditingController();
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
                      !_isFieldPasswordValid ||
                      !_isFieldEmailValid) {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text("Please Fill All Data"),
                    ));
                    return;
                  }
                  String email = _controllerEmail.text.toString();
                  String password = _controllerPassword.text.toString();
                  _apiService.login(email, password).then((isSuccess) async => {
                        print(isSuccess),
                        if (isSuccess != "false")
                          {
                            print(isSuccess),
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Login"),
                            )),
                            token = isSuccess,
                            saveToken()
                          }
                        else
                          {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Gagal Login"),
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
                    'Login',
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
