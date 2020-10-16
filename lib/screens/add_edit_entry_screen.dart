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

import '../models/entry.dart';

import '../providers/entries.dart';
import '../providers/user.dart';

import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../widgets/dialogs.dart';
import '../widgets/g_password_field.dart';

class AddEditEntryScreen extends StatefulWidget {
  static const routeName = '/AddEditEntryScreen';

  AddEditEntryScreen({Key key}) : super(key: key);

  @override
  _AddEditEntryScreenState createState() => _AddEditEntryScreenState();
}

class _AddEditEntryScreenState extends State<AddEditEntryScreen> {
  bool _initialized = false;
  bool _saving = false;

  int _id;
  Entry _entry;
  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _usernameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _urlTextEditingController = TextEditingController();
  final TextEditingController _notesTextEditingController = TextEditingController();

  void _save() async {
    setState(() {
      _saving = true;
    });
    _entry.title = _titleTextEditingController.text;
    _entry.username = _usernameTextEditingController.text;
    _entry.password = _passwordTextEditingController.text;
    _entry.url = _urlTextEditingController.text;
    _entry.notes = _notesTextEditingController.text;
    final String _password = Provider.of<User>(context, listen: false).password;
    (_id == 0) ? await Provider.of<Entries>(context, listen: false).addEntry(_entry, _password) : await Provider.of<Entries>(context, listen: false).updateEntry(_entry, _password);
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      final Map<String, Object> _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
      _id = (_args != null && _args.containsKey('id')) ? _args['id'] : 0;
      _entry = (_id == 0) ? Entry() : Provider.of<Entries>(context, listen: false).findById(_id);
      if (_id == 0) {
        _entry.parentId = (_args != null && _args.containsKey('parentId')) ? _args['parentId'] : 0;
        _entry.title = '';
        _entry.icon = 'addressCard';
        _entry.iconBackColor = 4294246487;
        _entry.iconForeColor = 4294967295;
      }
      _titleTextEditingController.text = _entry.title;
      _usernameTextEditingController.text = _entry.username;
      _passwordTextEditingController.text = _entry.password;
      _urlTextEditingController.text = _entry.url;
      _notesTextEditingController.text = _entry.notes;

      _initialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _saving
            ? null
            : IconButton(
                icon: const FaIcon('times'),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text((_id == 0) ? tr(W.Add_Entry) : tr(W.Edit_Entry)),
        actions: _saving
            ? null
            : <Widget>[
                IconButton(
                  icon: const FaIcon('check'),
                  onPressed: _save,
                ),
              ],
      ),
      body: SafeArea(
        child: _saving
            ? Container(
                child: const Center(
                  child: const CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20, bottom: 50, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Entry_Title),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextField(
                      controller: _titleTextEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(5),
                      ),
                    ),
                    const Divider(height: 50),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Icon_Appearance),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            tr(W.Icon),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            tr(W.Background),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            tr(W.Foreground),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          child: CircleAvatar(
                            child: FaIcon(_entry.icon),
                            backgroundColor: Color(_entry.iconBackColor),
                            foregroundColor: Color(_entry.iconForeColor),
                          ),
                          onTap: () {
                            Dialogs.faIconPicker(context, _entry.icon).then((value) {
                              if (value != null) {
                                setState(() {
                                  _entry.icon = value;
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Color(_entry.iconBackColor),
                          ),
                          onTap: () {
                            Dialogs.materialColorPicker(context, Color(_entry.iconBackColor)).then((value) {
                              if (value != null) {
                                setState(() {
                                  _entry.iconBackColor = value.value;
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Color(_entry.iconForeColor),
                          ),
                          onTap: () {
                            Dialogs.materialColorPicker(context, Color(_entry.iconForeColor)).then((value) {
                              if (value != null) {
                                setState(() {
                                  _entry.iconForeColor = value.value;
                                });
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 50),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Username),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextField(
                      controller: _usernameTextEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(5),
                      ),
                    ),
                    const Divider(height: 50),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Password),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: GPasswordField(
                            controller: _passwordTextEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.all(5),
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            Dialogs.passwordGenerator(context).then((password) {
                              if (password != null) {
                                setState(() {
                                  _passwordTextEditingController.text = password;
                                });
                              }
                            });
                          },
                          child: const FaIcon('cogs'),
                        ),
                      ],
                    ),
                    const Divider(height: 50),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Url),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextField(
                      controller: _urlTextEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(5),
                      ),
                    ),
                    const Divider(height: 50),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: double.infinity,
                      child: Text(
                        tr(W.Notes),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextField(
                      controller: _notesTextEditingController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(5),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
