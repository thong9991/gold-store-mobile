import 'package:fpdart/fpdart.dart';

import '../../../../core/enum/data_source.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/connection_checker.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source_impl.dart';
import '../models/product.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ConnectionChecker connectionChecker;
  final ApiService apiService;
  final ProductLocalDataSource productLocalDataSource;

  const ProductRepositoryImpl(
      this.connectionChecker, this.apiService, this.productLocalDataSource);

  @override
  Future<Either<Failure, ProductEntity>> getProduct(int productId) async {
    if (!(await connectionChecker.isConnected)) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }

    try {
      ProductModel product =
          productLocalDataSource.loadProduct(productId.toString());

      if (product != ProductModel.empty) {
        return Right(product);
      }

      final response = await apiService.get(endPoint: "products/$productId");

      if (response.statusCode == 200) {
        ProductModel product = ProductModel.fromJson(response.data);
        productLocalDataSource.uploadLocalProduct(product: product);
        return Right(product);
      } else {
        return Left(ErrorHandler.handle(response.toDioException()).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
