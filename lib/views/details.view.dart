import 'package:gap/gap.dart';

import '../src/src.dart';
import 'views.dart';

class DetailsView extends StatefulWidget {
  final String label;
  final String? sessionsName;
  final double width, itemsBoxHeight;
  final Map<String, String> details;
  final Map<String, String> Function(String name, String value) onAdd;
  final Map<String, String> Function(String name) onRemove;
  final String? Function(Map<String, String>?)? validator;

  const DetailsView({
    super.key,
    this.label = 'Details',
    required this.details,
    required this.onAdd,
    required this.onRemove,
    this.sessionsName,
    this.width = double.infinity,
    this.itemsBoxHeight = 250,
    this.validator,
  });

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  @override
  Widget build(BuildContext context) {
    return FormField<Map<String, String>>(
      initialValue: widget.details,
      validator: widget.validator,
      builder: (state) {
        return ExpandedView.label(
          widget.label,
          sessionsName: widget.sessionsName != null
              ? 'details-${widget.sessionsName}'
              : null,
          width: widget.width,
          buildBody: (context) => Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CreateDetailsItemForm(onAdd: (name, value) {
                state.didChange(widget.onAdd(name, value));
              }),
              Container(
                height: widget.itemsBoxHeight,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
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
                child: ListView(
                  primary: false,
                  children: [
                    for (String name in widget.details.keys)
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: UIThemeColors.fieldBg,
                          border: Border.all(
                            width: 0.5,
                            color: UIThemeColors.field,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text(name),
                            const Spacer(),
                            Container(
                              width: 0.8,
                              height: 15,
                              color: Colors.black,
                            ),
                            const Spacer(),
                            Text(widget.details[name]!),
                            const Spacer(),
                            OutlineButtonView.icon(
                              Icons.delete,
                              onPressed: () => widget.onRemove(name),
                              size: 30,
                              borderColor: Colors.transparent,
                              iconColor: UIThemeColors.danger,
                            ),
                          ],
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
        );
      },
    );
  }
}

class CreateDetailsItemForm extends StatefulWidget {
  final Function(String name, String value) onAdd;

  const CreateDetailsItemForm({super.key, required this.onAdd});

  @override
  State<CreateDetailsItemForm> createState() => _CreateDetailsItemFormState();
}

class _CreateDetailsItemFormState extends State<CreateDetailsItemForm> {
  final nameController = TextEditController(name: 'details_name');
  final valueController = TextEditController(name: 'details_value');

  final formKey = GlobalKey<FormState>();

  addItem() {
    if (formKey.currentState!.validate()) {
      widget.onAdd(nameController.text, valueController.text);
      nameController.clear();
      valueController.clear();
      formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: TextEditView(
              controller: nameController,
              hint: 'Name',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Name is required';
                return null;
              },
              onSubmitted: (value) => addItem(),
            ),
          ),
          Flexible(
            child: TextEditView(
              controller: valueController,
              hint: 'Value',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Name is required';
                return null;
              },
              onSubmitted: (value) => addItem(),
            ),
          ),
          OutlineButtonView.icon(
            Icons.add,
            onPressed: addItem,
            margin: const EdgeInsets.only(top: 15),
            size: 40,
          ),
        ],
      ),
    );
  }
}
