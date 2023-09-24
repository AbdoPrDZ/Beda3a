import 'package:beda3a/views/views.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class TripModel {
  final TripId id;
  String from, to;
  double distance;
  MDateTime? startAt, endAt;
  List<OrderId> ordersIds;
  List<ExpensesId> expensesIds;
  TripStatistics statistics;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  TripModel(
    this.id,
    this.from,
    this.to,
    this.distance,
    this.startAt,
    this.endAt,
    this.ordersIds,
    this.expensesIds,
    this.statistics,
    this.details,
    this.images,
    this.createdAt,
  );

  Future<List<OrderModel>> get orders => OrderModel.allFromId(ordersIds);
  Future<List<ExpensesModel>> get expenses =>
      ExpensesModel.allFromId(expensesIds);

  // double get totalOrdersCost =>
  //     orders.fold<double>(0, (value, order) => value + order.totalCost);
  // double get totalOrdersPaid =>
  //     orders.fold<double>(0, (value, order) => value + order.totalPaid);
  // double get totalOrdersDebt => totalOrdersCost - totalOrdersPaid;

  // double get totalOrdersPayloadsCost =>
  //     orders.fold<double>(0, (value, order) => value + order.totalPayloadsCost);
  // double get totalOrdersPayloadsPaid =>
  //     orders.fold<double>(0, (value, order) => value + order.totalPayloadsPaid);
  // double get totalOrdersPayloadsDebt =>
  //     totalOrdersPayloadsCost - totalOrdersPayloadsPaid;

  // double get totalOrdersMiniPayloadsCost => orders.fold<double>(
  //     0, (value, order) => value + order.totalMiniPayloadsCost);
  // double get totalOrdersMiniPayloadsPaid => orders.fold<double>(
  //     0, (value, order) => value + order.totalMiniPayloadsPaid);
  // double get totalOrdersMiniPayloadsDebt =>
  //     totalOrdersMiniPayloadsCost - totalOrdersMiniPayloadsPaid;

  Duration get tripPeriod => startAt != null && endAt != null
      ? DateTimeRange(start: startAt!, end: endAt!).duration
      : const Duration();

  Speed? get mediumSpeed =>
      Speed.fromDuration(duration: tripPeriod, distance: distance);

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('trips');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('trips');

  static Future init() => collection.set({});

  static TripModel fromMap(Map data) {
    TripId id = TripId.fromString(data['id']);
    return TripModel(
      id,
      data['from'],
      data['to'],
      double.tryParse(data['distance']) ?? 0,
      data['start_at'] != null ? MDateTime.fromString(data['start_at']) : null,
      data['end_at'] != null ? MDateTime.fromString(data['end_at']) : null,
      OrderId.allFromString(data['orders_ids']),
      ExpensesId.allFromString(data['expenses_ids']),
      TripStatistics.fromMap(data['statistics']),
      Map<String, String>.from(data['details']),
      [
        for (String file in data['images']) directory.file('$id/$file'),
      ],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<TripId> nextId(TruckId truckId) async {
    Map items = await collection.get();
    int lastId =
        items.keys.fold(0, (value, item) => value + TripId.fromString(item).id);
    return TripId(truckId, lastId + 1);
  }

  static Future<CreateEditModelResult<TripModel>> create({
    required TruckId truckId,
    required String from,
    required String to,
    double? distance,
    MDateTime? startAt,
    MDateTime? endAt,
    List<OrderId> ordersIds = const [],
    List<ExpensesId> expensesIds = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    TripModel trip = TripModel(
      await nextId(truckId),
      from,
      to,
      distance ?? 0,
      startAt,
      endAt,
      ordersIds,
      expensesIds,
      TripStatistics.empty,
      details,
      images,
      MDateTime.now(),
    );
    await trip.save();

    return CreateEditModelResult<TripModel>(true, model: trip);
  }

  Future<CreateEditModelResult<TripModel>> edit({
    String? from,
    String? to,
    double? distance,
    MDateTime? startAt,
    MDateTime? endAt,
    List<OrderId>? ordersIds,
    List<ExpensesId>? expensesIds,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    this.from = from ?? this.from;
    this.to = to ?? this.to;
    this.distance = distance ?? this.distance;
    this.startAt = startAt;
    this.endAt = endAt;
    this.ordersIds = ordersIds ?? this.ordersIds;
    this.expensesIds = expensesIds ?? this.expensesIds;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<TripModel>(true, model: this);
  }

  static Future<TripModel?> fromId(TripId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static Future<List<TripModel>> allFromId(List<TripId> ids) async => [
        for (TripId id in ids) (await fromId(id))!,
      ];

  static List<TripModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<TripModel>> all() async =>
      allFromMap(await collection.get());

  Map<String, dynamic> get map => {
        'id': '$id',
        'from': from,
        'to': to,
        'start_at': startAt,
        'end_at': endAt,
        'orders_ids': [for (OrderId id in ordersIds) '$id'],
        'expenses_ids': [for (ExpensesId item in expensesIds) '$item'],
        'statistics': statistics.map,
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': createdAt,
      };

  Future save() async {
    await statistics.calculate(this);
    await collection.document('$id').set(map);
  }

  Future delete() async {
    List<OrderModel> orders = await this.orders;
    for (OrderModel order in orders) {
      await order.delete();
    }
    List<ExpensesModel> expenses = await this.expenses;
    for (ExpensesModel expenses in expenses) {
      await expenses.delete();
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'TripModel(${jsonEncode(map)})';
}

class TripId {
  final TruckId truckId;
  final int id;

  const TripId(this.truckId, this.id);

  static TripId fromString(String str) {
    Exception throw_() => Exception('Invalid Trip Id');

    final split = str.split('-');
    if (split.length < 4) throw throw_();

    int? truckId = int.tryParse(str.split('-')[1]);
    if (truckId == null) throw throw_();

    int? id = int.tryParse(str.split('-')[3]);
    if (id == null) throw throw_();

    return TripId(TruckId(truckId), id);
  }

  static List<TripId> allFromString(List items) => [
        for (String id in items) fromString(id),
      ];

  @override
  bool operator ==(Object other) => other is TripId && other.id == id;

  @override
  String toString() => '$truckId-tr-$id';
}

class TripStatistics {
  double totalOrdersCost;
  double totalOrdersPaid;
  double totalOrdersPayloadsCost;
  double totalOrdersPayloadsPaid;
  double totalOrdersMiniPayloadsCost;
  double totalOrdersMiniPayloadsPaid;
  double totalExpensesCost;
  double totalTruckExpensesCost;

  TripStatistics(
    this.totalOrdersCost,
    this.totalOrdersPaid,
    this.totalOrdersPayloadsCost,
    this.totalOrdersPayloadsPaid,
    this.totalOrdersMiniPayloadsCost,
    this.totalOrdersMiniPayloadsPaid,
    this.totalExpensesCost,
    this.totalTruckExpensesCost,
  );

  double get totalOrdersDebt => totalOrdersCost - totalOrdersPaid;
  double get totalOrdersPayloadsDebt =>
      totalOrdersPayloadsCost - totalOrdersPayloadsPaid;
  double get totalOrdersMiniPayloadsDebt =>
      totalOrdersMiniPayloadsCost - totalOrdersMiniPayloadsPaid;

  static TripStatistics get empty => TripStatistics(0, 0, 0, 0, 0, 0, 0, 0);

  static TripStatistics fromMap(Map data) => TripStatistics(
        double.tryParse(data['total_orders_cost'].toString()) ?? 0,
        double.tryParse(data['total_orders_paid'].toString()) ?? 0,
        double.tryParse(data['total_orders_payloads_cost'].toString()) ?? 0,
        double.tryParse(data['total_orders_payloads_paid'].toString()) ?? 0,
        double.tryParse(data['total_orders_mini_payloads_cost'].toString()) ??
            0,
        double.tryParse(data['total_orders_mini_payloads_paid'].toString()) ??
            0,
        double.tryParse(data['total_expenses_cost'].toString()) ?? 0,
        double.tryParse(data['total_truck_expenses_cost'].toString()) ?? 0,
      );

  Future calculate(TripModel trip) async {
    List<OrderModel> orders = await trip.orders;
    totalOrdersCost = 0;
    totalOrdersPaid = 0;
    totalOrdersPayloadsCost = 0;
    totalOrdersPayloadsPaid = 0;
    totalOrdersMiniPayloadsCost = 0;
    totalOrdersMiniPayloadsPaid = 0;
    for (OrderModel order in orders) {
      totalOrdersCost += order.totalCost;
      totalOrdersPaid += order.totalPaid;
      totalOrdersPayloadsCost += order.totalMiniPayloadsCost;
      totalOrdersPayloadsPaid += order.totalMiniPayloadsPaid;
      totalOrdersMiniPayloadsCost += order.totalMiniPayloadsCost;
      totalOrdersMiniPayloadsPaid += order.totalMiniPayloadsPaid;
    }
    List<ExpensesModel> expenses = await trip.expenses;
    totalExpensesCost = 0;
    totalTruckExpensesCost = 0;
    for (ExpensesModel expenses in expenses) {
      totalExpensesCost += expenses.cost;
      if (expenses.isTruckExpenses) totalTruckExpensesCost += expenses.cost;
    }
  }

  Map<String, dynamic> get map => {
        'total_orders_cost': totalOrdersCost,
        'total_orders_paid': totalOrdersPaid,
        'total_orders_payloads_cost': totalOrdersPayloadsCost,
        'total_orders_payloads_paid': totalOrdersPayloadsPaid,
        'total_orders_mini_payloads_cost': totalOrdersMiniPayloadsCost,
        'total_orders_mini_payloads_paid': totalOrdersMiniPayloadsPaid,
        'total_expenses_cost': totalExpensesCost,
        'total_truck_expenses_cost': totalTruckExpensesCost,
      };
}
