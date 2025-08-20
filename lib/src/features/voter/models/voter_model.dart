class VoterModel {
  final int id;
  final String fullName;
  final String phone;
  final String yearOfBirth;
  final String? cardImage;
  final String? imagePath;
  final int isCardUpdated;
  final int sideId;
  final SideModel side;
  final int pollingCenterId;
  final PollingCenterModel pollingCenter;
  final int areaId;
  final AreaModel area;
  final bool isVoted;
  final int isActive;
  final String lastTimeActive;
  final String lat;
  final String lng;
  final String createdAt;
  final String updatedAt;

  VoterModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.yearOfBirth,
    this.cardImage,
    this.imagePath,
    required this.isCardUpdated,
    required this.sideId,
    required this.side,
    required this.pollingCenterId,
    required this.pollingCenter,
    required this.areaId,
    required this.area,
    required this.isVoted,
    required this.isActive,
    required this.lastTimeActive,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VoterModel.fromJson(Map<String, dynamic> json) {
    return VoterModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      yearOfBirth: json['year_of_birth'] ?? '',
      cardImage: json['card_image'],
      imagePath: json['image_path'],
      isCardUpdated: json['is_card_updated'] ?? 0,
      sideId: json['side_id'] ?? 0,
      side: SideModel.fromJson(json['side'] ?? {}),
      pollingCenterId: json['polling_center_id'] ?? 0,
      pollingCenter: PollingCenterModel.fromJson(json['polling_center'] ?? {}),
      areaId: json['area_id'] ?? 0,
      area: AreaModel.fromJson(json['area'] ?? {}),
      isVoted: json['is_voted'] ?? false,
      isActive: json['is_active'] ?? 0,
      lastTimeActive: json['last_time_active'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'year_of_birth': yearOfBirth,
      'card_image': cardImage,
      'image_path': imagePath,
      'is_card_updated': isCardUpdated,
      'side_id': sideId,
      'side': side.toJson(),
      'polling_center_id': pollingCenterId,
      'polling_center': pollingCenter.toJson(),
      'area_id': areaId,
      'area': area.toJson(),
      'is_voted': isVoted,
      'is_active': isActive,
      'last_time_active': lastTimeActive,
      'lat': lat,
      'lng': lng,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<VoterModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => VoterModel.fromJson(json)).toList();
  }

  VoterModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? yearOfBirth,
    String? cardImage,
    String? imagePath,
    int? isCardUpdated,
    int? sideId,
    SideModel? side,
    int? pollingCenterId,
    PollingCenterModel? pollingCenter,
    int? areaId,
    AreaModel? area,
    bool? isVoted,
    int? isActive,
    String? lastTimeActive,
    String? lat,
    String? lng,
    String? createdAt,
    String? updatedAt,
  }) {
    return VoterModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      yearOfBirth: yearOfBirth ?? this.yearOfBirth,
      cardImage: cardImage ?? this.cardImage,
      imagePath: imagePath ?? this.imagePath,
      isCardUpdated: isCardUpdated ?? this.isCardUpdated,
      sideId: sideId ?? this.sideId,
      side: side ?? this.side,
      pollingCenterId: pollingCenterId ?? this.pollingCenterId,
      pollingCenter: pollingCenter ?? this.pollingCenter,
      areaId: areaId ?? this.areaId,
      area: area ?? this.area,
      isVoted: isVoted ?? this.isVoted,
      isActive: isActive ?? this.isActive,
      lastTimeActive: lastTimeActive ?? this.lastTimeActive,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SideModel {
  final int id;
  final String name;
  final int governorateId;
  final String createdAt;
  final String updatedAt;

  SideModel({
    required this.id,
    required this.name,
    required this.governorateId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SideModel.fromJson(Map<String, dynamic> json) {
    return SideModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      governorateId: json['governorate_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'governorate_id': governorateId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PollingCenterModel {
  final int id;
  final int governorateId;
  final String governorateCode;
  final String newSubdistrict;
  final String code;
  final String name;
  final String number;
  final int stationCount;
  final String pollingCenterNameOnCard;
  final String address;
  final String actualName;
  final String actualPollingCenterAddress;
  final int sideId;
  final int areaId;
  final int isActive;
  final String lat;
  final String lng;
  final String createdAt;
  final String updatedAt;
  final String fullName;

  PollingCenterModel({
    required this.id,
    required this.governorateId,
    required this.governorateCode,
    required this.newSubdistrict,
    required this.code,
    required this.name,
    required this.number,
    required this.stationCount,
    required this.pollingCenterNameOnCard,
    required this.address,
    required this.actualName,
    required this.actualPollingCenterAddress,
    required this.sideId,
    required this.areaId,
    required this.isActive,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
    required this.fullName,
  });

  factory PollingCenterModel.fromJson(Map<String, dynamic> json) {
    return PollingCenterModel(
      id: json['id'] ?? 0,
      governorateId: json['governorate_id'] ?? 0,
      governorateCode: json['governorate_code'] ?? '',
      newSubdistrict: json['new_subdistrict'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      stationCount: json['station_count'] ?? 0,
      pollingCenterNameOnCard: json['polling_center_name_on_card'] ?? '',
      address: json['address'] ?? '',
      actualName: json['actual_name'] ?? '',
      actualPollingCenterAddress: json['actual_polling_center_address'] ?? '',
      sideId: json['side_id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      isActive: json['is_active'] ?? 0,
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'governorate_id': governorateId,
      'governorate_code': governorateCode,
      'new_subdistrict': newSubdistrict,
      'code': code,
      'name': name,
      'number': number,
      'station_count': stationCount,
      'polling_center_name_on_card': pollingCenterNameOnCard,
      'address': address,
      'actual_name': actualName,
      'actual_polling_center_address': actualPollingCenterAddress,
      'side_id': sideId,
      'area_id': areaId,
      'is_active': isActive,
      'lat': lat,
      'lng': lng,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'full_name': fullName,
    };
  }
}

class AreaModel {
  final int id;
  final String name;
  final int sideId;
  final String createdAt;
  final String updatedAt;

  AreaModel({
    required this.id,
    required this.name,
    required this.sideId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      sideId: json['side_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'side_id': sideId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
