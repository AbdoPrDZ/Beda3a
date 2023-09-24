abstract class CreateEditPageData {
  final CreateEditPageAction action;
  final Map data;

  const CreateEditPageData({
    this.action = CreateEditPageAction.create,
    this.data = const {},
  });

  FT getField<FT>(String name) => data[name] as FT;
}

enum CreateEditPageAction {
  create,
  edit;

  bool get isCreate => this == create;
  bool get isEdit => this == edit;

  @override
  String toString() => this == edit ? 'Edit' : 'Create';
}
