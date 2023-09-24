import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../src/src.dart';
import 'views.dart';

class DialogsView extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin, padding;
  final double? width, height;
  final bool isDismissible;

  const DialogsView({
    Key? key,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.isDismissible = true,
  }) : super(key: key);

  factory DialogsView.message(
    String title,
    String message, {
    List<DialogAction>? actions,
    bool isDismissible = true,
  }) =>
      DialogsView(
        isDismissible: isDismissible,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: UIThemeColors.text1,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 16,
              ),
              child: FittedBox(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (DialogAction action in (actions ?? DialogAction.ok))
                    ButtonView.text(
                      onPressed: action.onPressed,
                      text: action.text,
                      backgroundColor: action.actionColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );

  factory DialogsView.loading({
    Key? key,
    String? title,
    String message = 'Loading...',
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) =>
      DialogsView(
        isDismissible: false,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textDirection: TextDirection.ltr,
          children: [
            if (title != null)
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: UIThemeColors.text1,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Flex(
                direction: Axis.horizontal,
                textDirection: TextDirection.ltr,
                children: [
                  CircularProgressIndicator(color: UIThemeColors.primary),
                  const Gap(10),
                  Text(
                    message,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text2,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  factory DialogsView.form({
    Key? key,
    required String title,
    GlobalKey<FormState>? formKey,
    required List<DialogFormField> fields,
    required List<DialogAction> actions,
    bool isDismissible = true,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? width,
    double? height,
  }) {
    if (fields.isEmpty) throw ErrorHint('Fields list must be not empty');
    return DialogsView(
      child: Form(
        key: formKey,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: UIThemeColors.text1,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 16,
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  for (DialogFormField field in fields) field.buildField(null),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              child: Flex(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                direction: Axis.horizontal,
                children: [
                  for (DialogAction action in actions)
                    ButtonView.text(
                      text: action.text,
                      onPressed: action.onPressed,
                      backgroundColor: action.actionColor,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future show() => Get.dialog(this, barrierDismissible: isDismissible);

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => isDismissible,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: margin,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: UIThemeColors.pageBackground,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: child,
            ),
          ),
        ),
      );
}

class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? actionColor;

  DialogAction({
    required this.text,
    required this.onPressed,
    this.actionColor,
  });

  static List<DialogAction> ok = [
    DialogAction(text: 'Ok', onPressed: () => Get.back()),
  ];
  static List<DialogAction> yesNo = [
    DialogAction(text: 'Yes', onPressed: () => Get.back(result: true)),
    DialogAction(
      text: 'No',
      actionColor: UIThemeColors.danger,
      onPressed: () => Get.back(result: false),
    ),
  ];
  static List<DialogAction> rYesNo = [
    DialogAction(
      text: 'Yes',
      actionColor: UIThemeColors.danger,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(text: 'No', onPressed: () => Get.back(result: false)),
  ];
  static List<DialogAction> yesCancel = [
    DialogAction(text: 'Yes', onPressed: () => Get.back(result: true)),
    DialogAction(
      text: 'No',
      actionColor: UIThemeColors.danger,
      onPressed: () => Get.back(result: false),
    ),
  ];
  static List<DialogAction> rYesCancel = [
    DialogAction(
      text: 'Yes',
      actionColor: UIThemeColors.danger,
      onPressed: () => Get.back(result: true),
    ),
    DialogAction(text: 'Cancel', onPressed: () => Get.back(result: false)),
  ];
}

class DialogFormField {
  final String name;
  final Widget Function(BuildContext? context) buildField;

  const DialogFormField(
    this.name,
    this.buildField,
  );

  factory DialogFormField.textEdit({
    required String name,
    TextEditController? controller,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function(String?)? onSaved,
    List<TextInputFormatter> inputFormatter = const [],
    String? initialValue,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    bool autofocus = false,
    TextInputType keyboardType = TextInputType.text,
    FocusNode? focusNode,
    Color? cursorColor,
    Duration debounceDuration = const Duration(milliseconds: 400),
    String? Function(String?)? validator,
    String? hint,
    String? label,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    double? width,
    double? height,
    double? maxWidth,
    double? maxHeight,
    Color? backgroundColor,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool multiLine = false,
  }) =>
      DialogFormField(
        name,
        (context) => TextEditView(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onSaved: onSaved,
          inputFormatter: inputFormatter,
          initialValue: initialValue,
          textCapitalization: textCapitalization,
          autofocus: autofocus,
          keyboardType: keyboardType,
          cursorColor: cursorColor,
          debounceDuration: debounceDuration,
          validator: validator,
          hint: hint,
          label: label,
          margin: margin,
          width: width,
          height: height,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          backgroundColor: backgroundColor,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          multiLine: multiLine,
          focusNode: focusNode,
        ),
      );

  static DialogFormField dropDown<T>({
    required String name,
    T? value,
    String? hint,
    String? label,
    required List<DropdownMenuItem<T>> items,
    required Function(T? value) onChanged,
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15),
    double? width,
    double? height,
    String? Function(T?)? validation,
  }) =>
      DialogFormField(
        name,
        (context) => DropDownView(
          value: value,
          hint: hint,
          label: label,
          items: items,
          onChanged: onChanged,
          margin: margin,
          padding: padding,
          width: width,
          height: height,
          validation: validation,
        ),
      );
}
