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

import '../screens/about_screen.dart';
import '../screens/settings_screen.dart';

import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(tr(W.Menu)),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon('cog'),
            title: Text(tr(W.Settings)),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon('infoCircle'),
            title: Text(tr(W.About)),
            onTap: () {
              Navigator.of(context).pushNamed(AboutScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon('signOutAlt'),
            title: Text(tr(W.Logout)),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<User>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
