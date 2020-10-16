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

import '../utilities/fa_icons_helper.dart';

class GPasswordField extends StatefulWidget {
  final InputDecoration decoration;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final bool readOnly;

  const GPasswordField({
    Key key,
    this.decoration = const InputDecoration(),
    this.controller,
    this.onSubmitted,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _GPasswordFieldState createState() => _GPasswordFieldState();
}

class _GPasswordFieldState extends State<GPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            obscureText: _obscureText,
            decoration: widget.decoration,
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            readOnly: widget.readOnly,
          ),
        ),
        FlatButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: _obscureText ? const FaIcon('eyeSlash') : const FaIcon('eye'),
        ),
      ],
    );
  }
}
