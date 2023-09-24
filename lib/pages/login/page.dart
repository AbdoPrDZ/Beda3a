import '../../src/ui_theme.dart';
import '../../utils/utils.dart' as utils;
import '../../views/views.dart';
import 'controller.dart';

class LoginPage extends utils.Page<LoginController> {
  LoginPage({Key? key}) : super(controller: LoginController(), key: key);

  @override
  LoginController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: const Text('Login'),
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
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.emailPhoneController,
                  hint: 'Email or Phone',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email or Phone is required";
                    } else if (controller.errors.containsKey('email_phone')) {
                      return controller.errors['email_phone'];
                    }
                    return null;
                  },
                ),
                TextEditView(
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  hint: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (controller.errors.containsKey('password')) {
                      return controller.errors['password'];
                    }
                    return null;
                  },
                ),
                ButtonView.text(onPressed: controller.login, text: 'Login')
              ],
            ),
          ),
        ),
      );
}
