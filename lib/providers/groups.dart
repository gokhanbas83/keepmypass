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

import '../models/group.dart';

import '../utilities/database.dart';

class Groups with ChangeNotifier {
  List<Group> _groups;

  List<Group> get groups {
    return [..._groups];
  }

  Future<void> loadGroups(String password) async {
    _groups = await Database.getGroups(password);
    notifyListeners();
  }

  Future<void> addGroup(Group group, String password) async {
    Group newGroup = Group.fromGroup(group);
    newGroup.id = await Database.addGroup(group, password);
    _groups.add(newGroup);
    notifyListeners();
  }

  Future<void> updateGroup(Group group, String password) async {
    final index = _groups.indexWhere((g) => g.id == group.id);
    _groups[index] = Group.fromGroup(group);
    await Database.updateGroup(group, password);
    notifyListeners();
  }

  Future<void> deleteGroup(int id) async {
    final index = _groups.indexWhere((g) => g.id == id);
    _groups.removeAt(index);
    await Database.deleteGroup(id);
    notifyListeners();
  }

  List<Group> filterByParentId(int parentId) {
    return _groups == null ? null : _groups.where((item) => item.parentId == parentId).toList();
  }

  Group findById(int id) {
    return _groups == null ? null : _groups.firstWhere((item) => item.id == id);
  }

  bool hasSubGroups(int id) {
    final List<Group> subGroups = filterByParentId(id);
    return (subGroups != null && subGroups.length > 0);
  }
}
