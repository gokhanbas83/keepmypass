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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart' as UserModel;

import '../providers/entries.dart';
import '../providers/groups.dart';

import '../utilities/database.dart';
import '../utilities/translation.dart';

class User with ChangeNotifier {
  UserModel.User _user = UserModel.User();

  bool get isLoggedIn {
    return _user != null && _user.password != null ? true : false;
  }

  String get password {
    return _user != null ? _user.password : null;
  }

  String get theme {
    return _user != null ? _user.theme : null;
  }

  String get language {
    return _user != null && _user.language != null ? _user.language : null;
  }

  Future<bool> login(BuildContext context, String password) async {
    bool result = await Database.checkPassword(password);
    if (result) {
      _user = await Database.getUser();
      _user.password = password;
      await Provider.of<Groups>(context, listen: false).loadGroups(password);
      await Provider.of<Entries>(context, listen: false).loadEntries(password);
      notifyListeners();
    }
    return result;
  }

  void logout() {
    _user.password = null;
    notifyListeners();
  }

  Future<void> setPassword(String password) async {
    await Database.setPassword(_user.password, password);
    if (_user != null) {
      _user.password = password;
    }
  }

  Future<void> setTheme(String theme) async {
    String thm = (theme ?? 'light') == 'light' ? 'light' : 'dark';
    await Database.setTheme(thm);
    if (_user != null) {
      _user.theme = thm;
    }
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    await Database.setLanguage(language);
    if (_user != null) {
      _user.language = language;
      Translation.init(language);
    }
    notifyListeners();
  }

  void restore(UserModel.User user) {
    _user.language = user.language;
    _user.theme = user.theme;
  }
}
