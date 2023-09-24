import 'package:get/get.dart';

import '../../src/src.dart';
import '../../utils/utils.dart' as utils;
import '../../views/views.dart';
import 'controller.dart';

class SetupUserPage extends utils.Page<SetupUserController> {
  SetupUserPage({Key? key})
      : super(controller: SetupUserController(), key: key);

  @override
  SetupUserController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: const Text('Setup User'),
      );

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: controller.formKey,
            onChanged: () {
              if (controller.errors.isNotEmpty) controller.errors = {};
            },
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Setup User',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "First name is required";
                    }
                    return null;
                  },
                  hint: 'First name',
                ),
                TextEditView(
                  controller: controller.lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Last name is required";
                    }
                    return null;
                  },
                  hint: 'Last name',
                ),
                TextEditView(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone is required";
                    } else if (!value.isPhoneNumber) {
                      return "Please enter valid phone (+213000 00 00 00*)";
                    }
                    return null;
                  },
                  hint: 'Phone',
                ),
                TextEditView(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.isEmail) {
                      return "Please enter valid email (example@mail.com)";
                    }
                    return null;
                  },
                  hint: 'Email',
                ),
                TextEditView(
                  controller: controller.companyController,
                  hint: 'Company Name',
                ),
                TextEditView(
                  controller: controller.addressController,
                  keyboardType: TextInputType.streetAddress,
                  hint: 'Address',
                ),
                DropDownView(
                  value: controller.gander,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    if (value != null && value != controller.gander) {
                      controller.gander = value;
                      controller.update();
                    }
                  },
                ),
                TextEditView(
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  hint: 'Password',
                ),
                TextEditView(
                  controller: controller.confirmController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm is required";
                    } else if (controller.passwordController.text.isNotEmpty &&
                        controller.passwordController.text != value) {
                      return "Password and confirm must be equals";
                    }
                    return null;
                  },
                  hint: 'Confirm',
                ),
                ButtonView.text(
                    onPressed: controller.register, text: 'Register')
              ],
            ),
          ),
        ),
      );
}
