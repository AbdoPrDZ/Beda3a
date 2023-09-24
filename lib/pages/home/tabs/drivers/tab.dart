import '../../../../models/models.dart';
import '../../../../utils/utils.dart' as utils;
import '../../../../src/src.dart';
import '../../../../views/views.dart';
import 'controller.dart';

class DriversTab extends utils.Page<DriversTabController> {
  DriversTab({Key? key}) : super(controller: DriversTabController(), key: key);

  @override
  DriversTabController get controller => super.controller!;

  static Widget floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => utils.RouteManager.to(PagesInfo.createEditDriver),
        child: const Icon(Icons.person_add_alt),
      );

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
            stream: DriverModel.collection.stream(),
            initialData: {},
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                utils.jsonEncode(snapshot.data).replaceAll('"', ''),
                style: TextStyle(fontSize: 20, color: UIThemeColors.text2),
              );
            },
          ),
          ButtonView.text(
            onPressed: () => DriverModel.collection.set({}, keepData: false),
            text: 'Clear Collection',
          ),
        ],
      );
}
