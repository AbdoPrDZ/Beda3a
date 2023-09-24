import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../src/src.dart';
import '../../utils/utils.dart' as utils;
import 'controller.dart';

class LoadingPage extends utils.Page<LoadingController> {
  LoadingPage({Key? key}) : super(controller: LoadingController(), key: key);

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            Consts.logo,
            width: 130,
            height: 130,
          ),
          const Gap(10),
          Text(
            Consts.appName,
            style: TextStyle(color: UIThemeColors.text1, fontSize: 24),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CircularProgressIndicator(
              color: UIThemeColors.primary,
            ),
          ),
          const Spacer(),
        ],
      );
}
