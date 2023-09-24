import '../../../../models/models.dart';
import '../../../../utils/utils.dart' as utils;
import '../../../../src/src.dart';
import '../../../../views/views.dart';
import 'controller.dart';

class TrucksTab extends utils.Page<TrucksTabController> {
  TrucksTab({Key? key}) : super(controller: TrucksTabController(), key: key);

  @override
  TrucksTabController get controller => super.controller!;

  static Widget floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => utils.RouteManager.to(PagesInfo.createEditTruck),
        child: const Icon(Icons.fire_truck),
      );

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
            stream: TruckModel.collection.stream(),
            initialData: {},
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                utils.jsonEncode(snapshot.data).replaceAll('"', ''),
                style: TextStyle(fontSize: 20, color: UIThemeColors.text2),
              );
            },
          ),
          ButtonView.text(
            onPressed: () => TruckModel.collection.set({}, keepData: false),
            text: 'Clear Collection',
          ),
        ],
      );
}
