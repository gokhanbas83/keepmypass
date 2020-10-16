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

import '../models/entry.dart';

import '../utilities/database.dart';

class Entries with ChangeNotifier {
  List<Entry> _entries;

  List<Entry> get entries {
    return [..._entries];
  }

  Future<void> loadEntries(String password) async {
    _entries = await Database.getEntries(password);
    notifyListeners();
  }

  Future<void> addEntry(Entry entry, String password) async {
    Entry newEntry = Entry.fromEntry(entry);
    newEntry.id = await Database.addEntry(entry, password);
    _entries.add(newEntry);
    notifyListeners();
  }

  Future<void> updateEntry(Entry entry, String password) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    _entries[index] = Entry.fromEntry(entry);
    await Database.updateEntry(entry, password);
    notifyListeners();
  }

  Future<void> deleteEntry(int id) async {
    final index = _entries.indexWhere((e) => e.id == id);
    _entries.removeAt(index);
    await Database.deleteEntry(id);
    notifyListeners();
  }

  List<Entry> filterByParentId(int parentId) {
    return _entries == null ? null : _entries.where((item) => item.parentId == parentId).toList();
  }

  Entry findById(int id) {
    return _entries == null ? null : _entries.firstWhere((item) => item.id == id);
  }

  bool hasSubEntries(int id) {
    final List<Entry> subEntries = filterByParentId(id);
    return (subEntries != null && subEntries.length > 0);
  }
}
