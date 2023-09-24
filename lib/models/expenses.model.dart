import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class ExpensesModel {
  final ExpensesId id;
  TruckId? truckId;
  TripId? tripId;
  String name;
  double cost;
  String? address;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  ExpensesModel(
    this.id,
    this.truckId,
    this.tripId,
    this.name,
    this.cost,
    this.address,
    this.details,
    this.images,
    this.createdAt,
  );

  bool get isTruckExpenses => truckId != null;
  bool get isTripExpenses => tripId != null;

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('expenses');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('expenses');

  static Future init() => collection.set({});

  static ExpensesModel fromMap(Map data) {
    ExpensesId id = ExpensesId.fromString(data['id']);
    return ExpensesModel(
      id,
      data['truck_id'] != null ? TruckId.fromString(data['truck_id']) : null,
      data['trip_id'] != null ? TripId.fromString(data['trip_id']) : null,
      data['name'],
      double.tryParse(data['cost'].toString()) ?? 0,
      data['address'],
      Map<String, String>.from(data['details']),
      [for (String file in data['images']) directory.file('$id/$file')],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<ExpensesId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + ExpensesId.fromString(item).id);
    return ExpensesId(lastId + 1);
  }

  static Future<CreateEditModelResult<ExpensesModel>> create({
    TruckId? truckId,
    TripId? tripId,
    required String name,
    required double cost,
    String? address,
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    ExpensesModel expenses = ExpensesModel(
      await nextId(),
      truckId,
      tripId,
      name,
      cost,
      address,
      details,
      images,
      MDateTime.now(),
    );
    await expenses.save();
    return CreateEditModelResult<ExpensesModel>(true, model: expenses);
  }

  Future<CreateEditModelResult<ExpensesModel>> edit({
    TruckId? truckId,
    TripId? tripId,
    String? name,
    double? cost,
    String? address,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    this.truckId = truckId;
    this.tripId = tripId;
    this.name = name ?? this.name;
    this.cost = cost ?? this.cost;
    this.address = address;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<ExpensesModel>(true, model: this);
  }

  static Future<ExpensesModel?> fromId(ExpensesId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static Future<List<ExpensesModel>> allFromId(List<ExpensesId> ids) async => [
        for (ExpensesId id in ids) (await fromId(id))!,
      ];

  static List<ExpensesModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<ExpensesModel>> all() async =>
      allFromMap(await collection.get());

  Map<String, dynamic> get map => {
        'id': '$id',
        'truck_id': truckId?.toString(),
        'trip_id': tripId?.toString(),
        'name': name,
        'cost': cost,
        'address': address,
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createdAt',
      };

  Future save() => collection.document('$id').set(map);

  Future delete() async {
    if (truckId != null) {
      TruckModel? truck = await TruckModel.fromId(truckId!);
      truck?.expensesIds.removeWhere((id) => id == this.id);
      await truck?.save();
    }
    if (tripId != null) {
      TripModel? trip = await TripModel.fromId(tripId!);
      trip?.expensesIds.removeWhere((id) => id == this.id);
      await trip?.save();
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'ExpensesModel(${jsonEncode(map)})';
}

class ExpensesId {
  final int id;

  const ExpensesId(this.id);

  static ExpensesId fromString(String str) {
    Exception throw_() => Exception('Invalid Expenses Id');

    if (!str.startsWith('d-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return ExpensesId(id);
  }

  static List<ExpensesId> allFromString(List items) => [
        for (String id in items) fromString(id),
      ];

  @override
  bool operator ==(Object other) => other is ExpensesId && other.id == id;

  @override
  String toString() => 'e-$id';
}
