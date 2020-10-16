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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/crypt.dart';
import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../widgets/g_text.dart';

class GPasswordGenerator extends StatefulWidget {
  final TextEditingController controller;

  const GPasswordGenerator({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _GPasswordGeneratorState createState() => _GPasswordGeneratorState();
}

class _GPasswordGeneratorState extends State<GPasswordGenerator> {
  bool _initialized = false;

  SharedPreferences prefs;

  final TextEditingController _lengthTextEditingController = TextEditingController();

  bool _useUppercase = false;
  bool _useLowercase = false;
  bool _useDigit = false;
  bool _useSpecialChars = false;

  //                                       !     ?     +     -     *     /     .     @     #     $     %     &     =     _
  static const List<int> _specialChars = [0x21, 0x3f, 0x2b, 0x2d, 0x2a, 0x2f, 0x2e, 0x40, 0x23, 0x24, 0x25, 0x26, 0x3d, 0x5f];

  void _generate() async {
    int length = int.tryParse(_lengthTextEditingController.text) ?? 8;
    _lengthTextEditingController.text = length.toString();

    _useLowercase = _useLowercase || (!_useUppercase && !_useDigit && !_useSpecialChars);

    await prefs.setInt('length', length);
    await prefs.setBool('useUppercase', _useUppercase);
    await prefs.setBool('useLowercase', _useLowercase);
    await prefs.setBool('useDigit', _useDigit);
    await prefs.setBool('useSpecialChars', _useSpecialChars);

    int sets = 0 + (_useUppercase ? 1 : 0) + (_useLowercase ? 1 : 0) + (_useDigit ? 1 : 0) + (_useSpecialChars ? 1 : 0);
    int charPerSet = (length / sets).ceil();
    Random random = Random();
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < charPerSet; i++) {
      if (_useUppercase) {
        buffer.writeCharCode(random.nextInt(26) + 65);
      }
      if (_useLowercase) {
        buffer.writeCharCode(random.nextInt(26) + 97);
      }
      if (_useDigit) {
        buffer.writeCharCode(random.nextInt(10) + 48);
      }
      if (_useSpecialChars) {
        buffer.writeCharCode(_specialChars[random.nextInt(_specialChars.length)]);
      }
    }

    var chars = Crypt.string2bytes(buffer.toString());
    chars.shuffle();
    String password = Crypt.bytes2string(chars).substring(0, length);
    print(charPerSet);

    setState(() {
      widget.controller.text = password;
    });
  }

  @override
  void didChangeDependencies() async {
    if (!_initialized) {
      prefs = await SharedPreferences.getInstance();

      _lengthTextEditingController.text = (prefs.getInt('length') ?? 8).toString();
      _useUppercase = prefs.getBool('useUppercase') ?? true;
      _useLowercase = prefs.getBool('useLowercase') ?? true;
      _useDigit = prefs.getBool('useDigit') ?? true;
      _useSpecialChars = prefs.getBool('useSpecialChars') ?? true;

      _generate();
      _initialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(tr(W.Generated_Password)),
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                ),
                controller: widget.controller,
                readOnly: true,
              ),
            ),
            FlatButton(
              onPressed: _generate,
              child: const FaIcon('syncAlt'),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: <Widget>[
            GText(
              tr(W.Desired_Length),
              textAlign: TextAlign.justify,
              padding: const EdgeInsets.only(right: 15),
            ),
            Expanded(
              child: TextField(
                controller: _lengthTextEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _useUppercase,
              onChanged: (value) {
                _useUppercase = value;
                _generate();
              },
            ),
            Expanded(
              child: Text(
                '${tr(W.Use_Uppercase)} A-Z',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _useLowercase,
              onChanged: (value) {
                _useLowercase = value;
                _generate();
              },
            ),
            Expanded(
              child: Text(
                '${tr(W.Use_Lowercase)} a-z',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _useDigit,
              onChanged: (value) {
                _useDigit = value;
                _generate();
              },
            ),
            Expanded(
              child: Text(
                '${tr(W.Use_Numbers)} 0-9',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(
              value: _useSpecialChars,
              onChanged: (value) {
                _useSpecialChars = value;
                _generate();
              },
            ),
            Expanded(
              child: Text(
                '${tr(W.Use_Special_Chars)}\n! ? + - * / . @ # \$ % & = _',
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
