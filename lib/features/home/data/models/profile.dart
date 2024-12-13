import '../../../../core/common/entities/profile.dart';
import '../../../../core/constants/constants.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    super.id,
    super.firstName,
    super.lastName,
    super.phone,
    super.address,
  });

  static const empty = ProfileModel();

  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phone: entity.phone,
        address: entity.address,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"] ?? Constants.zero,
        firstName: json["firstName"] ?? json["f_name"] ?? Constants.empty,
        lastName: json["lastName"] ?? json["l_name"] ?? Constants.empty,
        phone: json["phone"] ?? Constants.empty,
        address: json["address"] ?? Constants.empty,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "address": address,
      }..removeWhere((key, value) =>
          value == null || value == Constants.empty || value == Constants.zero);

  ProfileModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) =>
      ProfileModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
      );
}
