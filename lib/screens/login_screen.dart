//    Copyright (C) 2020  Gokhan Bas  gokhanbas83@gmail.com
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/assets.dart';

import '../providers/user.dart';

import '../utilities/translation.dart';

import '../widgets/dialogs.dart';
import '../widgets/g_text.dart';
import '../widgets/g_password_field.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/LoginScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GText(
                'KeepMyPass',
                padding: const EdgeInsets.only(bottom: 20),
                style: const TextStyle(fontSize: 24),
              ),
              Assets.adaptiveLogo(context, Assets.logo),
              LoginScreenForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenForm extends StatefulWidget {
  const LoginScreenForm({Key key}) : super(key: key);

  @override
  _LoginScreenFormState createState() => _LoginScreenFormState();
}

class _LoginScreenFormState extends State<LoginScreenForm> {
  bool _logining = false;

  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    setState(() {
      _logining = true;
    });

    if (!(await Provider.of<User>(context, listen: false).login(context, _passwordController.text))) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.Wrong_Password), buttonText: tr(W.Ok));
      setState(() {
        _logining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _logining
        ? Container(
            padding: const EdgeInsets.only(top: 20),
            child: const CircularProgressIndicator(),
          )
        : Column(
            children: <Widget>[
              GPasswordField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: tr(W.Password),
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: RaisedButton(
                  child: Text(tr(W.Login)),
                  onPressed: _login,
                ),
              ),
            ],
          );
  }
}
