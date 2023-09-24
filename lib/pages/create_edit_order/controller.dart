import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class CreateEditOrderController extends GetxController {
  MainService mainService = Get.find();

  CreateEditOrderData pageData = Get.arguments ?? const CreateEditOrderData();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  List<ClientModel> clients = [];
  ClientId? fromClientId, toClientId;

  Map<String, String> details = {};

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await OrderModel.create(
        fromClientId: fromClientId!,
        toClientId: toClientId!,
        details: details,
      );
      if (result.success) {
        Get.back();
        await DialogsView.message(
          'Create Order',
          'Successfully creating order',
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

class CreateEditOrderData extends CreateEditPageData {
  const CreateEditOrderData({super.action, super.data});
}
