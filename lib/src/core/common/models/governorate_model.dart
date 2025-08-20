class GovernorateModel {
  final String id;
  final String name;

  GovernorateModel({required this.name, required this.id});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'id': id};
  }
}
