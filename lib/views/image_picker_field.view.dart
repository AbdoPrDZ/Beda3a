import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../src/src.dart';
import 'views.dart';

class ImagePickerFieldView extends StatefulWidget {
  final EdgeInsets padding, margin;
  final double? width, height, maxWidth, maxHeight;
  final String? label;
  final Future<bool> Function(File image) onPick;
  final Future<bool> Function(File image) onRemove;
  final List<File> images;
  final bool adjustQuality;
  final int adjustQualityValue;
  final double adjustQualityValueOnSize;
  final ImagePickerSource imageSource;
  final String? Function(List<File>?)? validator;

  const ImagePickerFieldView({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    this.margin = const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.label,
    this.adjustQuality = true,
    this.adjustQualityValue = 10,
    this.adjustQualityValueOnSize = 2,
    this.imageSource = ImagePickerSource.galleryMulti,
    required this.images,
    required this.onPick,
    required this.onRemove,
    this.validator,
  });

  @override
  State<ImagePickerFieldView> createState() => _ImagePickerFieldViewState();
}

class _ImagePickerFieldViewState extends State<ImagePickerFieldView> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  pickImage() async {
    List<XFile> xImages = [];
    if ([
      ImagePickerSource.cameraSingle,
      ImagePickerSource.cameraMulti,
      ImagePickerSource.gallerySingle,
    ].contains(widget.imageSource)) {
      final image = await ImagePicker().pickImage(
        source: [
          ImagePickerSource.cameraSingle,
          ImagePickerSource.cameraMulti,
        ].contains(widget.imageSource)
            ? ImageSource.camera
            : ImageSource.gallery,
      );
      if (image != null) xImages.add(image);
    } else {
      xImages = await ImagePicker().pickMultiImage();
    }
    List<File> images = [for (XFile image in xImages) File(image.path)];
    for (File image in images) {
      try {
        if ((image.lengthSync() / 2048) > widget.adjustQualityValueOnSize) {
          image = await FlutterNativeImage.compressImage(
            image.path,
            quality: widget.adjustQualityValue,
          );
        }
      } catch (e) {
        dev.log('$e');
      }
      await widget.onPick(image);
    }
    _currentState?.didChange(images);
  }

  onRemove(File image) async {
    if (await widget.onRemove(image)) _currentState?.didChange(widget.images);
  }

  FormFieldState<List<File>>? _currentState;

  @override
  Widget build(BuildContext context) => FormField<List<File>>(
        initialValue: widget.images,
        validator: widget.validator,
        builder: (state) {
          _currentState = state;
          return Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth ?? double.infinity,
              maxHeight: widget.maxHeight ?? double.infinity,
            ),
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
                Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: UIThemeColors.fieldBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 0.8,
                      color: state.hasError
                          ? UIThemeColors.danger
                          : UIThemeColors.field,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: widget.height == null
                            ? MediaQuery.of(context).size.width * 0.8
                            : null,
                        child: PageView(
                          controller: pageController,
                          children: [
                            for (File image in widget.images)
                              Container(
                                decoration: BoxDecoration(
                                  color: UIThemeColors.pageBackground,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CirclerButtonView.icon(
                                    Icons.delete_outline_rounded,
                                    size: 30,
                                    padding: EdgeInsets.zero,
                                    margin:
                                        const EdgeInsets.only(top: 5, right: 5),
                                    backgroundColor: UIThemeColors.danger,
                                    iconColor: UIThemeColors.iconFg,
                                    onPressed: () => onRemove(image),
                                  ),
                                ),
                              ),
                            if ([
                                  ImagePickerSource.galleryMulti,
                                  ImagePickerSource.cameraMulti
                                ].contains(widget.imageSource) ||
                                widget.images.isEmpty)
                              Center(
                                child: CirclerButtonView.icon(
                                  Icons.add_a_photo_outlined,
                                  onPressed: pickImage,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if ([
                        ImagePickerSource.galleryMulti,
                        ImagePickerSource.cameraMulti
                      ].contains(widget.imageSource))
                        Positioned.fill(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              IconButton(
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: UIThemeColors.text2,
                                  size: 30,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  pageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn,
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: UIThemeColors.text2,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
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

enum ImagePickerSource {
  gallerySingle,
  galleryMulti,
  cameraSingle,
  cameraMulti,
}
