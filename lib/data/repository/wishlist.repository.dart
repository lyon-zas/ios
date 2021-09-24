import 'package:tritek_lms/data/entity/wishlist.dart';
import 'package:tritek_lms/http/wishlist.provider.dart';

class WishListRepository {
  final _apiProvider = WishListApiProvider();

  Future<WishListResponse> getList() async {
    return await _apiProvider.getList();
  }

  Future<void> deleteList(WishList list) async {
    await _apiProvider.deleteList(list);
  }
}
