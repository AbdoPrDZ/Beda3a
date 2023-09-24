import '../../../../models/models.dart';
import '../../../../utils/utils.dart' as utils;
import '../../../../src/src.dart';
import '../../../../views/views.dart';
import '../../../create_edit_trip/controller.dart';
import '../../controller.dart';
import 'controller.dart';

class TripsTab extends utils.Page<TripsTabController> {
  TripsTab({Key? key}) : super(controller: TripsTabController(), key: key);

  @override
  TripsTabController get controller => super.controller!;

  static Widget? floatingActionButton(
    HomeController homeController,
    BuildContext context,
  ) =>
      homeController.selectedTruckId != null
          ? FloatingActionButton(
              onPressed: () => utils.RouteManager.to(
                PagesInfo.createEditTrip,
                arguments: CreateEditTripData(
                  truckId: homeController.selectedTruckId!,
                ),
              ),
              child: const Icon(Icons.alt_route_sharp),
            )
          : null;

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
            stream: TripModel.collection.stream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              String text;
              try {
                text = utils.jsonEncode(snapshot.data).replaceAll('"', '');
              } catch (e) {
                text = '';
              }
              return Text(
                text,
                style: TextStyle(fontSize: 20, color: UIThemeColors.text2),
              );
            },
          ),
          ButtonView.text(
            onPressed: () => TripModel.collection.set({}, keepData: false),
            text: 'Clear Collection',
          ),
        ],
      );
}
