import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_explorer/storage_explorer.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';

class UserModel {
  String firstName, lastName, phone, gander, password;
  String? email, company, address;
  bool isAuth;
  List<ExplorerFile> images;
  final MDateTime? createdAt;

  UserModel(
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.company,
    this.address,
    this.gander,
    this.password,
    this.isAuth,
    this.images,
    this.createdAt,
  );

  String get fullName => '$firstName $lastName';

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('user');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('user');

  static Future init() => collection.set({});

  static Future<UserModel?> get() async {
    Map data = (await collection.get() as Map);
    if (data.isNotEmpty) return fromMap(data);
    return null;
  }

  static Future<UserModel> setup(UserModel user) async {
    if (await get() != null) throw Exception("The User already exists");
    await user.save();
    return user;
  }

  Future<CreateEditModelResult<UserModel>> edit({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? company,
    String? address,
    String? gander,
    String? password,
    List<ExplorerFile>? images,
  }) async {
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.phone = phone ?? this.phone;
    this.email = email ?? this.email;
    this.company = company ?? this.company;
    this.address = address ?? this.address;
    this.gander = gander ?? this.gander;
    this.password = password ?? this.password;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<UserModel>(true, model: this);
  }

  static UserModel fromMap(Map data) => UserModel(
        data['first_name'],
        data['last_name'],
        data['phone'],
        data['email'],
        data['company'],
        data['address'],
        data['gander'],
        data['password'],
        data['is_auth'] ?? false,
        [for (String file in data['images']) directory.file(file)],
        MDateTime.fromString(data['created_at']),
      );

  Map<String, dynamic> get map => {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'company': company,
        'address': address,
        'gander': gander,
        'password': password,
        'is_auth': isAuth,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createdAt',
      };

  Future save() => collection.set(map);

  @override
  String toString() => 'UserModel(${jsonEncode(map)})';
}
