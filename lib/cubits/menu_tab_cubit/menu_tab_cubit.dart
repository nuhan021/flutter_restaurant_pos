import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:restaurant_pos/cubits/menu_tab_cubit/menu_tab_state.dart';

class FoodMenuTabCubit extends Cubit<MenuTabState> {
  FoodMenuTabCubit() : super(MenuTabInitialState()) {
    getFoodSectionAndFoodItems();
  }

  // initialize variable for foodItemBox database
  var foodItemBox = Hive.box('food_items');

  // initialize variable for foodSectionBox database
  var sectionBox = Hive.box('food_section');

  // initialize variable for tableListBox database
  var tableListBox = Hive.box('res_table');
  // get the all list of food sections, food items and tables and emit MenuTabGetFoodSectionState with those data
  void getFoodSectionAndFoodItems() {
    List<dynamic> foodSectionList = sectionBox.values.toList();
    List<dynamic> foodItemList = foodItemBox.values.toList();
    List<dynamic> tableList = tableListBox.values.toList();
    emit(MenuTabGetFoodSectionState(
        foodSection: foodSectionList,
        foodList: foodItemList,
        tableList: tableList));
  }

  // add food to the selected table
  void addTableFood(
      {required var index,
      required String foodName,
      required String price,
      required String foodImage}) {
    if (index == null) {
      // nothing to do
    } else {
      // get the selected table data
      Map<dynamic, dynamic> selectedTableData = tableListBox.getAt(index);
      // get the order list from selectedTabData
      List<dynamic> orderList = selectedTableData['orderList'];

      if (orderList.isNotEmpty) {
        // if order list has data
        // check the entire order list before add new order that given order has already exist or not using for loop
        bool foodExist = false;

        for (int i = 0; i < orderList.length; i++) {
          String orderListFoodName = orderList[i]['foodName'];
          String orderListPrice = orderList[i]['price'];
          String orderListFoodImage = orderList[i]['foodImage'];
          int orderListFoodQuantity = orderList[i]['quantity'];
          int orderListTotalPrice = orderList[i]['totalPrice'];
          //check foodName, price & foodImage are match the orderList objects foodName,price & foodImage
          if (orderListFoodName == foodName &&
              orderListPrice == price &&
              orderListFoodImage == foodImage) {
            // remove old food object at the index of i
            orderList.removeAt(i);
            // insert new food object at the index of i
            orderList.insert(
              i,
              {
                'foodName': foodName,
                'quantity': orderListFoodQuantity + 1,
                'price': price,
                'totalPrice': orderListTotalPrice + int.parse(price),
                'foodImage': foodImage
              },
            );
            // add the previous title , image, gust number and add the updated order list
            Map<String, dynamic> tableData = {
              'title': selectedTableData['title'],
              'img': selectedTableData['img'],
              'guest': selectedTableData['guest'],
              'orderList': orderList,
              'isOrderSent': false
            };

            // update the entire table data at the index of the table
            tableListBox.putAt(index, tableData);

            // get food section data,food list data & table list data
            List<dynamic> foodSectionList = sectionBox.values.toList();
            List<dynamic> foodItemList = foodItemBox.values.toList();
            List<dynamic> tableList = tableListBox.values.toList();

            foodExist = true;

            // emit the MenuTabGetFoodSectionState state
            emit(MenuTabGetFoodSectionState(
                foodSection: foodSectionList,
                foodList: foodItemList,
                tableList: tableList));
            break;
          }
        }

        if (foodExist == false) {
          // if foodExist variable is false then add the new order to the orderlist
          // add the food object to the orderList
          orderList.add(
            {
              'foodName': foodName,
              'quantity': 1,
              'price': price,
              'totalPrice': int.parse(price),
              'foodImage': foodImage
            },
          );
          // add the previous title , image, gust number and add the updated order list
          Map<String, dynamic> tableData = {
            'title': selectedTableData['title'],
            'img': selectedTableData['img'],
            'guest': selectedTableData['guest'],
            'orderList': orderList,
            'isOrderSent': false
          };
          // update the entire table data at the index of the table
          tableListBox.putAt(index, tableData);
          // get food section data,food list data & table list data
          List<dynamic> foodSectionList = sectionBox.values.toList();
          List<dynamic> foodItemList = foodItemBox.values.toList();
          List<dynamic> tableList = tableListBox.values.toList();

          // emit the MenuTabAddFoodSuccessState state
          emit(MenuTabGetFoodSectionState(
              foodSection: foodSectionList,
              foodList: foodItemList,
              tableList: tableList));
        }
      } else {
        // if order list has no data
        // add the food object to the orderList or update order list
        orderList.add(
          {
            'foodName': foodName,
            'quantity': 1,
            'price': price,
            'totalPrice': int.parse(price),
            'foodImage': foodImage
          },
        );
        // add the previous title , image, gust number and add the updated order list
        Map<String, dynamic> tableData = {
          'title': selectedTableData['title'],
          'img': selectedTableData['img'],
          'guest': selectedTableData['guest'],
          'orderList': orderList,
          'isOrderSent': false
        };
        // update the entire table data at the index of the table
        tableListBox.putAt(index, tableData);

        // get food section data,food list data & table list data
        List<dynamic> foodSectionList = sectionBox.values.toList();
        List<dynamic> foodItemList = foodItemBox.values.toList();
        List<dynamic> tableList = tableListBox.values.toList();

        // emit the MenuTabAddFoodSuccessState state
        emit(MenuTabGetFoodSectionState(
            foodSection: foodSectionList,
            foodList: foodItemList,
            tableList: tableList));
      }
    }
  }

