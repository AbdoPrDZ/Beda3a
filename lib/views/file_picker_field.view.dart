import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gap/gap.dart';

import '../src/src.dart';

class FilePickerFieldView<T extends FileSystemEntity> extends StatefulWidget {
  final T? initialValue;
  final FilePickType pickType;
  final EdgeInsets margin, padding;
  final double? width, height;
  final Function(dynamic fileSystem) onPick;
  final String? Function(dynamic fileSystem)? validator;
  final String? label, hint;

  const FilePickerFieldView({
    super.key,
    this.initialValue,
    this.pickType = FilePickType.file,
    required this.onPick,
    this.validator,
    this.label,
    this.hint,
    this.width = double.infinity,
    this.height,
    this.margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
  });

  @override
  State<FilePickerFieldView> createState() => _FilePickerFieldViewState<T>();
}

class _FilePickerFieldViewState<T extends FileSystemEntity>
    extends State<FilePickerFieldView> {
  FormFieldState<T?>? _currentState;

  T? currentFileSystem;

  @override
  void initState() {
    currentFileSystem = widget.initialValue as T?;
    super.initState();
  }

  void pick() async {
    currentFileSystem = null;
    if (widget.pickType == FilePickType.file) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result?.files.single.path != null) {
        currentFileSystem = File(result!.files.single.path!) as T?;
      }
    } else {
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) currentFileSystem = Directory(directory) as T?;
    }
    _currentState?.didChange(currentFileSystem);
    setState(() {});
    widget.onPick(widget.pickType == FilePickType.file
        ? currentFileSystem as File?
        : currentFileSystem as Directory?);
  }

  @override
  Widget build(BuildContext context) => FormField<T?>(
        initialValue: widget.initialValue as T?,
        validator: widget.validator,
        builder: (state) {
          _currentState = state;
          return Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.label != null) ...[
                  Text(
                    widget.label!,
                    style: TextStyle(
                      color: UIThemeColors.text2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(5),
                ],
                InkWell(
                  onTap: pick,
                  child: Container(
                    padding: widget.padding,
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
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        currentFileSystem?.path ?? widget.hint ?? "",
                        style: TextStyle(
                          color: currentFileSystem?.path == null
                              ? UIThemeColors.field
                              : UIThemeColors.fieldText,
                          fontSize: 16,
                        ),
                      ),
                    ),
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

enum FilePickType { file, directory }
