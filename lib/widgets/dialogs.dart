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
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../utilities/fa_icons_helper.dart';
import '../utilities/translation.dart';

import '../widgets/g_callback.dart';
import '../widgets/g_password_generator.dart';

class Dialogs {
  static Future<void> showAlert({BuildContext context, String title, String message, String buttonText}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingWithTask({BuildContext context, String message, Function function}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GCallback(
          onShown: (_) async {
            await function();
            Navigator.of(context).pop(true);
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      Text(message),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
    print("f11");
    await function();
    print("f22");
  }

  static Future<bool> showConfirm({BuildContext context, String message}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr(W.Confirm)),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(tr(W.Yes)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text(tr(W.No)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<Color> materialColorPicker(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: currentColor,
              enableLabel: true,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
      },
    );
  }

  static Future<Color> blockColorPicker(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
            ),
          ),
        );
      },
    );
  }

  static Future<Color> colorColorPicker(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
              colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: true,
              displayThumbColor: true,
              showLabel: true,
              paletteType: PaletteType.hsv,
              pickerAreaBorderRadius: const BorderRadius.only(
                topLeft: const Radius.circular(2.0),
                topRight: const Radius.circular(2.0),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<Color> slideColorPicker(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: SlidePicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                Navigator.of(context).pop(color);
              },
              paletteType: PaletteType.rgb,
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: false,
              showIndicator: true,
              indicatorBorderRadius: const BorderRadius.vertical(
                top: const Radius.circular(25.0),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<String> faIconPicker(BuildContext context, String currentIcon) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(0.0),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: Container(
              width: 300.0,
              height: 360.0,
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: FontAwesomeIconsMap.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                    child: GridTile(
                      footer: Text(
                        FontAwesomeIconsMap.keys.elementAt(i),
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(FontAwesomeIconsMap.keys.elementAt(i));
                          },
                          child: CircleAvatar(
                            child: FaIcon(FontAwesomeIconsMap.keys.elementAt(i)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<String> passwordGenerator(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController _passwordTextEditingController = TextEditingController();
        return AlertDialog(
          title: Text(tr(W.Password_Generator)),
          content: SingleChildScrollView(
            child: GPasswordGenerator(
              controller: _passwordTextEditingController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(tr(W.Accept)),
              onPressed: () {
                Navigator.of(context).pop(_passwordTextEditingController.text);
              },
            ),
            FlatButton(
              child: Text(tr(W.Cancel)),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }
}
