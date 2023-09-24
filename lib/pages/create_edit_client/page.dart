import 'package:get/get.dart';

import '../../src/ui_theme.dart';
import '../../utils/utils.dart' as utils;
import '../../utils/utils.dart';
import '../../views/views.dart';
import 'controller.dart';

class CreateEditClientPage extends utils.Page<CreateEditClientController> {
  CreateEditClientPage({Key? key})
      : super(controller: CreateEditClientController(), key: key);

  @override
  CreateEditClientController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: const Text('CreateEditClient'),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '${controller.pageData.action} Client',
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
                DetailsView(
                  details: controller.details,
                  sessionsName: 'client-${controller.pageData.action}',
                  onAdd: (name, value) {
                    controller.details[name] = value;
                    controller.update();
                    return controller.details;
                  },
                  onRemove: (name) {
                    controller.details.remove(name);
                    controller.update();
                    return controller.details;
                  },
                ),
                if (controller.pageData.action.isEdit) ...[
                  ButtonView.text(
                    backgroundColor: UIColors.warning,
                    onPressed: controller.edit,
                    text: 'Edit',
                  ),
                  ButtonView.text(
                    backgroundColor: UIThemeColors.danger,
                    onPressed: controller.delete,
                    text: 'Delete',
                  ),
                ] else
                  ButtonView.text(
                    onPressed: controller.create,
                    text: 'Create',
                  )
              ],
            ),
          ),
        ),
      );
}
