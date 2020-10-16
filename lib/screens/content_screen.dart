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

import '../models/content_item.dart';
import '../models/entry.dart';
import '../models/group.dart';

import '../providers/entries.dart';
import '../providers/groups.dart';

import '../screens/add_edit_entry_screen.dart';
import '../screens/add_edit_group_screen.dart';
import '../screens/content_edit_screen.dart';
import '../screens/entry_screen.dart';

import '../utilities/ad_manager.dart';
import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../widgets/app_drawer.dart';

class ContentScreen extends StatefulWidget {
  static const routeName = '/ContentScreen';

  const ContentScreen({Key key}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  List<ContentItem> _findItems(Groups groupProvider, Entries entryProvider, int parentId) {
    final List<Group> groups = groupProvider.filterByParentId(parentId);
    final List<Entry> entries = entryProvider.filterByParentId(parentId);
    final List<ContentItem> items = [];

    if (groups != null) {
      for (Group group in groups) {
        items.add(ContentItem.fromGroup(group));
      }
    }

    if (entries != null) {
      for (Entry entry in entries) {
        items.add(ContentItem.fromEntry(entry));
      }
    }

    return items;
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.fullBanner,
    );
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final int _parentId = (_args != null && _args.containsKey('parentId')) ? _args['parentId'] : 0;

    final Groups _groupProvider = Provider.of<Groups>(context);
    final Entries _entryProvider = Provider.of<Entries>(context);

    final List<ContentItem> _items = _findItems(_groupProvider, _entryProvider, _parentId);

    final Map<int, String> _popupMenuItems = {
      0: tr(W.Add_Entry),
      1: tr(W.Add_Group),
      2: tr(W.Edit_Items),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(_parentId == 0 ? 'KeepMyPass' : _groupProvider.findById(_parentId).title),
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (key) {
              if (key == 0) {
                Navigator.pushNamed(context, AddEditEntryScreen.routeName, arguments: {'id': 0, 'parentId': _parentId});
              } else if (key == 1) {
                Navigator.pushNamed(context, AddEditGroupScreen.routeName, arguments: {'id': 0, 'parentId': _parentId});
              } else if (key == 2) {
                Navigator.pushNamed(context, ContentEditScreen.routeName, arguments: {'parentId': _parentId});
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
      drawer: _parentId == 0 ? AppDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 50, left: 8, right: 8),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, i) => Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (_items[i].isGroup) {
                    Navigator.pushNamed(context, ContentScreen.routeName, arguments: {'parentId': _items[i].id});
                  } else {
                    Navigator.pushNamed(context, EntryScreen.routeName, arguments: {'id': _items[i].id});
                  }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: FaIcon(_items[i].icon),
                    backgroundColor: Color(_items[i].iconBackColor),
                    foregroundColor: Color(_items[i].iconForeColor),
                  ),
                  title: Text(_items[i].title, style: TextStyle(fontWeight: _items[i].isGroup ? FontWeight.bold : FontWeight.normal)),
                  trailing: _items[i].isGroup ? const FaIcon('angleRight') : null,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
