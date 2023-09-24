import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class TruckModel {
  final TruckId id;
  String name;
  DriverId? currentDriverId;
  List<TripId> tripsIds;
  List<ExpensesId> expensesIds;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  TruckModel(
    this.id,
    this.name,
    this.currentDriverId,
    this.tripsIds,
    this.expensesIds,
    this.details,
    this.images,
    this.createdAt,
  );

  Future<List<TripModel>> get trips async => TripModel.allFromId(tripsIds);
  Future<List<ExpensesModel>> get expenses async =>
      ExpensesModel.allFromId(expensesIds);

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('trucks');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('trucks');

  static Future init() => collection.set({});

  static TruckModel fromMap(Map data) {
    TruckId id = TruckId.fromString(data['id']);
    return TruckModel(
      id,
      data['name'],
      data['current_driver_id'] != null
          ? DriverId.fromString(data['current_driver_id'])
          : null,
      TripId.allFromString(data['trips_ids']),
      ExpensesId.allFromString(data['expenses_ids']),
      Map<String, String>.from(data['details']),
      [for (String file in data['images']) directory.file('$id/$file')],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<TruckId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + TruckId.fromString(item).id);
    return TruckId(lastId + 1);
  }

  static Future<CreateEditModelResult<TruckModel>> create({
    required String name,
    DriverId? currentDriverId,
    List<TripId> tripsIds = const [],
    List<ExpensesId> expensesIds = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    List<TruckModel> trucks = await all();

    for (TruckModel truck in trucks) {
      if (truck.name.trim() == name.trim()) {
        return const CreateEditModelResult<TruckModel>(
          false,
          message: 'Truck name already used',
          fieldError: 'name',
        );
      }
    }

    TruckModel truck = TruckModel(
      await nextId(),
      name,
      currentDriverId,
      tripsIds,
      expensesIds,
      details,
      images,
      MDateTime.now(),
    );
    await truck.save();

    return CreateEditModelResult<TruckModel>(true, model: truck);
  }

  Future<CreateEditModelResult<TruckModel>> edit({
    String? name,
    DriverId? currentDriverId,
    List<TripId>? tripsIds,
    List<ExpensesId>? expensesIds,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    List<TruckModel> trucks = await all();

    for (TruckModel truck in trucks) {
      if (truck.id == id) continue;
      if (name != null && truck.name.trim() == name.trim()) {
        return const CreateEditModelResult<TruckModel>(
          false,
          message: 'Truck name already used',
          fieldError: 'name',
        );
      }
    }

    this.name = name ?? this.name;
    this.currentDriverId = currentDriverId ?? this.currentDriverId;
    this.tripsIds = tripsIds ?? this.tripsIds;
    this.expensesIds = expensesIds ?? this.expensesIds;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<TruckModel>(true, model: this);
  }

  static Future<TruckModel?> fromId(TruckId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static List<TruckModel> allFromMap(Map items) => [
        for (String id in items.keys)
          if (items[id].isNotEmpty) fromMap(items[id])
      ];

  static Future<List<TruckModel>> all() async =>
      allFromMap(await collection.get());

  static Future<Map<TruckId, TruckModel>> allMap() async => {
        for (TruckModel truck in await all()) truck.id: truck,
      };

  static Stream<Map<TruckId, TruckModel>> streamMap() =>
      collection.stream().asyncExpand((data) async* {
        List<TruckModel> all = data != null ? allFromMap(data) : [];
        yield {
          for (TruckModel truck in all) truck.id: truck,
        };
      });

  Map<String, dynamic> get map => {
        'id': '$id',
        'name': name,
        'current_driver_id': currentDriverId?.toString(),
        'trips_ids': [for (TripId id in tripsIds) '$id'],
        'expenses_ids': [for (ExpensesId id in expensesIds) '$id'],
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createdAt',
      };

  Future save() => collection.document('$id').set(map);

  Future delete() async {
    List<TripModel> trips = await this.trips;
    for (TripModel trip in trips) {
      await trip.delete();
    }
    if (currentDriverId != null) {
      DriverModel? driver = await DriverModel.fromId(currentDriverId!);
      if (driver?.currentTruckId == id) driver?.currentTruckId = null;
      await driver?.save();
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'TruckModel(${jsonEncode(map)})';
}

class TruckId {
  final int id;

  const TruckId(this.id);

  static TruckId fromString(String str) {
    Exception throw_() => Exception('Invalid Truck Id');

    if (!str.startsWith('t-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return TruckId(id);
  }

  @override
  bool operator ==(Object other) => other is TruckId && other.id == id;

  @override
  String toString() => 't-$id';
}

class TruckStatistics {
  double totalTripsEarn;
  double totalExpensesCost;
  double totalTripsExpensesCost;
  double consumptionRatio;

  TruckStatistics(
    this.totalTripsEarn,
    this.totalExpensesCost,
    this.totalTripsExpensesCost,
    this.consumptionRatio,
  );

  double get productivityRatio => 100 - consumptionRatio;

  static TruckStatistics get empty => TruckStatistics(0, 0, 0, 0);

  static TruckStatistics fromMap(Map data) => TruckStatistics(
        double.tryParse(data['total_trips_earn'].toString()) ?? 0,
        double.tryParse(data['total_expenses_cost'].toString()) ?? 0,
        double.tryParse(data['total_trips_expenses_cost'].toString()) ?? 0,
        double.tryParse(data['consumption_ratio'].toString()) ?? 0,
      );

  Future calculate(TruckModel truck) async {
    List<TripModel> trips = await truck.trips;
    totalTripsEarn = 0;
    totalTripsExpensesCost = 0;
    for (TripModel trip in trips) {
      totalTripsEarn += trip.statistics.totalOrdersCost;
      totalTripsExpensesCost += trip.statistics.totalTruckExpensesCost;
    }

    List<ExpensesModel> expenses = await truck.expenses;
    totalExpensesCost = 0;
    for (ExpensesModel expenses in expenses) {
      totalExpensesCost += expenses.cost;
    }
    consumptionRatio = totalTripsEarn / totalExpensesCost;
  }
}
