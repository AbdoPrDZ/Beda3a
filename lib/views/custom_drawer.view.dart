import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'button.view.dart';

class CustomDrawerView extends StatefulWidget {
  final List<DrawerItem> tabsItems;
  final PageController pageController;
  final Widget Function(BuildContext context)? buildHeader;
  final Widget Function(BuildContext context)? buildFooter;
  final Widget Function(
    DrawerItem drawerItem,
    Function(DrawerItem) onTabItemSelected,
  )? buildItem;
  final Function(DrawerItem drawerItem)? onTabItemSelected;
  final UIThemeMode themeMode;
  final Function(UIThemeMode themeMode) onThemeModeChanged;
  final List<DrawerLanguageItem> languages;
  final DrawerLanguageItem currentLanguage;
  final bool Function(DrawerLanguageItem language)? onLanguageChange;

  const CustomDrawerView({
    super.key,
    required this.tabsItems,
    required this.pageController,
    required this.onTabItemSelected,
    this.buildHeader,
    this.buildFooter,
    this.buildItem,
    this.themeMode = UIThemeMode.light,
    required this.onThemeModeChanged,
    this.languages = const [
      DrawerLanguageItem('Ar', backgroundColor: UIColors.success),
      DrawerLanguageItem('En'),
      DrawerLanguageItem('Fr', backgroundColor: UIColors.danger),
    ],
    this.currentLanguage = const DrawerLanguageItem('En'),
    this.onLanguageChange,
  });

  @override
  createState() => _CustomDrawerViewState();
}

class _CustomDrawerViewState extends State<CustomDrawerView> {
  late DrawerItem currentDrawerItem;
  late DrawerLanguageItem currentLanguage;

  @override
  void initState() {
    super.initState();
    currentDrawerItem =
        widget.tabsItems[widget.pageController.page?.toInt() ?? 0];
    currentLanguage = widget.currentLanguage;
    // widget.pageController.addListener(() {
    //   setState(() {
    //     currentDrawerItem =
    //         widget.tabsItems[widget.pageController.page?.toInt() ?? 0];
    //   });
    // });
  }

  onTabItemSelected(DrawerItem drawerItem) async {
    if (!drawerItem.isAction) {
      widget.pageController.animateToPage(
        widget.tabsItems.indexOf(drawerItem),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Get.back();
      if (widget.onTabItemSelected != null) {
        widget.onTabItemSelected!(drawerItem);
        setState(() {
          currentDrawerItem = drawerItem;
        });
      }
    } else {
      await drawerItem.onActionTab?.call();
    }
  }

  changeLanguage(DrawerLanguageItem language) {
    // if (widget.onLanguageChange != null &&
    //     widget.onLanguageChange!(widget.languages[index])) {
    setState(() {
      currentLanguage = language;
    });
    Get.back();
    // }
  }

  TextButton _buildItem(
    DrawerItem drawerItem,
    Function(DrawerItem drawerItem) onTabItemSelected,
  ) =>
      TextButton(
        onPressed: () => onTabItemSelected(drawerItem),
        style: ButtonStyle(
          alignment: Alignment.centerLeft,
          padding: MaterialStateProperty.resolveWith(
            (states) => const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
          ),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Icon(
              drawerItem.icon,
              color: currentDrawerItem == drawerItem
                  ? UIThemeColors.primary
                  : UIThemeColors.text3,
            ),
            const Gap(10),
            Flexible(
              child: Text(
                drawerItem.text,
                style: TextStyle(
                  color: currentDrawerItem == drawerItem
                      ? UIThemeColors.primary
                      : UIThemeColors.text3,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Drawer(
          child: Container(
            width: 280,
            height: SizeConfig(context).realScreenHeight * 0.9,
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig(context).screenHeight * 0.05,
            ),
            decoration: BoxDecoration(
              color: UIThemeColors.pageBackground,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(2, 1),
                  color: Color(0X77333333),
                )
              ],
            ),
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIThemeColors.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(19),
                    ),
                  ),
                  child: widget.buildHeader?.call(context),
                ),
                Flexible(
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: widget.tabsItems.length,
                          itemBuilder: (context, index) =>
                              (widget.buildItem ?? _buildItem)(
                            widget.tabsItems[index],
                            onTabItemSelected,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      color: widget.themeMode == UIThemeMode.light
                          ? UIThemeColors.primary
                          : UIThemeColors.text2,
                    ),
                    Switch(
                      value: widget.themeMode == UIThemeMode.dark,
                      onChanged: (value) {
                        widget.onThemeModeChanged(
                          value ? UIThemeMode.dark : UIThemeMode.light,
                        );
                        Get.back();
                      },
                    ),
                    Icon(
                      Icons.dark_mode_outlined,
                      color: widget.themeMode == UIThemeMode.dark
                          ? UIThemeColors.primary
                          : UIThemeColors.text2,
                    )
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final item in widget.languages)
                      ButtonView(
                        backgroundColor: item.backgroundColor,
                        onPressed: currentLanguage == item
                            ? null
                            : () => changeLanguage(item),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(
                          item.language,
                          style: TextStyle(
                            color: currentLanguage == item
                                ? item.disabledTextColor
                                : item.textColor,
                            fontSize: 15,
                          ),
                        ),
                      )
                  ],
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: UIThemeColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(19),
                    ),
                  ),
                  child: widget.buildFooter?.call(context),
                ),
              ],
            ),
          ),
        ),
      );
}

class DrawerItem {
  final IconData icon;
  final String text;
  final bool isAction;
  final Future Function()? onActionTab;
  final Widget Function(BuildContext context)? buildTab;
  final Widget? Function(BuildContext context)? buildFloatingActionButton;

  const DrawerItem(
    this.text,
    this.icon, {
    this.isAction = false,
    this.onActionTab,
    this.buildTab,
    this.buildFloatingActionButton,
  })  : assert(
          !((isAction && buildTab != null) || (!isAction && buildTab == null)),
          'The DrawerItem can\'t be an action and have tab widget or does not have tab widget and is not action same time',
        ),
        assert(
          !(isAction && onActionTab == null),
          'onActionTab required when DrawerItem is action',
        );
}

class DrawerLanguageItem {
  final String language;
  final Color? backgroundColor;
  final Color textColor, disabledTextColor;

  const DrawerLanguageItem(
    this.language, {
    this.backgroundColor,
    this.textColor = const Color(0XFFFFFFFF),
    this.disabledTextColor = const Color(0XFF707070),
  });
}
