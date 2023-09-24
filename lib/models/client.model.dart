import 'package:get/get.dart';
import 'package:storage_database/storage_collection.dart';
import 'package:storage_database/storage_database.dart';

import '../services/main.service.dart';
import '../utils/utils.dart';
import 'models.dart';

class ClientModel {
  final ClientId id;
  String firstName, lastName, phone, gander;
  String? email, company, address;
  List<OrderId> sendedOrdersIds, receivedOrdersIds;
  ClientStatistics statistics;
  Map<String, String> details;
  List<ExplorerFile> images;
  final MDateTime createdAt;

  ClientModel(
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.company,
    this.address,
    this.gander,
    this.sendedOrdersIds,
    this.receivedOrdersIds,
    this.statistics,
    this.details,
    this.images,
    this.createdAt,
  );

  String get fullName => '$firstName $lastName';

  Future<List<OrderModel>> get sendedOrders =>
      OrderModel.allFromId(sendedOrdersIds);
  Future<List<OrderModel>> get receivedOrders =>
      OrderModel.allFromId(receivedOrdersIds);

  Future<List<OrderModel>> get orders async => [
        ...(await sendedOrders),
        ...(await receivedOrders),
      ];

  static StorageCollection get collection =>
      Get.find<MainService>().dataDatabase.collection('clients');

  static ExplorerDirectory get directory =>
      Get.find<MainService>().dataDatabase.explorer!.directory('clients');

  static Future init() => collection.set({});

  static ClientModel fromMap(Map data) {
    ClientId id = ClientId.fromString(data['id']);
    return ClientModel(
      id,
      data['first_name'],
      data['last_name'],
      data['phone'],
      data['email'],
      data['company'],
      data['address'],
      data['gander'],
      OrderId.allFromString(data['sended_orders_ids']),
      OrderId.allFromString(data['received_orders_ids']),
      ClientStatistics.fromMap(data['statistics']),
      Map<String, String>.from(data['details']),
      [for (String file in data['images']) directory.file('$id/$file')],
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static Future<ClientId> nextId() async {
    Map items = await collection.get();
    int lastId = items.keys
        .fold(0, (value, item) => value + ClientId.fromString(item).id);
    return ClientId(lastId + 1);
  }

  static Future<CreateEditModelResult<ClientModel>> create({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? company,
    String? address,
    String gander = 'male',
    List<OrderId> sendedOrdersIds = const [],
    List<OrderId> receivedOrdersIds = const [],
    Map<String, String> details = const {},
    List<ExplorerFile> images = const [],
  }) async {
    List<ClientModel> clients = await all();

    for (ClientModel client in clients) {
      if (client.firstName.trim() == firstName.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'First name already used',
          fieldError: 'first_name',
        );
      } else if (client.lastName.trim() == lastName.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Last name already used',
          fieldError: 'last_name',
        );
      } else if (client.phone.trim() == phone.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Phone already used',
          fieldError: 'phone',
        );
      } else if ((client.email != null && email != null) &&
          client.email!.trim() == email.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Email already used',
          fieldError: 'email',
        );
      } else if ((client.company != null && company != null) &&
          client.company!.trim() == company.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Company already used',
          fieldError: 'company',
        );
      } else if ((client.address != null && address != null) &&
          client.address!.trim() == address.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Address already used',
          fieldError: 'address',
        );
      }
    }

    ClientModel client = ClientModel(
      await nextId(),
      firstName,
      lastName,
      phone,
      email,
      company,
      address,
      gander,
      sendedOrdersIds,
      receivedOrdersIds,
      ClientStatistics.empty,
      details,
      images,
      MDateTime.now(),
    );
    await client.save();

    return CreateEditModelResult<ClientModel>(true, model: client);
  }

  static Future<ClientModel?> fromId(ClientId id) async {
    Map? data = await collection.hasDocumentId('$id')
        ? await collection.document('$id').get()
        : null;
    if (data != null) return fromMap(data);
    return null;
  }

  static List<ClientModel> allFromMap(Map items) =>
      [for (String id in items.keys) fromMap(items[id])];

  static Future<List<ClientModel>> all() async =>
      allFromMap(await collection.get());

  static Stream<List<ClientModel>> stream() =>
      collection.stream().asyncExpand<List<ClientModel>>(
        (items) async* {
          if (items != null && (items as Map).isNotEmpty) {
            yield allFromMap(items);
          }
        },
      );

  Future<CreateEditModelResult<ClientModel>> edit({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? company,
    String? address,
    String? gander,
    List<OrderId>? sendedOrdersIds,
    List<OrderId>? receivedOrdersIds,
    Map<String, String>? details,
    List<ExplorerFile>? images,
  }) async {
    List<ClientModel> clients = await all();

    for (ClientModel client in clients) {
      if (client.id == id) continue;
      if (firstName != null && client.firstName.trim() == firstName.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'First name already used',
          fieldError: 'first_name',
        );
      } else if (lastName != null &&
          client.lastName.trim() == lastName.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Last name already used',
          fieldError: 'last_name',
        );
      } else if (phone != null && client.phone.trim() == phone.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Phone already used',
          fieldError: 'phone',
        );
      } else if ((client.email != null && email != null) &&
          client.email!.trim() == email.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Email already used',
          fieldError: 'email',
        );
      } else if ((client.company != null && company != null) &&
          client.company!.trim() == company.trim()) {
        return const CreateEditModelResult<ClientModel>(
          false,
          message: 'Company already used',
          fieldError: 'company',
        );
      }
    }
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.phone = phone ?? this.phone;
    this.email = email;
    this.company = company;
    this.company = address;
    this.gander = gander ?? this.gander;
    this.sendedOrdersIds = sendedOrdersIds ?? this.sendedOrdersIds;
    this.receivedOrdersIds = receivedOrdersIds ?? this.receivedOrdersIds;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    await save();

    return CreateEditModelResult<ClientModel>(true, model: this);
  }

  Map<String, dynamic> get map => {
        'id': '$id',
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'company': company,
        'address': address,
        'gander': gander,
        'sended_orders_ids': [for (OrderId id in sendedOrdersIds) '$id'],
        'received_orders_ids': [for (OrderId id in receivedOrdersIds) '$id'],
        'statistics': statistics.map,
        'details': details,
        'images': [for (ExplorerFile file in images) file.filename],
        'created_at': '$createdAt',
      };

  Future save() async {
    await statistics.calculate(this);
    return await collection.document('$id').set(map);
  }

  Future delete() async {
    List<OrderModel> sendedOrders = await this.sendedOrders;
    for (OrderModel order in sendedOrders) {
      await order.delete();
    }
    List<OrderModel> receivedOrders = await this.receivedOrders;
    for (OrderModel order in receivedOrders) {
      await order.delete();
    }
    await collection.deleteItem('$id');
  }

  @override
  String toString() => 'ClientModel(${jsonEncode(map)})';
}

