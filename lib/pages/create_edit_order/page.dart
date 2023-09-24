import '../../models/models.dart';
import '../../utils/utils.dart' as utils;
import '../../utils/utils.dart';
import '../../views/views.dart';
import 'controller.dart';

class CreateEditOrderPage extends utils.Page<CreateEditOrderController> {
  CreateEditOrderPage({Key? key})
      : super(controller: CreateEditOrderController(), key: key);

  @override
  CreateEditOrderController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: const Text('CreateEditOrder'),
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
                    '${controller.pageData.action} Order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ),
                DropDownView<ClientId?>(
                  value: controller.fromClientId,
                  items: [
                    for (ClientModel client in controller.clients)
                      DropdownMenuItem(
                        value: client.id,
                        child: Text(client.fullName),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null && value != controller.fromClientId) {
                      controller.fromClientId = value;
                      controller.update();
                    }
                  },
                ),
                DropDownView<ClientId?>(
                  value: controller.toClientId,
                  items: [
                    for (ClientModel client in controller.clients)
                      DropdownMenuItem(
                        value: client.id,
                        child: Text(client.fullName),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null && value != controller.toClientId) {
                      controller.toClientId = value;
                      controller.update();
                    }
                  },
                ),
                DetailsView(
                  details: controller.details,
                  sessionsName: 'order-${controller.pageData.action}',
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
