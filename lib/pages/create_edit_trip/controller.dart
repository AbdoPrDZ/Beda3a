import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class CreateEditTripController extends GetxController {
  MainService mainService = Get.find();

  CreateEditTripData? pageData = Get.arguments;

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  final fromController = TextEditController(name: 'trip_from');
  final toController = TextEditController(name: 'trip_to');
  final distanceController = TextEditController(name: 'trip_distance');
  final startAtController = TextEditController(name: 'trip_start_at');
  final endAtController = TextEditController(name: 'trip_end_at');
  Map<String, String> details = {};
  List<DriverModel> drivers = [];
  DriverId? driverId;

  List<OrderModel> orders = [];

  @override
  void onInit() {
    DriverModel.all().then((items) {
      drivers = items;
      update();
    });
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  MDateTime? getFieldMDateTime(TextEditController controller) =>
      MDateTime.fromString(controller.text);

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await TripModel.create(
        truckId: pageData!.truckId,
        from: getFieldData(fromController)!,
        to: getFieldData(toController)!,
        distance: double.tryParse(distanceController.text),
        startAt: getFieldMDateTime(startAtController),
        endAt: getFieldMDateTime(endAtController),
        details: details,
      );
      if (result.success) {
        Get.back();
        await DialogsView.message(
          'Create Trip',
          'Successfully creating trip',
        ).show();
      } else {
        errors[result.fieldError!] = result.message!;
        formKey.currentState!.validate();
      }
      Get.back();
    }
  }

  void edit() async {}

  void delete() async {}
}

class CreateEditTripData extends CreateEditPageData {
  final TruckId truckId;
  const CreateEditTripData({required this.truckId, super.action, super.data});
}
