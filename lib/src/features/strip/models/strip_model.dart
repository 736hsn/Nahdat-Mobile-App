import '../../voter/models/voter_model.dart';

class StripModel {
  final int id;
  final int pollingCenterId;
  final PollingCenterModel pollingCenter;
  final List<String> images;
  final String createdAt;
  final String updatedAt;

  StripModel({
    required this.id,
    required this.pollingCenterId,
    required this.pollingCenter,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StripModel.fromJson(Map<String, dynamic> json) {
    return StripModel(
      id: json['id'] ?? 0,
      pollingCenterId: json['polling_center_id'] ?? 0,
      pollingCenter: PollingCenterModel.fromJson(json['polling_center'] ?? {}),
      images: List<String>.from(json['images'] ?? []),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'polling_center_id': pollingCenterId,
      'polling_center': pollingCenter.toJson(),
      'images': images,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<StripModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StripModel.fromJson(json)).toList();
  }

  StripModel copyWith({
    int? id,
    int? pollingCenterId,
    PollingCenterModel? pollingCenter,
    List<String>? images,
    String? createdAt,
    String? updatedAt,
  }) {
    return StripModel(
      id: id ?? this.id,
      pollingCenterId: pollingCenterId ?? this.pollingCenterId,
      pollingCenter: pollingCenter ?? this.pollingCenter,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
