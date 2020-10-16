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

import '../models/group.dart';

import '../providers/groups.dart';
import '../providers/user.dart';

import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../widgets/dialogs.dart';

class AddEditGroupScreen extends StatefulWidget {
  static const routeName = '/AddEditGroupScreen';

  const AddEditGroupScreen({Key key}) : super(key: key);

  @override
  _AddEditGroupScreenState createState() => _AddEditGroupScreenState();
}

class _AddEditGroupScreenState extends State<AddEditGroupScreen> {
  bool _initialized = false;
  bool _saving = false;

  int _id;
  Group _group;
  final TextEditingController _titleTextEditingController = TextEditingController();

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });
    _group.title = _titleTextEditingController.text;
    final String _password = Provider.of<User>(context, listen: false).password;
    (_id == 0) ? await Provider.of<Groups>(context, listen: false).addGroup(_group, _password) : await Provider.of<Groups>(context, listen: false).updateGroup(_group, _password);
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      final Map<String, Object> _args = ModalRoute.of(context).settings.arguments as Map<String, Object>;
      _id = (_args != null && _args.containsKey('id')) ? _args['id'] : 0;
      _group = (_id == 0) ? Group() : Provider.of<Groups>(context, listen: false).findById(_id);
      if (_id == 0) {
        _group.parentId = (_args != null && _args.containsKey('parentId')) ? _args['parentId'] : 0;
        _group.title = '';
        _group.icon = 'solidFolder';
        _group.iconBackColor = 4294246487;
        _group.iconForeColor = 4294967295;
      }
      _titleTextEditingController.text = _group.title;

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
        title: Text((_id == 0) ? tr(W.Add_Group) : tr(W.Edit_Group)),
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
                        tr(W.Group_Title),
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
                            child: FaIcon(_group.icon),
                            backgroundColor: Color(_group.iconBackColor),
                            foregroundColor: Color(_group.iconForeColor),
                          ),
                          onTap: () {
                            Dialogs.faIconPicker(context, _group.icon).then((value) {
                              if (value != null) {
                                setState(() {
                                  _group.icon = value;
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Color(_group.iconBackColor),
                          ),
                          onTap: () {
                            Dialogs.materialColorPicker(context, Color(_group.iconBackColor)).then((value) {
                              if (value != null) {
                                setState(() {
                                  _group.iconBackColor = value.value;
                                });
                              }
                            });
                          },
                        ),
                        GestureDetector(
                          child: CircleAvatar(
                            backgroundColor: Color(_group.iconForeColor),
                          ),
                          onTap: () {
                            Dialogs.materialColorPicker(context, Color(_group.iconForeColor)).then((value) {
                              if (value != null) {
                                setState(() {
                                  _group.iconForeColor = value.value;
                                });
                              }
                            });
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
