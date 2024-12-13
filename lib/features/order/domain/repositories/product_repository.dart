import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, ProductEntity>> getProduct(int productId);
}
