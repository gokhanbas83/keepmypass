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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/entry.dart';
import '../providers/entries.dart';
import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../screens/add_edit_entry_screen.dart';

import '../widgets/g_password_field.dart';

class EntryScreen extends StatelessWidget {
  static const routeName = '/EntryScreen';

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final int _id = (_args != null && _args.containsKey('id')) ? _args['id'] : 0;

    Entry _entry = Provider.of<Entries>(context).findById(_id);

    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
    int _lastSetClipboardTimeStamp = 0;

    final Map<int, String> _popupMenuItems = {
      0: tr(W.Edit),
    };

    void _setClipboard(String data) {
      Clipboard.setData(ClipboardData(text: data));
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text(tr(W.Copied_to_clipboard)),
      ));
      var copyTimeStamp = DateTime.now().millisecondsSinceEpoch;
      _lastSetClipboardTimeStamp = copyTimeStamp;
      Future.delayed(const Duration(seconds: 10), () {
        if (_lastSetClipboardTimeStamp != copyTimeStamp) {
          return;
        }
        Clipboard.setData(ClipboardData(text: ''));
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_entry == null ? '' : _entry.title),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (key) {
              if (key == 0) {
                Navigator.pushNamed(context, AddEditEntryScreen.routeName, arguments: {'id': _entry.id});
              }
            },
            itemBuilder: (BuildContext context) {
              return _popupMenuItems
                  .map((key, value) {
                    return MapEntry(
                        value,
                        PopupMenuItem<int>(
                          value: key,
                          child: Text(value),
                        ));
                  })
                  .values
                  .toList();
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tr(W.Username),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_entry == null ? '' : _entry.username),
                  ),
                  IconButton(
                    icon: const FaIcon('clone'),
                    onPressed: () {
                      _setClipboard(_entry == null ? '' : _entry.username);
                    },
                  ),
                ],
              ),
              const Divider(height: 50),
              Text(
                tr(W.Password),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GPasswordField(
                      controller: TextEditingController(text: _entry == null ? '' : _entry.password),
                      decoration: null,
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon('clone'),
                    onPressed: () {
                      _setClipboard(_entry == null ? '' : _entry.password);
                    },
                  ),
                ],
              ),
              const Divider(height: 50),
              Text(
                tr(W.Url),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_entry == null ? '' : _entry.url),
                  ),
                  IconButton(
                    icon: const FaIcon('externalLinkAlt'),
                    onPressed: () {
                      try {
                        launch(_entry.url);
                      } catch (e) {}
                    },
                  ),
                ],
              ),
              const Divider(height: 50),
              Text(
                tr(W.Notes),
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _entry == null ? '' : _entry.notes,
                      maxLines: 5,
                    ),
                  ),
                  IconButton(
                    icon: const FaIcon('clone'),
                    onPressed: () {
                      _setClipboard(_entry == null ? '' : _entry.notes);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
