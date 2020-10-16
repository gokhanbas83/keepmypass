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

import '../models/content_item.dart';
import '../models/entry.dart';
import '../models/group.dart';

import '../providers/entries.dart';
import '../providers/groups.dart';

import '../screens/add_edit_entry_screen.dart';
import '../screens/add_edit_group_screen.dart';

import '../utilities/translation.dart';
import '../utilities/fa_icons_helper.dart';

import '../widgets/dialogs.dart';

class ContentEditScreen extends StatelessWidget {
  static const routeName = '/ContentEditScreen';

  Future<void> _deleteGroupRecursive({Groups groupProvider, Entries entryProvider, int id}) async {
    print("_deleteGroupRecursive : ${id}");
    final List<Entry> entries = entryProvider.filterByParentId(id);
    if (entries != null) {
      for (Entry entry in entries) {
        await entryProvider.deleteEntry(entry.id);
      }
    }
    final List<Group> groups = groupProvider.filterByParentId(id);
    if (groups != null) {
      for (Group group in groups) {
        await _deleteGroupRecursive(groupProvider: groupProvider, entryProvider: entryProvider, id: group.id);
      }
    }
    await groupProvider.deleteGroup(id);
  }

  Future<void> _delete({BuildContext context, ContentItem item, Groups groupProvider, Entries entryProvider}) async {
    var result = await Dialogs.showConfirm(context: context, message: '${tr(W.Are_you_sure_want_to_delete_this_item)}\n${item.title}');
    if (!result) {
      return;
    }

    if (item.isGroup) {
      bool hasSubGroups = groupProvider.hasSubGroups(item.id);
      bool hasSubEntries = false;
      if (!hasSubGroups) {
        hasSubEntries = entryProvider.hasSubEntries(item.id);
      }
      if (hasSubGroups || hasSubEntries) {
        result = await Dialogs.showConfirm(context: context, message: '${item.title}\n${tr(W.This_item_has_sub_items)}\n${tr(W.All_sub_items_will_be_deleted)}\n${tr(W.Are_you_sure_want_to_continue)}');
        if (!result) {
          return;
        }
      }
    }

    await Dialogs.showLoadingWithTask(
        message: tr(W.Please_Wait),
        context: context,
        function: () async {
          (item.isGroup) ? await _deleteGroupRecursive(groupProvider: groupProvider, entryProvider: entryProvider, id: item.id) : await entryProvider.deleteEntry(item.id);
        });
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
  Widget build(BuildContext context) {
    final Map<String, Object> _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final int _parentId = (_args != null && _args.containsKey('parentId')) ? _args['parentId'] : 0;

    final Groups _groupProvider = Provider.of<Groups>(context, listen: true);
    final Entries _entryProvider = Provider.of<Entries>(context, listen: true);

    final List<ContentItem> _items = _findItems(_groupProvider, _entryProvider, _parentId);

    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            icon: const FaIcon('times'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(_parentId == 0 ? 'KeepMyPass' : _groupProvider.findById(_parentId).title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 50, left: 8, right: 8),
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, i) => Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: FaIcon(_items[i].icon),
                  backgroundColor: Color(_items[i].iconBackColor),
                  foregroundColor: Color(_items[i].iconForeColor),
                ),
                title: Text(_items[i].title, style: TextStyle(fontWeight: _items[i].isGroup ? FontWeight.bold : FontWeight.normal)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const FaIcon('pencilAlt', size: 16),
                      onPressed: () {
                        _items[i].isGroup ? Navigator.pushNamed(context, AddEditGroupScreen.routeName, arguments: {'id': _items[i].id}) : Navigator.pushNamed(context, AddEditEntryScreen.routeName, arguments: {'id': _items[i].id});
                      },
                    ),
                    IconButton(
                      icon: const FaIcon('solidTrashAlt', size: 16),
                      onPressed: () {
                        _delete(context: context, groupProvider: _groupProvider, entryProvider: _entryProvider, item: _items[i]);
                      },
                    ),
                  ],
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
