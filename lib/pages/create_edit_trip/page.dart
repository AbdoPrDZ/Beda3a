import 'package:gap/gap.dart';

import '../../utils/utils.dart' as utils;
import '../../utils/utils.dart';
import '../../views/views.dart';
import 'controller.dart';

class CreateEditTripPage extends utils.Page<CreateEditTripController> {
  CreateEditTripPage({Key? key})
      : super(controller: CreateEditTripController(), key: key);

  @override
  CreateEditTripController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text('${controller.pageData!.action} Trip'),
      );

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                    '${controller.pageData!.action} Trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.fromController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "From destination is required";
                    }
                    return null;
                  },
                  label: 'From',
                ),
                TextEditView(
                  controller: controller.toController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "To destination is required";
                    }
                    return null;
                  },
                  label: 'To',
                ),
                TextEditView(
                  controller: controller.distanceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Trip distance is required";
                    }
                    return null;
                  },
                  label: 'Distance',
                ),
                TextEditView(
                  controller: controller.startAtController,
                  validator: (value) {
                    if (value != null || MDateTime.fromString(value!) == null) {
                      return "Invalid datetime";
                    }
                    return null;
                  },
                  label: 'Start at',
                ),
                TextEditView(
                  controller: controller.endAtController,
                  validator: (value) {
                    if (value != null || MDateTime.fromString(value!) == null) {
                      return "Invalid datetime";
                    }
                    return null;
                  },
                  label: 'End at',
                ),
                OrdersView(
                  orders: controller.orders,
                  addOrder: () {
                    RouteManager.to(PagesInfo.createEditOrder);
                  },
                ),
                DetailsView(
                  details: controller.details,
                  sessionsName: 'trip-${controller.pageData!.action}',
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
                const Gap(15),
                if (controller.pageData!.action.isEdit) ...[
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
