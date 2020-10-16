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

class Group {
  int id;
  int parentId;
  String title;
  String icon;
  int iconForeColor;
  int iconBackColor;

  Group({
    this.id,
    this.parentId,
    this.title,
    this.icon,
    this.iconForeColor,
    this.iconBackColor,
  });

  Group.fromGroup(Group group) {
    this.id = group.id;
    this.parentId = group.parentId;
    this.title = group.title;
    this.icon = group.icon;
    this.iconForeColor = group.iconForeColor;
    this.iconBackColor = group.iconBackColor;
  }

  Group.fromMap(Map map) {
    this.id = map['id'];
    this.parentId = map['parentId'];
    this.title = map['title'];
    this.icon = map['icon'];
    this.iconForeColor = map['iconForeColor'];
    this.iconBackColor = map['iconBackColor'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'parentId': this.parentId,
      'title': this.title,
      'icon': this.icon,
      'iconForeColor': this.iconForeColor,
      'iconBackColor': this.iconBackColor,
    };
  }
}
