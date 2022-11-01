import 'package:flutter/foundation.dart';
import 'package:line_management/model/shop.dart';
import '../services/shopServices.dart';

class ShopProvider with ChangeNotifier {
  ShopService _shopService = ShopService();
  bool shopSelected = false;
  int idShopSelected = 0;
  List<Shop> shops = [];

  void setshopSelected(bool sel) {
    shopSelected = sel;
    notifyListeners();
  }

  ShopProvider.init() {
    loadAllShops();
  }

  Future<List<Shop>> allShopsFromPlY() async {
    List<Shop> shopsOfAMun = [];
    shopsOfAMun = await _shopService.allShopsGivenAMun();
    notifyListeners();
    return shopsOfAMun;
  }

  Future<List<Shop>> loadAllShops() async {
    shops = await _shopService.loadAllShops();
    notifyListeners();
    return shops;
  }

  void initShopList(Future<List<Shop>> bdShops) async {
    shops = await bdShops;
  }

  void idNomShop(String nameShop) {
    for (var item in shops) {
      if (item.name == nameShop) {
        idShopSelected = item.idMunicipio;
      }
    }
  }

  ShopProvider();
}
