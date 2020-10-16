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

class Entry {
  int id;
  int parentId;
  String title;
  String icon;
  int iconForeColor;
  int iconBackColor;
  String username;
  String password;
  String url;
  String notes;

  Entry({
    this.id,
    this.parentId,
    this.title,
    this.icon,
    this.iconForeColor,
    this.iconBackColor,
    this.username,
    this.password,
    this.url,
    this.notes,
  });

  Entry.fromEntry(Entry entry) {
    this.id = entry.id;
    this.parentId = entry.parentId;
    this.title = entry.title;
    this.icon = entry.icon;
    this.iconForeColor = entry.iconForeColor;
    this.iconBackColor = entry.iconBackColor;
    this.username = entry.username;
    this.password = entry.password;
    this.url = entry.url;
    this.notes = entry.notes;
  }

  Entry.fromMap(Map map) {
    this.id = map['id'];
    this.parentId = map['parentId'];
    this.title = map['title'];
    this.icon = map['icon'];
    this.iconForeColor = map['iconForeColor'];
    this.iconBackColor = map['iconBackColor'];
    this.username = map['username'];
    this.password = map['password'];
    this.url = map['url'];
    this.notes = map['notes'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'parentId': this.parentId,
      'title': this.title,
      'icon': this.icon,
      'iconForeColor': this.iconForeColor,
      'iconBackColor': this.iconBackColor,
      'username': this.username,
      'password': this.password,
      'url': this.url,
      'notes': this.notes,
    };
  }
}
