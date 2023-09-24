import 'package:get/get.dart';

import '../../models/models.dart';
import '../../services/main.service.dart';
import '../../utils/utils.dart';
import '../../views/views.dart';

class SetupUserController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  final firstNameController = TextEditController(name: 'first_name');
  final lastNameController = TextEditController(name: 'last_name');
  final emailController = TextEditController(name: 'email');
  final phoneController = TextEditController(name: 'phone');
  final companyController = TextEditController(name: 'company');
  final addressController = TextEditController(name: 'address');
  final passwordController = TextEditController();
  final confirmController = TextEditController();

  String gander = 'male';

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  register() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      UserModel user = UserModel(
        getFieldData(firstNameController)!,
        getFieldData(lastNameController)!,
        getFieldData(phoneController)!,
        getFieldData(emailController),
        getFieldData(companyController),
        getFieldData(addressController),
        gander,
        //  Password.hash(passwordController.text, PBKDF2()),
        passwordController.text,
        true,
        [],
        MDateTime.now(),
      );

      try {
        mainService.realUser = await UserModel.setup(user);
        formKey.currentState!.save();

        Get.back();
        await DialogsView.message(
          'Register',
          'User created successfully',
        ).show();
        RouteManager.to(PagesInfo.home, clearHeaders: true);
      } catch (e) {
        Get.back();
        await DialogsView.message('Register', '$e').show();
      }
    }
  }
}
