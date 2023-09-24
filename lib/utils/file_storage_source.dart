import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:storage_database/storage_database.dart';

import '../src/src.dart';

class FileStorageSource extends StorageDatabaseSource {
  final Directory _sourceDir;
  final String _sourcePassword;

  FileStorageSource(this._sourceDir, this._sourcePassword);

  static Future<FileStorageSource> getInstance(
    String sourcePath,
    String sourcePassword,
  ) async {
    Directory source = Directory(sourcePath);
    if (!await source.exists()) source = await source.create();

    File sourceFile = File('$sourcePath/beda3a.b3');
    if (!await sourceFile.exists()) sourceFile = await sourceFile.create();

    String fileContent = await sourceFile.readAsString();
    if (fileContent.isNotEmpty) {
      try {
        decryptData(fileContent, sourcePassword);
      } catch (e) {
        throw Exception('Invalid Password');
      }
    } else {
      sourceFile =
          await sourceFile.writeAsString(encryptData('{}', sourcePassword));
    }

    return FileStorageSource(source, sourcePassword);
  }

  static IV iv = IV.fromUtf8(Consts.appIV);

  static Encrypter encrypter(String password) => Encrypter(
        AES(
          Key.fromUtf8(password.padLeft(32)),
          mode: AESMode.cbc,
        ),
      );

  static String encryptData(String data, String password) =>
      encrypter(password).encrypt(data, iv: iv).base64;

  static String decryptData(String crypto, String password) =>
      encrypter(password).decrypt(Encrypted.fromBase64(crypto), iv: iv);

  File get _source => File("${_sourceDir.path}/beda3a.b3");

  Timer? _cacheTimer;
  void setupCacheTimer() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(seconds: 5), () {
      _cacheData = null;
      _cacheTimer = null;
    });
  }

  Map? _cacheData;
  Future<Map> get getFileData async {
    if (_cacheData == null) {
      String content = await _source.readAsString();
      try {
        _cacheData =
            Map.from(jsonDecode(decryptData(content, _sourcePassword)));
      } catch (e) {
        await setFileData({});
        _cacheData = {};
      }
    }
    setupCacheTimer();
    return _cacheData!;
  }

  Future setFileData(Map data) =>
      _source.writeAsString(encryptData(jsonEncode(data), _sourcePassword));

  @override
  Future setData(String id, data) async {
    Map sourceData = await getFileData;
    sourceData[id] = data;
    await setFileData(sourceData);
  }

  @override
  Future getData(String id) async {
    Map sourceData = await getFileData;
    return sourceData[id];
  }

  @override
  Future<bool> containsKey(String id) async {
    Map sourceData = await getFileData;
    return sourceData.containsKey(id);
  }

  @override
  Future remove(String id) async {
    Map sourceData = await getFileData;
    sourceData.remove(id);
    await setFileData(sourceData);
  }

  @override
  Future clear() => setFileData({});
}
