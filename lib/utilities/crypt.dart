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

import 'dart:core';
import 'dart:convert' as convert;

import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart' as crypto;

class Crypt {
  static List<int> string2bytes(String data) {
    return convert.utf8.encode(data);
  }

  static String bytes2string(List<int> data) {
    return convert.utf8.decode(data, allowMalformed: true);
  }

  static List<int> encrypt(List<int> data, String key) {
    final encrypter = Encrypter(AES(Key.fromUtf8(key.padLeft(32, '*').substring(0, 32))));
    final iv = IV.fromSecureRandom(16);
    final encrypted = encrypter.encryptBytes(data, iv: iv);
    return [...iv.bytes, ...encrypted.bytes];
  }

  static List<int> decrypt(List<int> data, String key) {
    final encrypter = Encrypter(AES(Key.fromUtf8(key.padLeft(32, '*').substring(0, 32))));
    final iv = IV(data.sublist(0, 16));
    final encrypted = Encrypted(data.sublist(16));
    final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
    return decrypted;
  }

  static List<int> base64decode(String source) {
    return convert.base64Decode(source);
  }

  static String base64encode(List<int> source) {
    return convert.base64Encode(source);
  }

  static String md5(String data) {
    return crypto.md5.convert(convert.utf8.encode(data)).toString();
  }

  static String sha1(String data) {
    return crypto.sha1.convert(convert.utf8.encode(data)).toString();
  }

  static String sha256(String data) {
    return crypto.sha256.convert(convert.utf8.encode(data)).toString();
  }
}
