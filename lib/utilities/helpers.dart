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

import '../utilities/crypt.dart';

class Helpers {
  static String encrypt(String data, String key) {
    try {
      var bytes = Crypt.string2bytes(data);
      var encrypted = Crypt.encrypt(bytes, key);
      return Crypt.base64encode(encrypted);
    } catch (e) {}
    return '';
  }

  static String decrypt(String data, String key) {
    try {
      var bytes = Crypt.base64decode(data);
      var decrypted = Crypt.decrypt(bytes, key);
      return Crypt.bytes2string(decrypted);
    } catch (e) {}
    return '';
  }

  static String reencrypt(String data, String oldKey, String newKey) {
    return encrypt(decrypt(data, oldKey), newKey);
  }
}
