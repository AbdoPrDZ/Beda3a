import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class CreateEditDriverController extends GetxController {
  MainService mainService = Get.find();

  CreateEditDriverData pageData = Get.arguments ?? const CreateEditDriverData();

  final formKey = GlobalKey<FormState>();
  Map<String, String> errors = {};

  DriverModel? oldDriver;

  final firstNameController = TextEditController(name: 'driver_first_name');
  final lastNameController = TextEditController(name: 'driver_last_name');
  final phoneController = TextEditController(name: 'driver_phone');
  final emailController = TextEditController(name: 'driver_email');
  final addressController = TextEditController(name: 'driver_address');
  String gander = 'male';
  Map<String, String> details = {};

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      DriverModel.fromId(pageData.driverId!).then((driver) {
        oldDriver = driver;
        firstNameController.text = oldDriver!.firstName;
        lastNameController.text = oldDriver!.lastName;
        phoneController.text = oldDriver!.phone;
        emailController.text = oldDriver!.email ?? '';
        addressController.text = oldDriver!.address ?? '';
        gander = oldDriver!.gander;
        update();
      });
    }
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await DriverModel.create(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        address: getFieldData(addressController),
        gander: gander,
        details: details,
      );
      if (result.success) {
        Get.back();
        await DialogsView.message(
          'Create Driver',
          'Successfully creating driver',
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

class CreateEditDriverData extends CreateEditPageData {
  final DriverId? driverId;
  const CreateEditDriverData({super.action, super.data, this.driverId})
      : assert(
          !(action == CreateEditPageAction.edit && driverId == null),
          'Driver id is required when action is edit',
        );
}
