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

import '../providers/user.dart';

import '../utilities/translation.dart';

import '../widgets/dialogs.dart';
import '../widgets/g_password_field.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/SettingsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(W.Settings)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 50, left: 20, right: 20),
          child: SettingsScreenForm(),
        ),
      ),
    );
  }
}

class SettingsScreenForm extends StatefulWidget {
  const SettingsScreenForm({Key key}) : super(key: key);

  @override
  _SettingsScreenFormState createState() => _SettingsScreenFormState();
}

class _SettingsScreenFormState extends State<SettingsScreenForm> {
  bool _initialized = false;

  User _user;

  final TextEditingController _passwordCurrentTextEditingController = TextEditingController();
  final TextEditingController _passwordNewTextEditingController = TextEditingController();
  final TextEditingController _passwordNewConfirmTextEditingController = TextEditingController();

  String _selectedLanguage;
  List<String> _themeOptions = [];
  String _selectedTheme;

  void _saveLanguage() async {
    await Dialogs.showLoadingWithTask(
        message: tr(W.Please_Wait),
        context: context,
        function: () async {
          await _user.setLanguage(_selectedLanguage);
        });
    _loadThemeOptions();
    await Dialogs.showAlert(context: context, title: tr(W.Information), message: tr(W.Language_is_changed), buttonText: tr(W.Ok));
  }

  void _saveTheme() async {
    await Dialogs.showLoadingWithTask(
        message: tr(W.Please_Wait),
        context: context,
        function: () async {
          await _user.setTheme(_selectedTheme == tr(W.Light) ? 'light' : 'dark');
        });
    await Dialogs.showAlert(context: context, title: tr(W.Information), message: tr(W.Theme_is_changed), buttonText: tr(W.Ok));
  }

  void _savePassword() async {
    if (_passwordCurrentTextEditingController.text != _user.password) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.Current_password_is_wrong), buttonText: tr(W.Ok));
      return;
    }
    if (_passwordNewTextEditingController.text.length < 4) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.Password_must_be_at_least_4_characters), buttonText: tr(W.Ok));
      return;
    }
    if (_passwordNewTextEditingController.text != _passwordNewConfirmTextEditingController.text) {
      await Dialogs.showAlert(context: context, title: tr(W.Warning), message: tr(W.Password_confirm_is_wrong), buttonText: tr(W.Ok));
      return;
    }
    await Dialogs.showLoadingWithTask(
        message: tr(W.Please_Wait),
        context: context,
        function: () async {
          await _user.setPassword(_passwordNewTextEditingController.text);
        });
    await Dialogs.showAlert(context: context, title: tr(W.Information), message: tr(W.Password_is_changed), buttonText: tr(W.Ok));
    _passwordCurrentTextEditingController.text = '';
    _passwordNewTextEditingController.text = '';
    _passwordNewConfirmTextEditingController.text = '';
  }

  void _loadThemeOptions() {
    _themeOptions.clear();
    _themeOptions.add(tr(W.Light));
    _themeOptions.add(tr(W.Dark));
    _selectedTheme = _user.theme == 'light' ? _themeOptions[0] : _themeOptions[1];
  }

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;

      _user = Provider.of<User>(context);

      _loadThemeOptions();

      _selectedLanguage = _user.language;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: Text(
            tr(W.Change_Language),
            textAlign: TextAlign.left,
          ),
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
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: RaisedButton(
            child: Text(tr(W.Save)),
            onPressed: () {
              _saveLanguage();
            },
          ),
        ),
        const Divider(height: 50, thickness: 2),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: Text(
            tr(W.Change_Theme),
            textAlign: TextAlign.left,
          ),
        ),
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedTheme,
          onChanged: (value) {
            setState(() {
              _selectedTheme = value;
            });
          },
          items: _themeOptions.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: RaisedButton(
            child: Text(tr(W.Save)),
            onPressed: () {
              _saveTheme();
            },
          ),
        ),
        const Divider(height: 50, thickness: 2),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: Text(
            tr(W.Change_Master_Password),
            textAlign: TextAlign.left,
          ),
        ),
        GPasswordField(
          controller: _passwordCurrentTextEditingController,
          decoration: InputDecoration(
            labelText: tr(W.Current_Password),
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
          ),
        ),
        GPasswordField(
          controller: _passwordNewTextEditingController,
          decoration: InputDecoration(
            labelText: tr(W.New_Password),
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
          ),
        ),
        GPasswordField(
          controller: _passwordNewConfirmTextEditingController,
          decoration: InputDecoration(
            labelText: tr(W.Confirm_New_Password),
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          width: double.infinity,
          child: RaisedButton(
            child: Text(tr(W.Save)),
            onPressed: () {
              _savePassword();
            },
          ),
        ),
      ],
    );
  }
}
