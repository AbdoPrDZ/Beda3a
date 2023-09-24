import 'package:gap/gap.dart';

import '../models/models.dart';
import '../src/src.dart';
import 'views.dart';

class OrdersView extends StatelessWidget {
  final String label;
  final bool readOnly;
  final double itemsBoxHeight;
  final List<OrderModel> orders;
  final Function()? addOrder;
  final Function(OrderModel order)? removeOrder;

  const OrdersView({
    super.key,
    this.label = 'Orders',
    this.readOnly = false,
    this.itemsBoxHeight = 250,
    required this.orders,
    this.addOrder,
    this.removeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (state) {
        return ExpandedView(
          buildHeader: (context) => Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: C,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: UIThemeColors.text2,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!readOnly)
                OutlineButtonView.icon(
                  Icons.add,
                  onPressed: addOrder,
                  margin: const EdgeInsets.only(top: 15),
                  size: 40,
                ),
            ],
          ),
          buildBody: (context) => Flex(
            direction: Axis.vertical,
            children: [
              Container(
                height: itemsBoxHeight,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: UIThemeColors.fieldBg,
                  border: Border.all(
                    width: 0.8,
                    color: state.hasError
                        ? UIThemeColors.fieldDanger
                        : UIThemeColors.field,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  primary: false,
                  children: [
                    for (OrderModel order in orders)
                      FutureBuilder(
                        future: order.loadAll(),
                        builder: (context, snapshot) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: UIThemeColors.fieldBg,
                              border: Border.all(
                                width: 0.5,
                                color: UIThemeColors.field,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  child: Text(
                                    '${order.fromClient_?.fullName.substring(0, 1) ?? order.fromClientId} '
                                    '${order.toClient_?.fullName.substring(0, 1) ?? order.toClientId}',
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(text: 'From: '),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          child: Icon(
                                            Icons.upgrade_sharp,
                                            color: UIThemeColors.fieldDanger,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${order.fromClient_?.fullName.substring(1, 2) ?? order.fromClientId}\n',
                                      ),
                                      const TextSpan(text: 'to: '),
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          child: Icon(
                                            Icons.download_sharp,
                                            color: UIThemeColors.fieldDanger,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${order.toClient_?.fullName.substring(1, 2) ?? order.toClientId}\n',
                                      ),
                                    ],
                                  ),
                                ),
                                OutlineButtonView.icon(
                                  Icons.delete,
                                  onPressed: () => removeOrder?.call(order),
                                  size: 30,
                                  borderColor: Colors.transparent,
                                  iconColor: UIThemeColors.danger,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                  ],
                ),
              ),
              if (state.hasError) ...[
                const Gap(4),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.error_outline,
                            color: UIThemeColors.fieldDanger,
                            size: 15,
                          ),
                        ),
                      ),
                      TextSpan(text: state.errorText!),
                    ],
                  ),
                  style: TextStyle(color: UIThemeColors.fieldDanger),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
