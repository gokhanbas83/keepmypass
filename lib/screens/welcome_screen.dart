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

import '../screens/terms_screen.dart';

import '../utilities/database.dart';
import '../utilities/translation.dart';

import '../widgets/dialogs.dart';
import '../widgets/g_text.dart';
import '../widgets/g_password_field.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/WelcomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Assets.adaptiveLogo(context, Assets.logo),
              GText(
                tr(W.Welcome_to_KeepMyPass),
                padding: const EdgeInsets.only(top: 20),
                style: const TextStyle(fontSize: 24),
              ),
              GText(
                tr(W.Application_Description_Long),
                padding: const EdgeInsets.only(top: 20),
                textAlign: TextAlign.center,
              ),
              WelcomeScreenForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreenForm extends StatefulWidget {
  const WelcomeScreenForm({Key key}) : super(key: key);

  @override
  _WelcomeScreenFormState createState() => _WelcomeScreenFormState();
}

class _WelcomeScreenFormState extends State<WelcomeScreenForm> {
  bool _initialized = false;
  bool _saving = false;

  List<String> _themeOptions = [];

  final TextEditingController _passwordController = TextEditingController();
  String _selectedLanguage;
  String _selectedThemeName;
  bool _agreement = false;

  void _save() async {
    if (!_agreement) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.You_must_accept_agreement), buttonText: tr(W.Ok));
      return;
    }

    if (_passwordController.text.length < 4) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.Password_must_be_at_least_4_characters), buttonText: tr(W.Ok));
      return;
    }

    setState(() {
      _saving = true;
    });

    String _theme = _selectedThemeName == tr(W.Light) ? 'light' : 'dark';
    await Database.register(_passwordController.text, _theme, _selectedLanguage);

    await Provider.of<User>(context, listen: false).login(context, _passwordController.text);
  }

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;

      var lang = Localizations.localeOf(context).languageCode;
      _selectedLanguage = Translation.isSupportedLanguage(lang) ? lang : 'en';

      _themeOptions.add(tr(W.Light));
      _themeOptions.add(tr(W.Dark));
      _selectedThemeName = _themeOptions[0];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _saving
        ? const Padding(
            padding: const EdgeInsets.only(top: 20),
            child: const CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GText(
                tr(W.Set_your_master_password),
                padding: const EdgeInsets.only(top: 20),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              GPasswordField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                ),
              ),
              GText(
                tr(W.Language),
                padding: const EdgeInsets.only(top: 20),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                items: LanguageOptions.map((key, value) {
                  return MapEntry(
                      key,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                }).values.toList(),
              ),
              GText(
                tr(W.Theme),
                padding: const EdgeInsets.only(top: 20),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedThemeName,
                onChanged: (value) {
                  setState(() {
                    _selectedThemeName = value;
                  });
                },
                items: _themeOptions.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: _agreement,
                    onChanged: (value) {
                      setState(() {
                        _agreement = value;
                      });
                    },
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          tr(W.User_agreement),
                          textAlign: TextAlign.left,
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(TermsScreen.routeName);
                      },
                    ),
                    /*Text(
                      tr(W.User_agreement),
                      textAlign: TextAlign.justify,
                    ),*/
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  child: Text(tr(W.Save)),
                  onPressed: _save,
                ),
              ),
            ],
          );
  }
}
