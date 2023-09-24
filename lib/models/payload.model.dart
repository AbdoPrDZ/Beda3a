import 'package:beda3a/models/models.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';

class PayloadModel {
  final PayloadId id;
  String name, category;
  List<PayloadAddress> addresses;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  PayloadModel(
    this.id,
    this.name,
    this.category,
    this.addresses,
    this.details,
    this.images,
    this.createdAt,
  );

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('payloads');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('payloads');

  static Future init() => collection.set({});

  static PayloadModel fromMap(Map data) {
    PayloadId id = PayloadId.fromString(data['id']);
    return PayloadModel(
      id,
      data['name'],
      data['category'],
      PayloadAddress.allFromList(List<Map>.from(data['address'])),
      Map<String, String>.from(data['details']),
      [
        for (String file in data['images']) directory.file('$id/$file'),
      ],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<PayloadId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + PayloadId.fromString(item).id);
    return PayloadId(lastId + 1);
  }

  static Future<CreateEditModelResult<PayloadModel>> create({
    required String name,
    required String category,
    List<PayloadAddress> addresses = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    List<PayloadModel> payloads = await all();

    for (PayloadModel payload in payloads) {
      if (payload.name.trim() == name.trim()) {
        return const CreateEditModelResult<PayloadModel>(
          false,
          message: 'Payload name already used',
          fieldError: 'name',
        );
      }
    }

    PayloadModel payload = PayloadModel(
      await nextId(),
      name,
      category,
      addresses,
      details,
      images,
      MDateTime.now(),
    );
    await payload.save();

    return CreateEditModelResult<PayloadModel>(true, model: payload);
  }

  Future<CreateEditModelResult<PayloadModel>> edit({
    String? name,
    String? category,
    List<PayloadAddress>? addresses,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    List<PayloadModel> payloads = await all();

    for (PayloadModel payload in payloads) {
      if (payload.id == id) continue;
      if (name != null && payload.name.trim() == name.trim()) {
        return const CreateEditModelResult<PayloadModel>(
          false,
          message: 'Payload name already used',
          fieldError: 'name',
        );
      }
    }

    this.name = name ?? this.name;
    this.category = category ?? this.category;
    this.addresses = addresses ?? this.addresses;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<PayloadModel>(true, model: this);
  }

  static Future<PayloadModel?> fromId(PayloadId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static List<PayloadModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<PayloadModel>> all() async =>
      allFromMap(await collection.get());

  static Stream<List<PayloadModel>> stream() =>
      collection.stream().asyncExpand<List<PayloadModel>>(
        (items) async* {
          if (items != null && (items as Map).isNotEmpty) {
            yield allFromMap(items);
          }
        },
      );

  Map<String, dynamic> get map => {
        'id': '$id',
        'name': name,
        'category': category,
        'addresses': addresses,
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createdAt',
      };

  Future save() => collection.document('$id').set(map);

  Future delete() async {
    List<OrderModel> orders = await OrderModel.all();
    for (OrderModel order in orders) {
      order.payloads.removeWhere(
        (orderPayload) => orderPayload.payloadId == id,
      );
      await order.save();
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'PayloadModel(${jsonEncode(map)})';
}

class PayloadAddress {
  final String address;
  final double price, cost;

  const PayloadAddress(this.address, this.price, this.cost);

  static PayloadAddress fromMap(Map data) => PayloadAddress(
        data['address'],
        data['price'],
        data['cost'],
      );

  static List<PayloadAddress> allFromList(List<Map> items) => [
        for (Map data in items) fromMap(data),
      ];
}

class PayloadId {
  final int id;

  const PayloadId(this.id);

  static PayloadId fromString(String str) {
    Exception throw_() => Exception('Invalid Payload Id');

    if (!str.startsWith('p-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return PayloadId(id);
  }

  @override
  bool operator ==(Object other) => other is PayloadId && other.id == id;

  @override
  String toString() => 'c-$id';
}
