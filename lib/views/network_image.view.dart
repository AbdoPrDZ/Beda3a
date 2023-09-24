import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_database/storage_database.dart';
import 'package:storage_database/storage_explorer/explorer_network_files.dart';

import '../services/main.service.dart';

class NetworkImageView extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit = BoxFit.cover;
  final String url;

  const NetworkImageView(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  StorageDatabase get storageDatabase =>
      Get.find<MainService>().storageDatabase;

  StorageExplorer? get explorer => storageDatabase.explorer;

  Widget _build(BuildContext context) => ExplorerNetworkImage(
        explorerNetworkFiles: explorer!.networkFiles!,
        url: url,
        borderRadius: borderRadius,
        fit: fit,
        height: height,
        width: height,
      );

  Future init() async {
    await storageDatabase.initExplorer();
    await storageDatabase.explorer!.initNetWorkFiles();
  }

  @override
  Widget build(BuildContext context) =>
      explorer != null && explorer!.networkFiles != null
          ? _build(context)
          : FutureBuilder(
              future: init(),
              builder: (context, snapshot) =>
                  snapshot.hasData ? _build(context) : Container(),
            );
}
