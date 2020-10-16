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

class Assets {
  static const String logo = 'logo';

  static Widget adaptiveLogo(BuildContext context, String image) {
    var width = MediaQuery.of(context).size.height / 10;
    int fileWidth;
    if (width < 32) {
      fileWidth = 32;
    } else if (width < 64) {
      fileWidth = 64;
    } else if (width < 128) {
      fileWidth = 128;
    } else if (width < 256) {
      fileWidth = 256;
    } else {
      fileWidth = 512;
    }
    return Image(
      width: width,
      image: AssetImage('lib/assets/$image-$fileWidth.png'),
    );
  }
}
