import 'package:core/models/order_model.dart';
import 'package:core/repositories/order_repository.dart';
import 'package:eazy_order_pro/feature/catalog/entity/order_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'orderlist_controller.g.dart';

@Riverpod(keepAlive: true)
class OrderListController extends _$OrderListController {
  @override
  OrderEntity build() {
    return OrderEntity();
  }


  Future<void> getorder(String businessId) async {
    state = state.copyWith(isLoading: true);
    final orderrepo = ref.read(orderRepositoryProvider);
    final result = await orderrepo.getOrders(businessId);             //now result store getOrder(businessId), so result is fetch data from firestore after fetching the data await function stop this fetching process ..
    state = state.copyWith(orderslist: result, isLoading: false);     //orderlist preserve the <OrderModel> so state will update the orderModel by result variable ...
  }

  Future<void> orderUpdate(OrderModel model) async {
    state = state.copyWith(isLoading: true);
    final orderrepo = ref.read(orderRepositoryProvider);

    await orderrepo.updateOrder(model);

    final updatedlist = state.orderlist.map((order) {
          if (order.orderId == model.orderId) {
            return model;
          }
          return order;
        }).toList();

    state = state.copyWith(
      isLoading: false,
      orderId: model.orderId,
      isEdit: true,
      orderslist: updatedlist,
      editableQty: {},
    );
    Fluttertoast.showToast(msg: "order updated successfully");
  }

  void setEditableQty(String orderId, List<OrderItems> orderitems) {          //start to edit quantity....
    if (state.orderId == orderId && state.editableQty.isNotEmpty) {
      return;
    }
    state = state.copyWith(
      orderId: orderId,
      editableQty: {
        for (final items in orderitems) items.orderItemId: items.quantity,
      },
    );
  }

  void increaseQty(String ItemId) {
    final currentqty = state.editableQty[ItemId] ?? 1;
    state = state.copyWith(
      editableQty: {...state.editableQty, ItemId: currentqty + 1},
    );
  }

  void decreaseQty(String ItemId) {
    final currentqty = state.editableQty[ItemId] ?? 1;
    if (currentqty <= 0) return;
    state = state.copyWith(
      editableQty: {...state.editableQty, ItemId: currentqty - 1},   //...state.editableQty is for merge quantity (old+new)
    );
  }

  void setEditOrder(OrderModel order) {
    final map = {
      for (final item in order.items) item.orderItemId: item.quantity
    };

    state = state.copyWith(
      editableQty: map,
      orderId: order.orderId,
    );
  }

  List<OrderItems> mergeItems(           //this is for merge the item which is add new item from productlisting screen, thi swill add in this orderdetail screen
    List<OrderItems> oldItems,
    List<OrderItems> newItems,
  ) {
    final map = <String, OrderItems>{};

    for (final item in oldItems) {
      map[item.orderItemId] = item;
    }

    for (final item in newItems) {
      if (map.containsKey(item.orderItemId)) {
        map[item.orderItemId]!.quantity += item.quantity;
      } else {
        map[item.orderItemId] = item;
      }
    }
    return map.values.toList();
  }
  void selectedtab(int index){
    state = state.copyWith(
      selectTab: index
    );
  }
  String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM, yyyy').format(dateTime);
  }
}
