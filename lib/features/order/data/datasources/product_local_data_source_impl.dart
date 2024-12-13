import 'package:hive/hive.dart';

import '../models/product.dart';

abstract interface class ProductLocalDataSource {
  void uploadLocalProduct({required ProductModel product});

  ProductModel loadProduct(String id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl(this.box);

  @override
  ProductModel loadProduct(String id) {
    var product = box.get(id);
    return product != null
        ? ProductModel.fromJson(product)
        : ProductModel.empty;
  }

  @override
  void uploadLocalProduct({required ProductModel product}) {
    box.put(product.id.toString(), product.toJson());
  }
}
