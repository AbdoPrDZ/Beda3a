import 'dart:io';

import '../../src/ui_theme.dart';
import '../../utils/utils.dart' as utils;
import '../../views/views.dart';
import 'controller.dart';

class SetupDataSourcePage extends utils.Page<SetupDataSourceController> {
  SetupDataSourcePage({Key? key})
      : super(controller: SetupDataSourceController(), key: key);

  @override
  SetupDataSourceController get controller => super.controller!;

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
                  padding: const EdgeInsets.only(bottom: 20, top: 50),
                  child: Text(
                    'Setup Data Source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                    ),
                  ),
                ),
                FilePickerFieldView<Directory>(
                  pickType: FilePickType.directory,
                  initialValue: controller.sourceDir,
                  onPick: (directory) {
                    controller.sourceDir = directory;

                    controller.checkSourceExistsAlready();
                  },
                  validator: (directory) {
                    if (directory == null) {
                      return 'Data source directory is required';
                    } else if ((directory as Directory).existsSync() == false) {
                      return 'The directory you enter isn\'t exists';
                    }
                    return null;
                  },
                ),
                TextEditView(
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length > 32) {
                      return 'The password must be less then 32 character';
                    }
                    return null;
                  },
                  hint: 'Password',
                ),
                if (!controller.sourceExistsAlready)
                  TextEditView(
                    controller: controller.confirmController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm is required";
                      } else if (controller
                              .passwordController.text.isNotEmpty &&
                          controller.passwordController.text != value) {
                        return "Password and confirm must be equals";
                      }
                      return null;
                    },
                    hint: 'Confirm',
                  ),
                ButtonView.text(onPressed: controller.setup, text: 'Submit')
              ],
            ),
          ),
        ),
      );
}
