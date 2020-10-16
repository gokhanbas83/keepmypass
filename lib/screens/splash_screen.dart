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

import '../assets/assets.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/SplashScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Center(
                child: Assets.adaptiveLogo(context, Assets.logo),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Text('powered by'),
                    const Text('gknbs',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
