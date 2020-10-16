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

import '../models/entry.dart';
import '../models/group.dart';

class ContentItem {
  int id;
  bool isGroup;
  String title;
  String icon;
  int iconForeColor;
  int iconBackColor;

  ContentItem.fromGroup(Group group) {
    this.id = group.id;
    this.isGroup = true;
    this.title = group.title;
    this.icon = group.icon;
    this.iconForeColor = group.iconForeColor;
    this.iconBackColor = group.iconBackColor;
  }

  ContentItem.fromEntry(Entry entry) {
    this.id = entry.id;
    this.isGroup = false;
    this.title = entry.title;
    this.icon = entry.icon;
    this.iconForeColor = entry.iconForeColor;
    this.iconBackColor = entry.iconBackColor;
  }
}
