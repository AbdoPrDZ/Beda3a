import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class OrderModel {
  final OrderId id;
  ClientId fromClientId, toClientId;
  List<OrderPayload> payloads;
  List<OrderMiniPayload> miniPayloads;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  OrderModel(
    this.id,
    this.fromClientId,
    this.toClientId,
    this.payloads,
    this.miniPayloads,
    this.details,
    this.images,
    this.createdAt,
  );

  ClientModel? fromClient_, toClient_;

  Future<ClientModel> get fromClient async =>
      (await ClientModel.fromId(fromClientId))!;

  Future<ClientModel> get toClient async =>
      (await ClientModel.fromId(toClientId))!;

  double get totalCost =>
      payloads.fold<double>(
          0, (value, payload) => value + payload.generalPrice) +
      miniPayloads.fold<double>(0, (value, payload) => value + payload.cost);
  double get totalPaid =>
      payloads.fold<double>(0, (value, payload) => value + payload.paid) +
      miniPayloads.fold<double>(0, (value, payload) => value + payload.paid);
  double get totalDebt =>
      payloads.fold<double>(0, (value, payload) => value + payload.debt) +
      miniPayloads.fold<double>(0, (value, payload) => value + payload.debt);

  double get totalPayloadsCost => payloads.fold<double>(
      0, (value, payload) => value + payload.generalPrice);
  double get totalPayloadsPaid =>
      payloads.fold<double>(0, (value, payload) => value + payload.paid);
  double get totalPayloadsDebt =>
      payloads.fold<double>(0, (value, payload) => value + payload.debt);

  double get totalMiniPayloadsCost => totalCost - totalPayloadsCost;
  double get totalMiniPayloadsPaid => totalPaid - totalPayloadsPaid;
  double get totalMiniPayloadsDebt => totalDebt - totalPayloadsDebt;

  double get totalSenderCost => payloads.fold<double>(
      0,
      (value, payload) =>
          value + (payload.whoPayIt.isSender ? payload.generalPrice : 0));
  double get totalReceiverCost => payloads.fold<double>(
      0,
      (value, payload) =>
          value + (payload.whoPayIt.isReceiver ? payload.generalPrice : 0));

  double get totalSenderPaid => payloads.fold<double>(
      0,
      (value, payload) =>
          value + (payload.whoPayIt.isSender ? payload.paid : 0));
  double get totalReceiverPaid => payloads.fold<double>(
      0,
      (value, payload) =>
          value + (payload.whoPayIt.isReceiver ? payload.paid : 0));

  double get totalSenderDebt => totalSenderCost - totalSenderPaid;
  double get totalReceiverDebt => totalReceiverCost - totalReceiverPaid;

  double getClientCost(ClientId clientId) => clientId == fromClientId
      ? totalSenderCost
      : clientId == toClientId
          ? totalReceiverCost
          : 0;
  double getClientPaid(ClientId clientId) => clientId == fromClientId
      ? totalSenderPaid
      : clientId == toClientId
          ? totalReceiverPaid
          : 0;
  double getClientDebt(ClientId clientId) => clientId == fromClientId
      ? totalSenderDebt
      : clientId == toClientId
          ? totalReceiverDebt
          : 0;

  Future loadAll() async {
    fromClient_ = await fromClient;
    toClient_ = await toClient;
  }

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('orders');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('orders');

  static Future init() => collection.set({});

  static OrderModel fromMap(Map data) {
    OrderId id = OrderId.fromString(data['id']);
    return OrderModel(
      id,
      ClientId.fromString(data['from_client_id']),
      ClientId.fromString(data['to_client_id']),
      OrderPayload.allFromList(List<Map>.from(data['payloads'])),
      OrderMiniPayload.allFromList(List<Map>.from(data['mini_payloads'])),
      Map<String, String>.from(data['details']),
      [for (String file in data['images']) directory.file('$id/$file')],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static List<OrderModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<OrderModel>> all() async =>
      allFromMap(await collection.get());

  static Future<OrderModel?> fromId(OrderId id) async {
    if (!await collection.hasDocumentId('$id')) return null;
    Map? data = await collection.document('$id').get();
    return data != null ? fromMap(data) : null;
  }

  static Future<List<OrderModel>> allFromId(List<OrderId> ids) async => [
        for (OrderId id in ids) (await fromId(id))!,
      ];

  static Future<OrderId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + OrderId.fromString(item).id);
    return OrderId(lastId + 1);
  }

  static Future<CreateEditModelResult<OrderModel>> create({
    required ClientId fromClientId,
    required ClientId toClientId,
    List<OrderPayload> payloads = const [],
    List<OrderMiniPayload> miniPayloads = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    OrderModel order = OrderModel(
      await nextId(),
      fromClientId,
      toClientId,
      payloads,
      miniPayloads,
      details,
      images,
      MDateTime.now(),
    );
    await order.save();

    return CreateEditModelResult<OrderModel>(true, model: order);
  }

  Future<CreateEditModelResult<OrderModel>> edit({
    ClientId? fromClientId,
    ClientId? toClientId,
    List<OrderPayload>? payloads,
    List<OrderMiniPayload>? miniPayloads,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    this.fromClientId = fromClientId ?? this.fromClientId;
    this.toClientId = toClientId ?? this.toClientId;
    this.payloads = payloads ?? this.payloads;
    this.miniPayloads = miniPayloads ?? this.miniPayloads;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<OrderModel>(true, model: this);
  }

  static List<OrderModel> allFromList(List items) =>
      [for (Map data in items) fromMap(data)];

  Map<String, dynamic> get map => {
        'id': '$id',
        'from_client_id': '$fromClientId',
        'to_client_id': '$toClientId',
        'payloads': [for (OrderPayload payload in payloads) payload.map],
        'mini_payloads': [
          for (OrderMiniPayload payload in miniPayloads) payload.map
        ],
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': createdAt,
      };

  Future save() => collection.document('$id').set(map);

  Future delete() async {
    ClientModel fromClient = await this.fromClient;
    fromClient.sendedOrdersIds.removeWhere((id) => id == this.id);

    ClientModel toClient = await this.toClient;
    toClient.receivedOrdersIds.removeWhere((id) => id == this.id);

    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'OrderModel(${jsonEncode(map)})';
}

class OrderId {
  final int id;

  const OrderId(this.id);

  static OrderId fromString(String str) {
    Exception throw_() => Exception('Invalid Order Id');

    if (!str.startsWith('c-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return OrderId(id);
  }

  static List<OrderId> allFromString(List items) => [
        for (String id in items) fromString(id),
      ];

  @override
  bool operator ==(Object other) => other is OrderId && other.id == id;

  @override
  String toString() => 'o-$id';
}

class OrderPayload {
  PayloadId payloadId;
  double value, price, totalPrice, cost, totalCost, paid, generalPrice;
  int count;
  MDateTime? chargingDate, disChargingDate;
  String? selectedAddress, chargingAddress, disChargingAddress;
  PricingType pricingType, costingType;
  GeneralPricingType generalPricingType;
  WhoPayIt whoPayIt;

  OrderPayload(
    this.payloadId,
    this.value,
    this.count,
    this.price,
    this.totalPrice,
    this.cost,
    this.totalCost,
    this.generalPrice,
    this.paid,
    this.selectedAddress,
    this.chargingDate,
    this.chargingAddress,
    this.disChargingDate,
    this.disChargingAddress,
    this.pricingType,
    this.costingType,
    this.generalPricingType,
    this.whoPayIt,
  );

  double get debt => generalPrice - paid;

  static OrderPayload fromMap(Map data) => OrderPayload(
      PayloadId.fromString(data['payload_id']),
      double.tryParse(data['value'].toString()) ?? 0,
      data['count'],
      double.tryParse(data['price'].toString()) ?? 0,
      double.tryParse(data['total_price'].toString()) ?? 0,
      double.tryParse(data['cost'].toString()) ?? 0,
      double.tryParse(data['total_cost'].toString()) ?? 0,
      double.tryParse(data['general_price'].toString()) ?? 0,
      double.tryParse(data['paid'].toString()) ?? 0,
      data['selected_address'],
      data['charging_date']
          ? MDateTime.fromString(data['charging_date'])
          : null,
      data['charging_address'],
      data['disCharging_date']
          ? MDateTime.fromString(data['disCharging_date'])
          : null,
      data['disCharging_address'],
      PricingType.fromString(data['pricing_type']),
      PricingType.fromString(data['costing_type']),
      GeneralPricingType.fromString(data['general_pricing_type']),
      WhoPayIt.fromString(data['who_pay_it']));

  static List<OrderPayload> allFromList(List<Map> items) => [
        for (Map data in items) fromMap(data),
      ];

  Map<String, dynamic> get map => {
        'payload_id': '$payloadId',
        'value': value,
        'count': count,
        'price': price,
        'total_price': totalPrice,
        'cost': cost,
        'total_cost': totalCost,
        'general_price': generalPrice,
        'paid': paid,
        'selected_address': selectedAddress,
        'charging_date': chargingDate != null ? '$chargingDate' : null,
        'charging_address': '$chargingAddress',
        'discharging_date': disChargingDate != null ? '$disChargingDate' : null,
        'discharging_address': '$disChargingAddress',
        'pricing_type': '$pricingType',
        'costing_type': '$costingType',
        'general_pricing_type': '$generalPricingType',
        'who_pay_it': '$whoPayIt',
      };

  @override
  String toString() => 'OrderPayload(${jsonEncode(map)})';
}

enum PricingType {
  value,
  count;

  bool get isValue => this == value;
  bool get isCount => this == count;

  static PricingType fromString(String type) =>
      '$value' == type ? value : count;

  @override
  String toString() => this == value ? 'Value' : 'Count';
}

enum GeneralPricingType {
  onlyCost,
  withPrice;

  bool get isOnlyCost => this == onlyCost;
  bool get isWithPrice => this == withPrice;

  static GeneralPricingType fromString(String type) =>
      '$onlyCost' == type ? onlyCost : withPrice;

  @override
  String toString() => this == onlyCost ? 'Only cost' : 'With price';
}

enum WhoPayIt {
  sender,
  receiver;

  bool get isSender => this == sender;
  bool get isReceiver => this == receiver;

  static WhoPayIt fromString(String type) =>
      '$sender' == type ? sender : receiver;

  @override
  String toString() => this == sender ? 'Sender' : 'Receiver';
}

class OrderMiniPayload {
  String name;
  double cost, paid;
  MDateTime? chargingDate, dischargingDate;
  String? chargingAddress, dischargingAddress;
  Map<String, String> details;
  final MDateTime createdAt;

  OrderMiniPayload(
    this.name,
    this.cost,
    this.paid,
    this.chargingDate,
    this.chargingAddress,
    this.dischargingDate,
    this.dischargingAddress,
    this.details,
    this.createdAt,
  );

  double get debt => cost - paid;

  static OrderMiniPayload fromMap(Map data) => OrderMiniPayload(
        data['name'],
        double.tryParse(data['cost'].toString()) ?? 0,
        double.tryParse(data['paid'].toString()) ?? 0,
        data['charging_date']
            ? MDateTime.fromString(data['charging_date'])
            : null,
        data['charging_address'],
        data['disCharging_date']
            ? MDateTime.fromString(data['disCharging_date'])
            : null,
        data['discharging_address'],
        Map<String, String>.from(data['details']),
        MDateTime.fromString(data['created_at'])!,
      );

  static List<OrderMiniPayload> allFromList(List<Map> items) => [
        for (Map data in items) fromMap(data),
      ];

  Map<String, dynamic> get map => {
        'name': name,
        'cost': cost,
        'paid': paid,
        'charging_date': chargingDate != null ? '$chargingDate' : null,
        'charging_address': '$chargingAddress',
        'discharging_date': dischargingDate != null ? '$dischargingDate' : null,
        'discharging_address': '$dischargingAddress',
        'details': details,
      };

  @override
  String toString() => 'OrderPayload(${jsonEncode(map)})';
}
