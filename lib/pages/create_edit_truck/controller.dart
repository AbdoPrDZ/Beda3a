import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class CreateEditTruckController extends GetxController {
  MainService mainService = Get.find();

  CreateEditTruckData pageData = Get.arguments ?? const CreateEditTruckData();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  final nameController = TextEditController(name: 'truck_name');
  Map<String, String> details = {};
  List<DriverModel> drivers = [];
  DriverId? driverId;

  Future getDrovers() async {
    drivers = await DriverModel.all();
    update();
  }

  @override
  void onInit() {
    getDrovers();
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await TruckModel.create(
        name: getFieldData(nameController)!,
        currentDriverId: driverId,
        details: details,
      );
      if (result.success) {
        Get.back();
        await DialogsView.message(
          'Create Truck',
          'Successfully creating truck',
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

class CreateEditTruckData extends CreateEditPageData {
  const CreateEditTruckData({super.action, super.data});
}
