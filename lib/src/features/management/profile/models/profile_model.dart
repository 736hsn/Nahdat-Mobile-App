// class ProfileModel {
//   final String id;
//   final String name;
//   final String businessName;
//   final String phone;
//   final String image;
//   final String createdAt;
//   final String updatedAt;
//   final AccountModel account;

//   ProfileModel({
//     required this.id,
//     required this.name,
//     required this.businessName,
//     required this.phone,
//     required this.image,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.account,
//   });

//   factory ProfileModel.empty() => ProfileModel(
//     id: '',
//     name: '',
//     businessName: '',
//     phone: '',
//     image: '',
//     createdAt: '',
//     updatedAt: '',
//     account: AccountModel.empty(),
//   );

//   factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
//     id: json["id"] ?? '',
//     name: json["name"] ?? '',
//     businessName: json["business_name"] ?? '',
//     phone: json["phone"] ?? '',
//     image: json["image"] ?? '',
//     createdAt: json["created_at"] ?? '',
//     updatedAt: json["updated_at"] ?? '',
//     account: AccountModel.fromJson(json["account"] ?? {}),
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "business_name": businessName,
//     "phone": phone,
//     "image": image,
//     "created_at": createdAt,
//     "updated_at": updatedAt,
//     "account": account.toJson(),
//   };
// }
