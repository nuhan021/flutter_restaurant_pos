import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:restaurant_pos/cubits/more_function_cubits/product_listing_cubit/product_listing_state.dart';

// product image pick cubit
class ImageCubit extends Cubit<String> {
  ImageCubit() : super('');

  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    emit(result!.files.first.path.toString());
  }
}

// select product section
class SelectProductSection extends Cubit<String> {
  SelectProductSection() : super('');

  void selectSection(String value) {
    emit(value);
  }
}

// product list cubit
class ProductListingCubit extends Cubit<ProductListingState> {
  ProductListingCubit() : super(InitialState()) {
    listProduct();
  }

  // initialize variable for foodItemBox database
  var foodItemBox = Hive.box('food_items');

  // listing all the product in food_items database
  void listProduct() {
    //get all data from foodItemBox database
    var productList = foodItemBox.values.toList();
    // emit ProductDisplaySuccessState with productList
    emit(ProductDisplaySuccessState(productList: productList));
  }

  // add the food product to the food_items database
  void addProduct(
      {required String title,
      required String price,
      required String imgUrl,
      required String section}) async {
    //make condition for empty error
    if (title == '' || price == '' || imgUrl == '' || section == '') {
      emit(ProductListingErrorState());
    } else {

      String imagePath = imgUrl;
      // Specify the destination directory
      String destinationDirectory = '${Directory.current.path}/food_images';

      // Ensure the destination directory exists
      await Directory(destinationDirectory).create(recursive: true);

      // Extract the file name from the image path
      final fileName = imagePath.split('/').last;

      // Construct the full destination path
      String destinationPath = '$destinationDirectory/$fileName';

      // Copy the image to the destination directory
      await File(imagePath).copy(destinationPath);

      // create model for database
      Map<String, dynamic> productMap = {
        'foodName': title,
        'quantity': 1,
        'price': price,
        'foodImage': destinationPath,
        'section': section
      };

      // add the model data
      foodItemBox.add(productMap);

      // get the new data and emit
      List<dynamic> productList = foodItemBox.values.toList();

      emit(ProductListingSuccessState());
      emit(ProductDisplaySuccessState(productList: productList));
    }
  }

  // delete item from the database
  void deleteProduct(int index) async {
    // delete at the index number of the product
    Map<dynamic, dynamic> selectedProduct = foodItemBox.getAt(index);
    String imgPath = selectedProduct['foodImage'];

    foodItemBox.deleteAt(index);

    final imageFile = File(imgPath);

    try {
      await imageFile.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
    }

    // fetching new updated data
    List<dynamic> productList = foodItemBox.values.toList();

    // emit the ProductDisplaySuccessState
    emit(ProductDisplaySuccessState(productList: productList));
  }

  //update product
  void editProduct(int index, String title, String price) {
    //get the selected item data from food_items database
    Map<dynamic, dynamic> selectedItem = foodItemBox.getAt(index);

    //edit the data from ui part
    Map<String, dynamic> productMap = {
      'foodName': title,
      'quantity': selectedItem['quantity'],
      'price': price,
      'foodImage': selectedItem['foodImage'],
      'section': selectedItem['section']
    };

    //update the edited data
    foodItemBox.putAt(index, productMap).then((value) {
      emit(
          ProductDisplaySuccessState(productList: foodItemBox.values.toList()));
    });
  }

  //add section
  void addSection() async {}
}

// product section list cubit
class ProductSectionCubit extends Cubit<ProductSectionState> {
  ProductSectionCubit() : super(SectionInitialState()) {
    listSection();
  }

  // initialize variable for foodSectionBox database
  var sectionBox = Hive.box('food_section');

  // listing all the product in food_items database
  void listSection() {
    //get all data from foodSectionBox database
    var productList = sectionBox.values.toList();
    // emit SectionDisplaySuccessState with sectionList
    emit(SectionDisplaySuccessState(sectionList: productList));
  }

  // add section in foodSectionBox database
  void addSection({required String sectionName}) async {
    await sectionBox.add(sectionName);
    List sectionList = sectionBox.values.toList();
    emit(SectionDisplaySuccessState(sectionList: sectionList));
  }

  // delete section from foodSectionBox database
  void deleteSection({required int index}) async {
    await sectionBox.deleteAt(index);
    List sectionList = sectionBox.values.toList();
    emit(SectionDisplaySuccessState(sectionList: sectionList));
  }
  
}
