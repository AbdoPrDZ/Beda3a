import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class CreateEditClientController extends GetxController {
  MainService mainService = Get.find();

  CreateEditClientData pageData = Get.arguments ?? const CreateEditClientData();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  final firstNameController = TextEditController(name: 'client_first_name');
  final lastNameController = TextEditController(name: 'client_last_name');
  final phoneController = TextEditController(name: 'client_phone');
  final emailController = TextEditController(name: 'client_email');
  final companyController = TextEditController(name: 'client_company');
  final addressController = TextEditController(name: 'client_address');
  String gander = 'male';
  Map<String, String> details = {};

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await ClientModel.create(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        company: getFieldData(companyController),
        address: getFieldData(addressController),
        gander: gander,
        details: details,
      );
      if (result.success) {
        Get.back();
        await DialogsView.message(
          'Create Client',
          'Successfully creating client',
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

class CreateEditClientData extends CreateEditPageData {
  const CreateEditClientData({super.action, super.data});
}
