import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class DriverModel {
  final DriverId id;
  String firstName, lastName, phone, gander;
  String? email, address;
  TruckId? currentTruckId;
  List<TripId> tripsIds;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createAt;

  DriverModel(
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.gander,
    this.currentTruckId,
    this.tripsIds,
    this.details,
    this.images,
    this.createAt,
  );

  String get fullName => '$firstName $lastName';

  Future<List<TripModel>> get trips async => [
        for (TripId id in tripsIds) (await TripModel.fromId(id))!,
      ];

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('drivers');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('drivers');

  static Future init() => collection.set({});

  static DriverModel fromMap(Map data) {
    DriverId id = DriverId.fromString(data['id']);
    return DriverModel(
      id,
      data['first_name'],
      data['last_name'],
      data['phone'],
      data['email'],
      data['address'],
      data['gander'],
      data['current_truck_id'] != null
          ? TruckId.fromString(data['current_truck_id'])
          : null,
      TripId.allFromString(data['trips_ids']),
      Map<String, String>.from(data['details']),
      [for (String file in data['images']) directory.file('$id/$file')],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<DriverId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + DriverId.fromString(item).id);
    return DriverId(lastId + 1);
  }

  static Future<CreateEditModelResult<DriverModel>> create({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
    String gander = 'male',
    TruckId? currentTruckId,
    List<TripId> tripsIds = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    List<DriverModel> drivers = await all();

    for (DriverModel driver in drivers) {
      if (driver.firstName.trim() == firstName.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'First name already used',
          fieldError: 'first_name',
        );
      } else if (driver.lastName.trim() == lastName.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Last name already used',
          fieldError: 'last_name',
        );
      } else if (driver.phone.trim() == phone.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Phone already used',
          fieldError: 'phone',
        );
      } else if ((driver.email != null && email != null) &&
          driver.email!.trim() == email.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Email already used',
          fieldError: 'email',
        );
      }
    }

    DriverModel driver = DriverModel(
      await nextId(),
      firstName,
      lastName,
      phone,
      email,
      address,
      gander,
      currentTruckId,
      tripsIds,
      details,
      images,
      MDateTime.now(),
    );
    await driver.save();

    return CreateEditModelResult<DriverModel>(true, model: driver);
  }

  Future<CreateEditModelResult<DriverModel>> edit({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? gander,
    TruckId? currentTruckId,
    List<TripId>? tripsIds,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    List<DriverModel> drivers = await all();

    for (DriverModel driver in drivers) {
      if (driver.id == id) continue;
      if (firstName != null && driver.firstName.trim() == firstName.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'First name already used',
          fieldError: 'first_name',
        );
      } else if (lastName != null &&
          driver.lastName.trim() == lastName.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Last name already used',
          fieldError: 'last_name',
        );
      } else if (phone != null && driver.phone.trim() == phone.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Phone already used',
          fieldError: 'phone',
        );
      } else if (email != null &&
          driver.email != null &&
          driver.email!.trim() == email.trim()) {
        return const CreateEditModelResult<DriverModel>(
          false,
          message: 'Email already used',
          fieldError: 'email',
        );
      }
    }

    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.phone = phone ?? this.phone;
    this.email = email;
    this.address = address;
    this.gander = gander ?? this.gander;
    this.currentTruckId = currentTruckId;
    this.tripsIds = tripsIds ?? this.tripsIds;
    this.details = details ?? this.details;
    this.images = images ?? this.images;

    await save();

    return CreateEditModelResult<DriverModel>(true, model: this);
  }

  static Future<DriverModel?> fromId(DriverId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static List<DriverModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<DriverModel>> all() async =>
      allFromMap(await collection.get());

  Map<String, dynamic> get map => {
        'id': '$id',
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'address': address,
        'gander': gander,
        'current_truck_id': currentTruckId?.toString(),
        'trips_ids': [for (TripId id in tripsIds) '$id'],
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createAt',
      };

  Future save() => collection.document('$id').set(map);

  Future delete() async {
    if (currentTruckId != null) {
      TruckModel? currentTruck = await TruckModel.fromId(currentTruckId!);
      await currentTruck?.edit(currentDriverId: null);
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'DriverModel(${jsonEncode(map)})';
}

class DriverId {
  final int id;

  const DriverId(this.id);

  static DriverId fromString(String str) {
    Exception throw_() => Exception('Invalid Driver Id');

    if (!str.startsWith('d-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return DriverId(id);
  }

  @override
  bool operator ==(Object other) => other is DriverId && other.id == id;

  @override
  String toString() => 'd-$id';
}
