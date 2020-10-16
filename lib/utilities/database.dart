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
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/user.dart';
import '../models/entry.dart';
import '../models/group.dart';

import '../utilities/crypt.dart';
import '../utilities/helpers.dart';
import '../utilities/translation.dart';

class Database {
  static const _databaseFile = 'password-2.db';
  static sqflite.Database _database;

  Database() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static Future<void> register(String password, String theme, String language) async {
    await _open();

    var batch = _database.batch();
    batch.rawDelete("DELETE FROM UserInformation;");
    batch.insert('UserInformation', {'name': 'password', 'value': Crypt.sha256(password)});
    batch.insert('UserInformation', {'name': 'theme', 'value': theme});
    batch.insert('UserInformation', {'name': 'language', 'value': language});

    batch.insert('Groups', {'parentId': 0, 'title': Helpers.encrypt(tr(W.Shopping), password), 'icon': 'shoppingCart', 'iconForeColor': 4294967295, 'iconBackColor': 4280915000});
    batch.insert('Groups', {'parentId': 0, 'title': Helpers.encrypt(tr(W.Social_Media), password), 'icon': 'thumbsUp', 'iconForeColor': 4294967295, 'iconBackColor': 4282414079});

    batch.insert('Entries', {
      'parentId': 1,
      'title': Helpers.encrypt('Amazon', password),
      'icon': 'amazon',
      'iconForeColor': 4278190080,
      'iconBackColor': 4294967295,
      'username': Helpers.encrypt('admin', password),
      'password': Helpers.encrypt('1234', password),
      'url': Helpers.encrypt('https://www.amazon.com', password),
      'notes': ''
    });
    batch.insert('Entries', {
      'parentId': 2,
      'title': Helpers.encrypt('Facebook', password),
      'icon': 'facebookF',
      'iconForeColor': 4294967295,
      'iconBackColor': 4282542002,
      'username': Helpers.encrypt('admin', password),
      'password': Helpers.encrypt('1234', password),
      'url': Helpers.encrypt('https://www.facebook.com', password),
      'notes': ''
    });
    batch.insert('Entries', {
      'parentId': 0,
      'title': Helpers.encrypt('GMail', password),
      'icon': 'envelope',
      'iconForeColor': 4294967295,
      'iconBackColor': 4294246487,
      'username': Helpers.encrypt('admin', password),
      'password': Helpers.encrypt('1234', password),
      'url': Helpers.encrypt('https://www.google.com/gmail', password),
      'notes': ''
    });

    await batch.commit();

    await _close();
  }

  static Future<bool> checkPassword(String password) async {
    return (await _getUserInformation('password') ?? '').toString() == Crypt.sha256(password);
  }

  ///

  static Future<dynamic> _getUserInformation(String name) async {
    await _open();

    List<Map> results = await _database.query('UserInformation', columns: ['value'], where: 'name = ?', whereArgs: [name]);

    await _close();

    return (results.length > 0) ? results[0]['value'] : null;
  }

  static Future<void> _setUserInformation(String name, dynamic value) async {
    await _open();

    await _database.update('UserInformation', {'value': value}, where: 'name = ?', whereArgs: [name]);

    await _close();
  }

  static Future<User> getUser() async {
    await _open();
    List<Map> results = await _database.query('UserInformation', columns: ['value', 'name']);
    await _close();

    var user = User();

    results.forEach((element) {
      if (element.containsKey('name') && element.containsKey('value')) {
        if (element['name'] == 'password') {
          user.password = element['value'];
        }
        if (element['name'] == 'theme') {
          user.theme = element['value'];
        }
        if (element['name'] == 'language') {
          user.language = element['value'];
        }
      }
    });

    return user;
  }

  static Future<void> setPassword(String oldPassword, String newPassword) async {
    await _open();

    var batch = _database.batch();

    List<Map> entries = await _database.query('Entries', columns: ['*']);

    entries.forEach((element) {
      var ent = Entry.fromMap(element);
      ent.password = Helpers.reencrypt(ent.password, oldPassword, newPassword);
      ent.url = Helpers.reencrypt(ent.url, oldPassword, newPassword);
      ent.title = Helpers.reencrypt(ent.title, oldPassword, newPassword);
      ent.username = Helpers.reencrypt(ent.username, oldPassword, newPassword);
      ent.notes = Helpers.reencrypt(ent.notes, oldPassword, newPassword);
      batch.update('Entries', ent.toMap(), where: 'id = ?', whereArgs: [ent.id]);
    });

    List<Map> groups = await _database.query('Groups', columns: ['*']);

    groups.forEach((element) {
      var grp = Group.fromMap(element);
      grp.title = Helpers.reencrypt(grp.title, oldPassword, newPassword);
      batch.update('Groups', grp.toMap(), where: 'id = ?', whereArgs: [grp.id]);
    });

    batch.update('UserInformation', {'value': Crypt.sha256(newPassword)}, where: 'name = ?', whereArgs: ['password']);

    await batch.commit();

    await _close();
  }

