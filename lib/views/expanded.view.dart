import 'package:flutter/material.dart';

import '../utils/utils.dart';

class ExpandedView extends StatefulWidget {
  final String? sessionsName;
  final EdgeInsets? margin, padding;
  final double? width, height;
  final Widget Function(BuildContext context) buildHeader;
  final Widget Function(BuildContext context) buildBody;
  final bool expanded;
  final IconData expandedIcon, unExpandedIcon;

  const ExpandedView({
    super.key,
    this.sessionsName,
    this.width,
    this.height,
    this.margin,
    this.padding,
    required this.buildHeader,
    required this.buildBody,
    this.expanded = true,
    this.expandedIcon = Icons.arrow_drop_down,
    this.unExpandedIcon = Icons.arrow_drop_up,
  });

  factory ExpandedView.label(
    String label, {
    String? sessionsName,
    double? width,
    double? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    required Widget Function(BuildContext context) buildBody,
    bool expanded = true,
    IconData expandedIcon = Icons.arrow_drop_down,
    IconData unExpandedIcon = Icons.arrow_drop_up,
  }) =>
      ExpandedView(
        sessionsName: sessionsName,
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        buildHeader: (context) => Text(
          label,
          style: TextStyle(
            color: UIThemeColors.text2,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buildBody: buildBody,
        expanded: expanded,
        expandedIcon: expandedIcon,
        unExpandedIcon: unExpandedIcon,
      );

  @override
  State<ExpandedView> createState() => _ExpandedViewState();
}

class _ExpandedViewState extends State<ExpandedView> {
  ViewSessions<bool>? viewSessions;
  bool expanded = true;

  @override
  void initState() {
    super.initState();
    expanded = widget.expanded;
    if (widget.sessionsName != null && widget.sessionsName!.isNotEmpty) {
      viewSessions = ViewSessions<bool>(
        'expanded_view-${widget.sessionsName}',
        loadData: false,
      );
      viewSessions!.loadData().then((expanded) async {
        if (expanded == null) {
          viewSessions!.data = this.expanded;
          await viewSessions!.saveData();
        }
        setState(() => this.expanded = viewSessions!.data!);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        margin: widget.margin,
        child: Flex(
          direction: Axis.vertical,
          children: [
            InkWell(
              onTap: () => setState(() {
                expanded = !expanded;
                viewSessions?.data = expanded;
                viewSessions?.saveData();
              }),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Icon(
                    expanded ? widget.expandedIcon : widget.unExpandedIcon,
                    color: UIThemeColors.text2,
                  ),
                  widget.buildHeader(context),
                ],
              ),
            ),
            if (expanded) widget.buildBody(context)
          ],
        ),
      );
}
