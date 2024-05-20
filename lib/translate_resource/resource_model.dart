class ResourceModel {
  final int? created_at;
  final int? updated_at;
  final String? resource_id;
  final String? module_id;
  final String? value;
  final String? language_id;

  ResourceModel({
    this.created_at,
    this.updated_at,
    this.resource_id,
    this.module_id,
    this.value,
    this.language_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'created_at': created_at,
      'updated_at': updated_at,
      'resource_id': resource_id,
      'module_id': module_id,
      'value': value,
      'language_id': language_id,
    };
  }

  factory ResourceModel.fromMap(Map<String, dynamic> map) {
    return ResourceModel(
      created_at: map['created_at'],
      updated_at: map['updated_at'],
      resource_id: map['resource_id'],
      module_id: map['module_id'],
      value: map['value'],
      language_id: map['language_id'],
    );
  }
}