  // remove the food item from the order list
  void removeTableFood({required int index, required int selectedTableIndex}) {
    // initialize the table list data
    var tableListBox = Hive.box('res_table');

    //get the selected table data
    Map<dynamic, dynamic> selectedTableData =
        tableListBox.getAt(selectedTableIndex);

    // get the full order list of selected table orderList
    List<dynamic> orderList = selectedTableData['orderList'];

    // get the selected food item from selected table order list
    Map<dynamic, dynamic> selectedFoodItem = orderList[index];

    // if quantity > 1 then decrease quantity of the selected food item
    if (selectedFoodItem['quantity'] > 1) {
      // decrease quantity number of the selected food item
      Map<dynamic, dynamic> updatedFoodItemMap = {
        'foodName': selectedFoodItem['foodName'],
        'quantity': selectedFoodItem['quantity'] - 1,
        'price': selectedFoodItem['price'],
        'totalPrice': selectedFoodItem['totalPrice'] -
            int.parse(selectedFoodItem['price']),
        'foodImage': selectedFoodItem['foodImage']
      };

      // remove the old food item map and add updated food item map
      orderList.removeAt(index);
      // add updated food item map at the index
      orderList.insert(index, updatedFoodItemMap);

      // update the entire table data at the index of the selectedTableIndex
      Map<dynamic, dynamic> newTableData = {
        'title': selectedTableData['title'],
        'img': selectedTableData['img'],
        'guest': selectedTableData['guest'],
        'orderList': orderList,
        'isOrderSent': false
      };

      // update the entire table data at the index of the table
      tableListBox.putAt(selectedTableIndex, newTableData);

      // get food section data,food list data & table list data
      List<dynamic> foodSectionList = sectionBox.values.toList();
      List<dynamic> foodItemList = foodItemBox.values.toList();
      List<dynamic> tableList = tableListBox.values.toList();

      // emit the MenuTabAddFoodSuccessState state
      emit(MenuTabGetFoodSectionState(
          foodSection: foodSectionList,
          foodList: foodItemList,
          tableList: tableList));
    } else {
      // remove the food item map from the order list
      orderList.removeAt(index);

      // update the entire table data at the index of the selectedTableIndex
      Map<dynamic, dynamic> newTableData = {
        'title': selectedTableData['title'],
        'img': selectedTableData['img'],
        'guest': selectedTableData['guest'],
        'orderList': orderList,
        'isOrderSent': false
      };

      // update the entire table data at the index of the table
      tableListBox.putAt(selectedTableIndex, newTableData);

      // get food section data,food list data & table list data
      List<dynamic> foodSectionList = sectionBox.values.toList();
      List<dynamic> foodItemList = foodItemBox.values.toList();
      List<dynamic> tableList = tableListBox.values.toList();

      // emit the MenuTabAddFoodSuccessState state
      emit(MenuTabGetFoodSectionState(
          foodSection: foodSectionList,
          foodList: foodItemList,
          tableList: tableList));
    }
  }

