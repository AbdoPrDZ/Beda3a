import 'package:flutter/material.dart';

import '../src/src.dart';

class ButtonView extends StatelessWidget {
  final Function()? onPressed;
  final EdgeInsets margin, padding;
  final Widget child;
  final Color? backgroundColor, borderColor;
  final double borderRaduis;
  final double? width, height;

  const ButtonView({
    Key? key,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderRaduis = 4,
    this.width,
    this.height,
  }) : super(key: key);

  ButtonView.text({
    Key? key,
    required Function()? onPressed,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 15,
    ),
    required String text,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? borderColor,
    double borderRaduis = 4,
    double? width,
    double? height,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  //fontFamily: Consts.fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          margin: margin,
          padding: padding,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderRaduis: borderRaduis,
          width: width,
          height: height,
        );

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: margin,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? UIThemeColors.primary,
            padding: padding,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRaduis),
              side: BorderSide(
                color: borderColor ?? UIColors.grey,
                width: 0.5,
              ),
            ),
          ),
          onPressed: onPressed,
          child: child,
        ),
      );
}

class OutlineButtonView extends StatelessWidget {
  final Function()? onPressed;
  final EdgeInsets margin, padding;
  final Widget child;
  final Color? borderColor;
  final double borderRaduis, borderSize;
  final double? width, height;

  const OutlineButtonView({
    Key? key,
    required this.onPressed,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
    required this.child,
    this.borderColor,
    this.borderRaduis = 20,
    this.borderSize = 1.8,
  }) : super(key: key);

  OutlineButtonView.text(
    String text, {
    Key? key,
    required Function()? onPressed,
    TextStyle? textStyle,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = const EdgeInsets.symmetric(
      vertical: 13,
      horizontal: 15,
    ),
    Color? borderColor,
    double borderRaduis = 20,
    double borderSize = 1.8,
    double? width,
    double? height,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Text(text, style: textStyle),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRaduis: borderRaduis,
          borderSize: borderSize,
          width: width,
          height: height,
        );

  OutlineButtonView.icon(
    IconData icon, {
    Key? key,
    required Function()? onPressed,
    double size = 50,
    double? iconSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    Color? borderColor,
    Color? iconColor,
    double borderRaduis = 50,
    double borderSize = 1.8,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Icon(
            icon,
            size: iconSize ?? size * 0.7,
            color: iconColor,
          ),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRaduis: borderRaduis,
          borderSize: borderSize,
          width: size,
          height: size,
        );

  OutlineButtonView.image(
    ImageProvider image, {
    Key? key,
    required Function()? onPressed,
    double size = 50,
    double? iconSize,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    Color? borderColor,
    double borderRaduis = 50,
    double borderSize = 1.8,
  }) : this(
          key: key,
          onPressed: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            width: iconSize ?? size * 0.7,
            height: iconSize ?? size * 0.7,
          ),
          margin: margin,
          padding: padding,
          borderColor: borderColor,
          borderRaduis: borderRaduis,
          borderSize: borderSize,
          width: size,
          height: size,
        );

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: margin,
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          maxWidth: width ?? double.infinity,
        ),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            //foregroundColor: UIThemeColors.primary,
            backgroundColor: Colors.transparent,
            elevation: 0,
            side: BorderSide(
                color: borderColor ?? UIThemeColors.iconBg, width: borderSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRaduis),
            ),
            padding: padding,
          ),
          child: child,
        ),
      );
}

class CirclerButtonView extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double size, borderSize;
  final Color? backgroundColor, borderColor;
  final EdgeInsets? margin;
  final EdgeInsets padding;

  const CirclerButtonView({
    required this.child,
    required this.onPressed,
    this.size = 50,
    this.backgroundColor,
    this.borderColor,
    this.borderSize = 1,
    this.margin,
    this.padding = const EdgeInsets.all(5),
    Key? key,
  }) : super(key: key);

  static CirclerButtonView icon(
    IconData icon, {
    required Function()? onPressed,
    Color? iconColor,
    double size = 50,
    double borderSize = 1,
    double? iconSize,
    Color? backgroundColor,
    Color borderColor = Colors.transparent,
    EdgeInsets? margin,
    EdgeInsets padding = const EdgeInsets.all(8),
  }) =>
      CirclerButtonView(
        onPressed: onPressed,
        size: size,
        borderSize: borderSize,
        backgroundColor: backgroundColor ?? UIThemeColors.iconBg,
        borderColor: borderColor,
        margin: margin,
        padding: padding,
        child: Icon(
          icon,
          color: iconColor ?? UIThemeColors.iconFg,
          size: iconSize ?? size * 0.6,
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        width: size,
        height: size,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              CircleBorder(
                side: BorderSide(
                  color: borderColor ?? UIThemeColors.primary,
                  width: borderSize,
                ),
              ),
            ),
            padding: MaterialStateProperty.all(padding),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (states) => states.contains(MaterialState.pressed)
                  ? Theme.of(context).splashColor
                  : null,
            ),
          ),
          child: child,
        ),
      );
}
