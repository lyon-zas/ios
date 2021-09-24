import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/entity/wishlist.dart';
import 'package:tritek_lms/data/repository/wishlist.repository.dart';
import 'package:tritek_lms/http/wishlist.provider.dart';

class WishlistBloc {
  final WishListRepository _repository = WishListRepository();
  final BehaviorSubject<WishListResponse> _listSubject =
      BehaviorSubject<WishListResponse>();

  getList() async {
    WishListResponse response = await _repository.getList();
    if (_listSubject.isClosed) {
      return;
    }
    _listSubject.sink.add(response);
  }

  delete(WishList list) async {
    await _repository.deleteList(list);
    getList();
  }

  dispose() {
    _listSubject.close();
  }

  BehaviorSubject<WishListResponse> get list => _listSubject;
}

final wishListBloc = WishlistBloc();