  static Future<void> setTheme(String theme) async {
    await _setUserInformation('theme', theme);
  }

  static Future<void> setLanguage(String language) async {
    await _setUserInformation('language', language);
  }

  ///

  static Future<List<Group>> getGroups(String password) async {
    await _open();

    List<Map> results = await _database.query('Groups', columns: ['*'], orderBy: 'title ASC');

    await _close();

    return List.generate(results.length, (i) {
      var grp = Group.fromMap(results[i]);
      grp.title = Helpers.decrypt(grp.title, password);
      return grp;
    });
  }

  static Future<int> addGroup(Group group, String password) async {
    await _open();

    var grp = Group.fromGroup(group);
    grp.title = Helpers.encrypt(grp.title, password);
    int lastId = await _database.insert('Groups', grp.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);

    await _close();

    return lastId;
  }

  static Future<void> updateGroup(Group group, String password) async {
    await _open();

    var grp = Group.fromGroup(group);
    grp.title = Helpers.encrypt(grp.title, password);
    await _database.update('Groups', grp.toMap(), where: "id = ?", whereArgs: [group.id]);

    await _close();
  }

  static Future<void> deleteGroup(int id) async {
    await _open();

    await _database.delete('Groups', where: "id = ?", whereArgs: [id]);

    await _close();
  }

  ///

  static Future<List<Entry>> getEntries(String password) async {
    await _open();

    List<Map> results = await _database.query('Entries', columns: ['*'], orderBy: 'title ASC');

    await _close();

    return List.generate(results.length, (i) {
      var ent = Entry.fromMap(results[i]);
      ent.password = Helpers.decrypt(ent.password, password);
      ent.url = Helpers.decrypt(ent.url, password);
      ent.title = Helpers.decrypt(ent.title, password);
      ent.username = Helpers.decrypt(ent.username, password);
      ent.notes = Helpers.decrypt(ent.notes, password);
      return ent;
    });
  }

  static Future<int> addEntry(Entry entry, String password) async {
    await _open();

    var ent = Entry.fromEntry(entry);
    ent.password = Helpers.encrypt(ent.password, password);
    ent.url = Helpers.encrypt(ent.url, password);
    ent.title = Helpers.encrypt(ent.title, password);
    ent.username = Helpers.encrypt(ent.username, password);
    ent.notes = Helpers.encrypt(ent.notes, password);
    int lastId = await _database.insert('Entries', ent.toMap(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);

    await _close();

    return lastId;
  }

  static Future<void> updateEntry(Entry entry, String password) async {
    await _open();

    var ent = Entry.fromEntry(entry);
    ent.password = Helpers.encrypt(ent.password, password);
    ent.url = Helpers.encrypt(ent.url, password);
    ent.title = Helpers.encrypt(ent.title, password);
    ent.username = Helpers.encrypt(ent.username, password);
    ent.notes = Helpers.encrypt(ent.notes, password);
    await _database.update('Entries', ent.toMap(), where: "id = ?", whereArgs: [ent.id]);

    await _close();
  }

  static Future<void> deleteEntry(int id) async {
    await _open();

    await _database.delete('Entries', where: "id = ?", whereArgs: [id]);

    await _close();
  }

  ///

  static Future<void> _open() async {
    _database = await sqflite.openDatabase(
      join(await sqflite.getDatabasesPath(), _databaseFile),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
  }

  static Future<void> _onCreate(sqflite.Database database, int version) async {
    var batch = database.batch();
    batch.execute('CREATE TABLE UserInformation (id INTEGER PRIMARY KEY, name TEXT, value TEXT);');
    batch.execute('CREATE TABLE Groups (id INTEGER PRIMARY KEY, parentId INTEGER, title TEXT, icon TEXT, iconForeColor INTEGER, iconBackColor INTEGER);');
    batch.execute('CREATE TABLE Entries (id INTEGER PRIMARY KEY, parentId INTEGER, title TEXT, icon TEXT, iconForeColor INTEGER, iconBackColor INTEGER, username TEXT, password TEXT, url TEXT, notes TEXT);');

    await batch.commit();
  }

  static Future<void> _onUpgrade(sqflite.Database database, int oldVersion, int newVersion) async {
    if (newVersion == 2) {
      ///
    }
  }

  static Future<void> _close() async {
    if (_database.isOpen) {
      await _database.close();
    }
  }
}
