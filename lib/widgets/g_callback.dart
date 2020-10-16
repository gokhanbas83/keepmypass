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

class GCallback extends StatefulWidget {
  final Widget child;
  final Function onShown;

  const GCallback({Key key, this.child, this.onShown}) : super(key: key);

  @override
  _GCallbackState createState() => _GCallbackState();
}

class _GCallbackState extends State<GCallback> {
  @override
  void initState() {
    if (widget.onShown != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onShown(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}