class ClientId {
  final int id;

  const ClientId(this.id);

  static ClientId fromString(String str) {
    Exception throw_() => Exception('Invalid Client Id');

    if (!str.startsWith('c-')) throw throw_();
    int? id = int.tryParse(str.split('-')[1]);
    if (id == null) throw throw_();

    return ClientId(id);
  }

  @override
  bool operator ==(Object other) => other is ClientId && other.id == id;

  @override
  String toString() => 'c-$id';
}

class ClientStatistics {
  List<Price<OrderId>> ordersCosts;
  List<Price<OrderId>> ordersDebts;
  double totalExchanges, totalDebt;

  ClientStatistics(
    this.ordersCosts,
    this.totalExchanges,
    this.ordersDebts,
    this.totalDebt,
  );

  static ClientStatistics get empty => ClientStatistics([], 0, [], 0);

  static ClientStatistics fromMap(Map data) => ClientStatistics(
        Price.allFromMap(data['orders_debts'], OrderId.fromString),
        double.tryParse(data['total_exchanges'].toString()) ?? 0,
        Price.allFromMap(data['orders_costs'], OrderId.fromString),
        double.tryParse(data['total_debt'].toString()) ?? 0,
      );

  Future calculate(ClientModel client) async {
    List<OrderModel> orders = await client.orders;

    ordersCosts = [];
    ordersDebts = [];
    totalExchanges = 0;
    totalDebt = 0;
    for (OrderModel order in orders) {
      double cost = order.getClientCost(client.id);
      double debt = order.getClientDebt(client.id);
      if (debt > 0) ordersDebts.add(Price<OrderId>(order.id, debt));
      totalExchanges += cost;
      ordersCosts.add(Price<OrderId>(order.id, cost));
      totalDebt += debt;
    }
  }

  Map<String, dynamic> get map => {
        'orders_costs': [
          for (Price cost in ordersCosts) cost.map,
        ],
        'total_exchange': totalExchanges,
        'orders_debts': [
          for (Price debt in ordersDebts) debt.map,
        ],
        'total_debts': totalDebt,
      };
}

class Price<MID> {
  final MID id;
  final double price;

  const Price(this.id, this.price);

  static Price<MID> fromMap<MID>(Map data, MID Function(String id) idGetter) =>
      Price(
        idGetter(data['id']),
        double.tryParse(data['debt'].toString()) ?? 0,
      );

  static List<Price<MID>> allFromMap<MID>(
    List items,
    MID Function(String id) idGetter,
  ) =>
      [for (Map data in items) fromMap(data, idGetter)];

  Map<String, dynamic> get map => {
        'id': '$id',
        'price': price,
      };
}
