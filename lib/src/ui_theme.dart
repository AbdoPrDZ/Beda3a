import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/main.service.dart';

class UIColors {
  // basic
  static const Color primary1 = Color(0XFF42AAFB);
  static const Color primary2 = Color(0XFF0C5994);
  static const Color success = Color(0XFF00B14D);
  static const Color danger = Color(0XFFE84F4F);
  static const Color warning = Color(0XFFFFCD00);
  static const Color grey = Color(0XFFB2B2B2);
}

class LightTheme {
  static const Map<String, Color> colors = {
    'pageBackground': Color(0XFFEFEFEF),
    'text1': Color(0XFF000000),
    'text2': Color(0XFF4D4D4D),
    'text3': Color(0XFF727272),
    'text4': Color(0XFF9B9B9B),
    'text5': Color(0XFFEFEFEF),
    'text6': Color(0XFF4387DF),
    'primary': UIColors.primary1,
    'success': UIColors.success,
    'danger': UIColors.danger,
    'iconFg': Color(0XFFEFEFEF),
    'iconBg': UIColors.primary1,
    'field': Color(0X8F757575),
    'fieldDanger': Color(0XFFBE1E1E),
    'fieldBg': Color(0X16797979),
    'fieldText': Color(0XFF424242),
    'fieldFocus': Color(0XFF4387DF),
    'cardBg': Color(0XFFFFFFFF),
    'cardBg1': Color(0XFFF4F4F4),
    'tableCellBg1': Colors.transparent,
    'tableCellFg1': Color(0XFF4D4D4D),
    'tableCellBg2': Color(0X85D3D3D3),
    'tableCellFg2': Color(0XFF727272),
  };
  static Color get pageBackground => colors['pageBackground']!;
  static Color get primary => colors['primary']!;
  static Color get success => colors['success']!;
  static Color get danger => colors['danger']!;
  static Color get text1 => colors['text1']!;
  static Color get text2 => colors['text2']!;
  static Color get text3 => colors['text3']!;
  static Color get text4 => colors['text4']!;
  static Color get text5 => colors['text5']!;
  static Color get text6 => colors['text6']!;
  static Color get iconBg => colors['iconBg']!;
  static Color get iconFg => colors['iconFg']!;
  static Color get field => colors['field']!;
  static Color get fieldDanger => colors['fieldDanger']!;
  static Color get fieldBg => colors['fieldBg']!;
  static Color get fieldText => colors['fieldText']!;
  static Color get fieldFocus => colors['fieldFocus']!;
  static Color get cardBg => colors['cardBg']!;
  static Color get cardBg1 => colors['cardBg1']!;
  static Color get tableCellBg1 => colors['tableCellBg1']!;
  static Color get tableCellFg1 => colors['tableCellFg1']!;
  static Color get tableCellBg2 => colors['tableCellBg2']!;
  static Color get tableCellFg2 => colors['tableCellFg2']!;
}

class DarkTheme {
  static const Map<String, Color> colors = {
    'pageBackground': Color(0xFF202020),
    'text1': Color(0xFFFFFFFF),
    'text2': Color(0xFFB2B2B2),
    'text3': Color(0xFF8D8D8D),
    'text4': Color(0xFF646464),
    'text5': Color(0xFF202020),
    'text6': Color(0xFF3567AA),
    'primary': UIColors.primary2,
    'success': UIColors.success,
    'danger': UIColors.danger,
    'iconFg': Color(0xFF202020),
    'iconBg': UIColors.primary2,
    'field': Color(0x8FFFFFFF),
    'fieldDanger': Color(0xFFBE1E1E),
    'fieldBg': Color(0x1DFFFFFF),
    'fieldText': Color(0xFFEBEBEB),
    'fieldFocus': Color(0xFF4387DF),
    'cardBg': Color(0xFF292929),
    'cardBg1': Color(0xFFEAEAEA),
    'tableCellBg1': Colors.transparent,
    'tableCellFg1': Color(0xFFB2B2B2),
    'tableCellBg2': Color(0x85818181),
    'tableCellFg2': Color(0xFFCFCFCF),
  };
  static Color get pageBackground => colors['pageBackground']!;
  static Color get primary => colors['primary']!;
  static Color get success => colors['success']!;
  static Color get danger => colors['danger']!;
  static Color get text1 => colors['text1']!;
  static Color get text2 => colors['text2']!;
  static Color get text3 => colors['text3']!;
  static Color get text4 => colors['text4']!;
  static Color get text5 => colors['text5']!;
  static Color get text6 => colors['text6']!;
  static Color get iconBg => colors['iconBg']!;
  static Color get iconFg => colors['iconFg']!;
  static Color get field => colors['field']!;
  static Color get fieldDanger => colors['fieldDanger']!;
  static Color get fieldBg => colors['fieldBg']!;
  static Color get fieldText => colors['fieldText']!;
  static Color get fieldFocus => colors['fieldFocus']!;
  static Color get cardBg => colors['cardBg']!;
  static Color get cardBg1 => colors['cardBg1']!;
  static Color get tableCellBg1 => colors['tableCellBg1']!;
  static Color get tableCellFg1 => colors['tableCellFg1']!;
  static Color get tableCellBg2 => colors['tableCellBg2']!;
  static Color get tableCellFg2 => colors['tableCellFg2']!;
}

class UIThemeColors extends Color {
  UIThemeColors(super.value);

  static UIThemeColors fromName(String name) {
    Map<String, Map<String, Color>> colors = {
      UIThemeMode.light.mode: LightTheme.colors,
      UIThemeMode.dark.mode: DarkTheme.colors
    };
    String mode = Get.find<MainService>().themeMode.mode;
    mode = ['Dark', 'Light'].contains(mode) ? mode : 'Light';
    return UIThemeColors(colors[mode]![name]!.value);
  }

  static Color get pageBackground => fromName('pageBackground');
  static Color get primary => fromName('primary');
  static Color get success => fromName('success');
  static Color get danger => fromName('danger');
  static Color get text1 => fromName('text1');
  static Color get text2 => fromName('text2');
  static Color get text3 => fromName('text3');
  static Color get text4 => fromName('text4');
  static Color get text5 => fromName('text5');
  static Color get text6 => fromName('text6');
  static Color get iconFg => fromName('iconFg');
  static Color get iconBg => fromName('iconBg');
  static Color get field => fromName("field");
  static Color get fieldDanger => fromName("fieldDanger");
  static Color get fieldBg => fromName("fieldBg");
  static Color get fieldText => fromName("fieldText");
  static Color get fieldFocus => fromName("fieldFocus");
  static Color get cardBg => fromName("cardBg");
  static Color get cardBg1 => fromName("cardBg1");
  static Color get tableCellBg1 => fromName("tableCellBg1");
  static Color get tableCellFg1 => fromName("tableCellFg1");
  static Color get tableCellBg2 => fromName("tableCellBg2");
  static Color get tableCellFg2 => fromName("tableCellFg2");
}

class UIThemeMode {
  final String mode;
  const UIThemeMode(this.mode);

  static const UIThemeMode dark = UIThemeMode("Dark");
  static const UIThemeMode light = UIThemeMode("Light");

  bool get isDark => mode == dark.mode;
  bool get isLight => mode == light.mode;

  @override
  String toString() => mode;
}
