import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../src/src.dart';

abstract class Page<T extends GetxController> extends StatefulWidget {
  final T? controller;

  const Page({Key? key, this.controller}) : super(key: key);

  Widget? buildDrawer() => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? bottomNavigationBar() => null;

  GlobalKey<ScaffoldState>? get scaffoldKey => null;

  @protected
  Widget buildBody(BuildContext context);

  Widget _build(BuildContext context) {
    Widget builder() => Scaffold(
          key: scaffoldKey,
          drawer: buildDrawer(),
          backgroundColor: UIThemeColors.pageBackground,
          bottomNavigationBar: bottomNavigationBar(),
          appBar: buildAppBar(context),
          body: SizedBox.expand(child: buildBody(context)),
          floatingActionButton: buildFloatingActionButton(context),
        );

    return controller == null
        ? builder()
        : GetBuilder<T>(
            init: controller,
            builder: (controller) => builder(),
          );
  }

  void initState() {}

  void dispose() {}

  PageHeaders get pageHeaders => PageHeaders();

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  initState() {
    widget.initState();
    super.initState();
    // widget.setPageHeaders(PageHeaders());
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context);
}

class PageHeaders {
  String? title;
  bool? participatesInRootNavigator;
  double Function(BuildContext)? gestureWidth;
  bool maintainState;
  Curve curve;
  Alignment? alignment;
  Map<String, String>? parameters;
  bool opaque;
  Duration? transitionDuration;
  bool? popGesture;
  Bindings? binding;
  List<Bindings> bindings = const [];
  Transition? transition;
  CustomTransition? customTransition;
  bool fullscreenDialog;
  bool showCupertinoParallax;
  bool preventDuplicates;

  PageHeaders({
    this.title,
    this.participatesInRootNavigator,
    this.gestureWidth,
    this.maintainState = true,
    this.curve = Curves.linear,
    this.alignment,
    this.parameters,
    this.opaque = true,
    this.transitionDuration,
    this.popGesture,
    this.binding,
    this.transition,
    this.customTransition,
    this.fullscreenDialog = false,
    this.showCupertinoParallax = true,
    this.preventDuplicates = true,
  });
}
