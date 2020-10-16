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

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/user.dart' as UserModel;

import './providers/entries.dart';
import './providers/groups.dart';
import './providers/user.dart';

import './screens/about_screen.dart';
import './screens/add_edit_entry_screen.dart';
import './screens/add_edit_group_screen.dart';
import './screens/content_edit_screen.dart';
import './screens/content_screen.dart';
import './screens/entry_screen.dart';
import './screens/login_screen.dart';
import './screens/settings_screen.dart';
import './screens/splash_screen.dart';
import './screens/terms_screen.dart';
import './screens/welcome_screen.dart';

import './utilities/ad_manager.dart';
import './utilities/database.dart';
import './utilities/translation.dart';

void main() => runApp(KeepMyPass());

class KeepMyPass extends StatelessWidget {
  bool _admobInitialized = false;

  Widget _startupInitializer(User user) {
    return FutureBuilder(
      future: Database.getUser(),
      builder: (cntx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          UserModel.User u = snapshot.data;
          user.restore(u);

          String lang = user != null && user.language != null ? user.language : Localizations.localeOf(cntx).languageCode;
          lang = Translation.isSupportedLanguage(lang) ? lang : 'en';
          Translation.init(lang);

          if (u.password == null) {
            return WelcomeScreen();
          } else {
            return LoginScreen();
          }
        } else {
          return SplashScreen();
        }
      },
    );
  }

  Widget _admobInitializer(User user) {
    return FutureBuilder(
      future: FirebaseAdMob.instance.initialize(appId: AdManager.appId),
      builder: (cntx, snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
          _admobInitialized = true;
          return _startupInitializer(user);
        } else {
          return SplashScreen();
        }
      },
    );
  }

  Widget _home(User user) {
    if (!_admobInitialized) {
      return _admobInitializer(user);
    } else if (user.isLoggedIn) {
      return ContentScreen();
    } else {
      return _startupInitializer(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: User()),
          ChangeNotifierProvider.value(value: Groups()),
          ChangeNotifierProvider.value(value: Entries()),
        ],
        child: Consumer<User>(
          builder: (ctx, user, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KeepMyPass',
            theme: (user.theme ?? 'dark') == 'dark' ? ThemeData.dark() : ThemeData.light(),
            home: _home(user),
            routes: {
              AboutScreen.routeName: (ctx) => AboutScreen(),
              AddEditEntryScreen.routeName: (ctx) => AddEditEntryScreen(),
              AddEditGroupScreen.routeName: (ctx) => AddEditGroupScreen(),
              ContentEditScreen.routeName: (ctx) => ContentEditScreen(),
              ContentScreen.routeName: (ctx) => ContentScreen(),
              EntryScreen.routeName: (ctx) => EntryScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SettingsScreen.routeName: (ctx) => SettingsScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              TermsScreen.routeName: (ctx) => TermsScreen(),
              WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
            },
          ),
        ));
  }
}
