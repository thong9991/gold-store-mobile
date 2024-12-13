import '../../../../core/constants/constants.dart';

class ContactEntity {
  final int id;
  final String name;
  final String phoneType;
  final String phone;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ContactEntity({
    this.id = Constants.zero,
    this.name = Constants.empty,
    this.phoneType = Constants.empty,
    this.phone = Constants.empty,
    this.description = Constants.empty,
    this.createdAt,
    this.updatedAt,
  });
}
