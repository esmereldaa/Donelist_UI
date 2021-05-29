import 'package:flutter/material.dart';
import 'package:project_donelist/service/apiService.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class InputPage extends StatefulWidget {
  InputPage({Key key, this.token, this.uname}) : super(key: key);
  final String token;
  final String uname;
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool _isFieldTaskValid;
  TextEditingController _controllerTask = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ApiService _apiService = ApiService();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldState,
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              "Hi, What you gonna do " + widget.uname,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            Card(
                color: Colors.blue.withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 8,
                    maxLength: 250,
                    controller: _controllerTask,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Task",
                      errorText: _isFieldTaskValid == null || _isFieldTaskValid
                          ? null
                          : "Task is required",
                    ),
                    onChanged: (value) {
                      bool isFieldValid = value.trim().isNotEmpty;
                      if (isFieldValid != _isFieldTaskValid) {
                        setState(() => _isFieldTaskValid = isFieldValid);
                      }
                    },
                  ),
                )),
            MaterialButton(
                onPressed: () {
                  if (_isFieldTaskValid == null || !_isFieldTaskValid) {
                    _scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text("Please Fill All Data"),
                    ));
                    return;
                  } else {
                    String task = _controllerTask.text.toString();
                    _apiService.setData(widget.token, task).then((value) => {
                          if (value)
                            {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Success"),
                              )),
                              _apiService.getPosts(widget.token),
                              Navigator.pop(context)
                            }
                          else
                            {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Gagal Input Task"),
                              )),
                            }
                        });
                  }
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
                    'SAVE',
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
}
