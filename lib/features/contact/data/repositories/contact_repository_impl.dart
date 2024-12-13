import 'package:fpdart/fpdart.dart';

import '../../../../core/common/dtos/message_response.dart';
import '../../../../core/common/dtos/pagination_response.dart';
import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../models/contact.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;

  const ContactRepositoryImpl(
    this.connectionChecker,
    this.apiService,
  );

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts(int page) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response =
          await apiService.get(endPoint: "contacts", params: {'page': page});
      if (response.statusCode == 200) {
        final data = PaginationResponseDto.fromJson(response.data);
        List<ContactEntity> contactList = [];
        for (var contact in data.body) {
          contactList.add(ContactModel.fromJson(contact));
        }
        return Right(contactList);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> getSearchData() async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.get(endPoint: "contacts/search-data");
      if (response.statusCode == 200) {
        List<ContactEntity> contactList = [];
        for (var contact in response.data) {
          contactList.add(ContactModel.fromJson(contact));
        }
        return Right(contactList);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> searchContacts(
      List<int> idList) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService
          .get(endPoint: "contacts/id-list", data: {'idList': idList});

      if (response.statusCode == 200) {
        List<ContactEntity> contactList = [];
        for (var contact in response.data) {
          contactList.add(ContactModel.fromJson(contact));
        }
        return Right(contactList);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> createContact(
      ContactEntity contact) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.post(
          endPoint: "contacts",
          data: ContactModel.fromEntity(contact).toJson());
      if (response.statusCode == 201) {
        ContactEntity createdContact = ContactModel.fromJson(response.data);
        return Right(createdContact);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> updateContact(
      ContactEntity contact) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.patch(
          endPoint: "contacts/${contact.id}",
          data: ContactModel.fromEntity(contact).toJson());
      if (response.statusCode == 200) {
        ContactEntity updatedContact = ContactModel.fromJson(response.data);
        return Right(updatedContact);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, String>> deleteContact(int id) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      final response = await apiService.delete(endPoint: "contacts/$id");
      if (response.statusCode == 200) {
        return Right(MessageResponseDto.fromJson(response.data).msg);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
