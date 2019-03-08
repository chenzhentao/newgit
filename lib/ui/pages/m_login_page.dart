import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/ui/pages/identity_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _deviceInfo;

  bool _isObscure = true;
  Color _eyeColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDeviceInfo();

    _userNumController.addListener(() {
      _email = _userNumController.text;
      print(" ${_email}    _userNumController     ${_userNumController.text}");
    });
    _passwordController.addListener(() {
      _password = _passwordController.text;
      print(" ${_password}    _userNumController     ${_passwordController
          .text}");
    });
  }

  Future initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      var deviceName = data.name;
      var deviceVersion = data.systemVersion;
      _deviceInfo = data.identifierForVendor; //UUID for iOS
    } else if (Platform.isAndroid) {
      //android相关代码
      var build = await deviceInfoPlugin.androidInfo;

      var deviceName = build.model;
      _deviceInfo = build.androidId;
    }
  }

  final _passwordController = TextEditingController();
  final _userNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Form(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.0),
            children: <Widget>[
              SizedBox(
                height: 200.0,
//            child: new ImageIcon(
//                AssetImage(Utils.getImgPath('renxingbao_tubiao'))),
              ),
              buildPhoneField(),
              buildPasswordField(context),
              buildForgetPasswordField(),
              SizedBox(
                height: 30.0,
              ),
              buildLoginButton(context),
            ],
          )),
    );
  }

  TextFormField buildPhoneField() {
    return TextFormField(
      controller: _userNumController,
      decoration: InputDecoration(labelText: '请输入账号'),
      validator: (String value) {
        if (value == null || value.length < 6) {
          return '请输入有效的账号';
        }
      },
//      onSaved: (String value) => _email = value,
    );
  }

  TextFormField buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,

      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '请输入密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme
                      .of(context)
                      .iconTheme
                      .color;
                });
              })),
    );
  }

  Align buildForgetPasswordField() {
    return Align(
      child: Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                '忘记密码',
                style: TextStyle(fontSize: 14.0, color: Colors.blue),
              ),
              onPressed: () {
                print('找回密码');
              },
            ),
            FlatButton(
              child: Text(
                '点击注册',
                style: TextStyle(fontSize: 14.0, color: Colors.blue),
              ),
              onPressed: () {
                print('点击注册');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _goIdentity() {
    Navigator.of(context).pushReplacementNamed('/IdentityPage');
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          onPressed: () {
            Map<String, String> mDataMap = {
              'userPwd': _password,
              'userLoginNo': _email,
              'lastDevice': _deviceInfo
            };
            print(mDataMap.toString());
            String content = WanAndroidApi.USER_LOGIN;
            var data = Uri.dataFromString(content, parameters: mDataMap);
            var mOptions = new Options();
            mOptions.data = data;
            mOptions.baseUrl = WanAndroidApi.MESSAGE_U;
            mOptions.method = Method.post;
            new WanRepository().postLoginForm(mDataMap).then((onValue) {
              print("then     ${onValue}");
              Navigator.push(
                  context,new MaterialPageRoute(builder: (context)
              =>
              new IdentityPage(mData: onValue)
              )

              );});
          }   ,       child: Text(
            '登录',
            style: Theme
                .of(context)
                .primaryTextTheme
                .headline,
          ),
          color: Colors.red,
        ),
      ),
    );
  }
}
