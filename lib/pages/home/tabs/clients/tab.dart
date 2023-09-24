import '../../../../models/models.dart';
import '../../../../utils/utils.dart' as utils;
import '../../../../src/src.dart';
import '../../../../views/views.dart';
import 'controller.dart';

class ClientsTab extends utils.Page<ClientsTabController> {
  ClientsTab({Key? key}) : super(controller: ClientsTabController(), key: key);

  @override
  ClientsTabController get controller => super.controller!;

  static Widget floatingActionButton(BuildContext context) =>
      FloatingActionButton(
        onPressed: () => utils.RouteManager.to(PagesInfo.createEditClient),
        child: const Icon(Icons.person_add_alt),
      );

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder(
            stream: ClientModel.collection.stream(),
            initialData: {},
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text(
                utils.jsonEncode(snapshot.data).replaceAll('"', ''),
                style: TextStyle(fontSize: 20, color: UIThemeColors.text2),
              );
            },
          ),
          ButtonView.text(
            onPressed: () => ClientModel.collection.set({}, keepData: false),
            text: 'Clear Collection',
          ),
        ],
      );
}
