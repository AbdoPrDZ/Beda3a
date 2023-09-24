import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../src/src.dart';

class DropDownView<T> extends StatelessWidget {
  final T? value;
  final String? hint, label;
  final List<DropdownMenuItem<T>> items;
  final Function(T? value) onChanged;
  final EdgeInsets margin, padding;
  final double? width, height;
  final String? Function(T?)? validation;

  const DropDownView({
    Key? key,
    this.value,
    this.margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.width = double.infinity,
    this.height,
    required this.items,
    required this.onChanged,
    this.hint,
    this.label,
    this.validation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FormField<T>(
        initialValue: value,
        validator: validation,
        builder: (state) => Container(
          width: width,
          // height: height ?? (label != null ? 75 : 55),
          margin: margin,
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (label != null) ...[
                Text(
                  label!,
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(5),
              ],
              Container(
                padding: padding,
                height: 48,
                decoration: BoxDecoration(
                  color: UIThemeColors.fieldBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: state.hasError
                        ? UIThemeColors.danger
                        : UIThemeColors.field,
                    width: 0.8,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DropdownButton<T>(
                        value: value,
                        hint: hint != null
                            ? Text(
                                hint!,
                                style: TextStyle(
                                    fontSize: 16, color: UIThemeColors.field),
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        style: TextStyle(
                          fontSize: 16,
                          color: UIThemeColors.text3,
                        ),
                        items: items,
                        onChanged: (value) {
                          state.didChange(value);
                          onChanged(value);
                        },
                        dropdownColor: UIThemeColors.pageBackground,
                        borderRadius: BorderRadius.circular(8),
                        underline: Container(),
                        icon: Container(),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: UIThemeColors.fieldText,
                      ),
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
        ),
      );
}
