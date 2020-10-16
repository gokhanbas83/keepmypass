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
import 'package:package_info/package_info.dart';

import '../utilities/translation.dart';

import '../widgets/g_text.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/AboutScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(W.About)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 10, bottom: 50, left: 15, right: 15),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (_, snapshot) {
                  String version = '1.0.0';
                  if (snapshot.connectionState == ConnectionState.done) {
                    PackageInfo packageInfo = snapshot.data;
                    version = '${packageInfo.version}.${packageInfo.buildNumber}';
                  }
                  return GText(
                    '${W.KeepMyPass} $version',
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              GText(
                tr(W.Application_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              GText(
                tr(W.Application_Description_Long),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              GText(
                tr(W.Privacy),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                tr(W.Privacy_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              GText(
                tr(W.User_Data),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                tr(W.User_Data_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              GText(
                tr(W.Disclaimer_Limitation_of_Liability),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                tr(W.Disclaimer_Limitation_of_Liability_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              GText(
                tr(W.Copyright),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                tr(W.Copyright_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              const Divider(),
              GText(
                tr(W.Contact),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                tr(W.Contact_Description),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.justify,
              ),
              GText(
                tr(W.Third_Party_Resources),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
              GText(
                'Flutter Package\nResource Name : provider\nHomepage : https://github.com/rrousselGit/provider\n\n'
                'Flutter Package\nResource Name : sqflite\nHomepage : https://github.com/tekartik/sqflite\n\n'
                'Flutter Package\nResource Name : flutter_colorpicker\nHomepage : https://github.com/mchome/flutter_colorpicker\n\n'
                'Flutter Package\nResource Name : font_awesome_flutter\nHomepage : https://github.com/fluttercommunity/font_awesome_flutter\n\n'
                'Flutter Package\nResource Name : crypto\nHomepage : https://pub.dev/packages/crypto\n\n'
                'Flutter Package\nResource Name : encrypt\nHomepage : https://github.com/leocavalcante/encrypt\n\n'
                'Flutter Package\nResource Name : url_launcher\nHomepage : https://pub.dev/packages/url_launcher\n\n'
                'Flutter Package\nResource Name : package_info\nHomepage : https://pub.dev/packages/package_info\n\n'
                'Flutter Package\nResource Name : shared_preferences\nHomepage : https://pub.dev/packages/shared_preferences\n\n'
                'Icon Set\nResource Name : font awesome\nHomepage : https://fontawesome.com\n\n',
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