  // increase the quantity number of the selected food item map
  void increaseFoodItem({required int index, required int selectedTableIndex}) {
    //get the selected table data
    Map<dynamic, dynamic> selectedTableData =
        tableListBox.getAt(selectedTableIndex);
    // get the full order list of selected table orderList
    List<dynamic> orderList = selectedTableData['orderList'];
    // get the selected food item from selected table order list
    Map<dynamic, dynamic> selectedFoodItem = orderList[index];

    // increase quantity number of the selected food item
    Map<dynamic, dynamic> updatedFoodItemMap = {
      'foodName': selectedFoodItem['foodName'],
      'quantity': selectedFoodItem['quantity'] + 1,
      'price': selectedFoodItem['price'],
      'totalPrice':
          selectedFoodItem['totalPrice'] + int.parse(selectedFoodItem['price']),
      'foodImage': selectedFoodItem['foodImage']
    };

    // remove the old food item map and add updated food item map
    orderList.removeAt(index);
    // add updated food item map at the index
    orderList.insert(index, updatedFoodItemMap);

    // update the entire table data at the index of the selectedTableIndex
    Map<dynamic, dynamic> newTableData = {
      'title': selectedTableData['title'],
      'img': selectedTableData['img'],
      'guest': selectedTableData['guest'],
      'orderList': orderList,
      'isOrderSent': false
    };

    // update the entire table data at the index of the table
    tableListBox.putAt(selectedTableIndex, newTableData);

    // get food section data,food list data & table list data
    List<dynamic> foodSectionList = sectionBox.values.toList();
    List<dynamic> foodItemList = foodItemBox.values.toList();
    List<dynamic> tableList = tableListBox.values.toList();

    // emit the MenuTabAddFoodSuccessState state
    emit(MenuTabGetFoodSectionState(
        foodSection: foodSectionList,
        foodList: foodItemList,
        tableList: tableList));
  }

  //void send order
  void sendOrder({required int selectedTableIndex}) async {
    //get the selected table data
    Map<dynamic, dynamic> selectedTableData = tableListBox.getAt(selectedTableIndex);
    // update the entire table data at the index of the selectedTableIndex
    Map<dynamic, dynamic> newTableData = {
      'title': selectedTableData['title'],
      'img': selectedTableData['img'],
      'guest': selectedTableData['guest'],
      'orderList': selectedTableData['orderList'],
      'isOrderSent': true
    };
    // update the entire table data at the index of the table
    await tableListBox.putAt(selectedTableIndex, newTableData);
  }

  void cancelOrder({required int selectedTableIndex}) async {
    //get the selected table data
    Map<dynamic, dynamic> selectedTableData = tableListBox.getAt(selectedTableIndex);

    Map<dynamic, dynamic> newTableData = {
      'title': selectedTableData['title'],
      'img': selectedTableData['img'],
      'guest': 0,
      'orderList': [],
      'isOrderSent': false
    };

    // update the entire table data at the index of the table
    tableListBox.putAt(selectedTableIndex, newTableData);
  }
}
