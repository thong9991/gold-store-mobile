import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class LoadProduct implements UseCase<ProductEntity, int> {
  final ProductRepository productRepository;

  const LoadProduct(this.productRepository);

  @override
  Future<Either<Failure, ProductEntity>> call(int productId) async {
    return await productRepository.getProduct(productId);
  }
}
