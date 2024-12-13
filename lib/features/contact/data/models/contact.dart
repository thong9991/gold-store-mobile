import '../../../../core/constants/constants.dart';
import '../../domain/entities/contact.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    super.id,
    super.name,
    super.phoneType,
    super.phone,
    super.description,
    super.createdAt,
    super.updatedAt,
  });

  static const empty = ContactModel();

  factory ContactModel.fromEntity(ContactEntity entity) => ContactModel(
        id: entity.id,
        name: entity.name,
        phoneType: entity.phoneType,
        phone: entity.phone,
        description: entity.description,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json["id"] ?? Constants.zero,
        name: json["name"] ?? Constants.empty,
        phoneType: json["phoneType"] ?? json["phone_type"] ?? Constants.empty,
        phone: json["phone"] ?? Constants.empty,
        description: json["description"] ?? Constants.empty,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : json["updated_at"] != null
                ? DateTime.parse(json["updated_at"])
                : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneType": phoneType,
        "phone": phone,
        "description": description,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      }..removeWhere((key, value) =>
          value == null ||
          value == Constants.zero ||
          (value == Constants.empty && key != "description"));

  ContactModel copyWith({
    int? id,
    String? name,
    String? phoneType,
    String? phone,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      ContactModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneType: phoneType ?? this.phoneType,
        phone: phone ?? this.phone,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
