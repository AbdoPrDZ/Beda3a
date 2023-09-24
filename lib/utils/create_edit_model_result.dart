class CreateEditModelResult<Model> {
  final bool success;
  final String? message, fieldError;
  final Model? model;

  const CreateEditModelResult(
    this.success, {
    this.message,
    this.fieldError,
    this.model,
  });

  @override
  String toString() =>
      "CreateEditModelResult<$Model>(\n  success: $success\n  message: $message\n  fieldError: $fieldError\n  model: $model\n)";
}
