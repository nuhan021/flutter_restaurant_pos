import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/more_function_cubits/product_listing_cubit/product_listing_cubit.dart';
import 'package:restaurant_pos/cubits/more_function_cubits/product_listing_cubit/product_listing_state.dart';

List<dynamic> productList = [];

class ProductListing extends StatelessWidget {
  ProductListing({super.key});

  String selectedSection = '';
  String productImgUrl = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController sectionController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void myFun(int index, String title, String price) {
      BlocProvider.of<ProductListingCubit>(context)
          .editProduct(index, title, price);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orange.shade100),
        title: Text(
          'PRODUCT LISTING',
          style: GoogleFonts.varelaRound(
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade100,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.grey.shade600)),
          child: Row(
            children: [
              // all products show
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: BlocBuilder<ProductListingCubit, ProductListingState>(
                    builder: (context, state) {
                      if (state is ProductDisplaySuccessState) {
                        productList = state.productList.toList();
                        return GridView.builder(
                          itemCount: productList.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 280,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.2 / 1.8,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[600],
                              ),
                              child: Column(
                                children: [
                                  // food image
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(productList[index]
                                                  ['foodImage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  ),

                                  // food details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // food name
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    productList[index]
                                                        ['foodName'],
                                                    style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 19,
                                                            color: Colors
                                                                .orange.shade100),
                                                  ),
                                                ),

                                                // edite button
                                                IconButton(
                                                  onPressed: () {
                                                    editTitleController.text =
                                                        productList[index]
                                                            ['foodName'];
                                                    editPriceController.text =
                                                        productList[index]
                                                            ['price'];
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          elevation: 7,
                                                          actionsPadding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          title: Text(
                                                            'Edit',
                                                            style: GoogleFonts
                                                                .varelaRound(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.orange
                                                                  .shade100,
                                                            ),
                                                          ),
                                                          content: SizedBox(
                                                            height: 150,
                                                            child: Column(
                                                              children: [
                                                                // food name
                                                                TextField(
                                                                  controller:
                                                                      editTitleController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          label: const Text(
                                                                              'Food name'),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  12),
                                                                              borderSide: BorderSide(
                                                                                  color: Colors
                                                                                      .orange.shade100)),
                                                                          enabled:
                                                                              true,
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(12),
                                                                              borderSide: BorderSide(color: Colors.orange.shade100)),
                                                                          prefixIcon: Icon(
                                                                            Icons
                                                                                .title,
                                                                            color: Colors
                                                                                .orange
                                                                                .shade100,
                                                                          )),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                // food price
                                                                TextField(
                                                                  controller:
                                                                      editPriceController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          label: const Text(
                                                                              'Price'),
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(
                                                                                  12),
                                                                              borderSide: BorderSide(
                                                                                  color: Colors
                                                                                      .orange.shade100)),
                                                                          enabled:
                                                                              true,
                                                                          enabledBorder: OutlineInputBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(12),
                                                                              borderSide: BorderSide(color: Colors.orange.shade100)),
                                                                          prefixIcon: Icon(
                                                                            Icons
                                                                                .attach_money_outlined,
                                                                            color: Colors
                                                                                .orange
                                                                                .shade100,
                                                                          )),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: const Text(
                                                                    'OK')),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  myFun(
                                                                      index,
                                                                      editTitleController
                                                                          .text
                                                                          .toString(),
                                                                      editPriceController
                                                                          .text
                                                                          .toString());
                                                                },
                                                                child: const Text(
                                                                    'UPDATE'))
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 17,
                                                  ),
                                                )
                                              ],
                                            ),

                                            // food category
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text('PRICE: '),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          '\$ ${productList[index]['price']}',
                                                          style: GoogleFonts
                                                              .varelaRound(
                                                                  fontSize: 19,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .orange
                                                                      .shade100),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                        'SEC: ${productList[index]['section']}')
                                                  ],
                                                ),

                                                // delete button

                                              ],
                                            ),

                                            const SizedBox(height: 15,),
                                            ElevatedButton(
                                                onPressed: () {
                                                  BlocProvider.of<
                                                      ProductListingCubit>(
                                                      context)
                                                      .deleteProduct(index);
                                                },
                                                style:
                                                ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    Colors.redAccent),
                                                child: const Text('Delete'))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return GridView.builder(
                        itemCount: productList.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.2 / 1.8,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[600],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // food image
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.file(
                                              File(productList[index]
                                                  ['foodImage']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  ),

                                  // food details
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          // food name
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  productList[index]['foodName'],
                                                  style: GoogleFonts.varelaRound(
                                                      fontSize: 19,
                                                      color:
                                                          Colors.orange.shade100),
                                                ),
                                              ),

                                              // edite button
                                              IconButton(
                                                onPressed: () {
                                                  editTitleController.text =
                                                      productList[index]
                                                          ['foodName'];
                                                  editPriceController.text =
                                                      productList[index]['price'];
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        elevation: 7,
                                                        actionsPadding:
                                                            const EdgeInsets.all(
                                                                20),
                                                        title: Text(
                                                          'Edit',
                                                          style: GoogleFonts
                                                              .varelaRound(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .orange.shade100,
                                                          ),
                                                        ),
                                                        content: SizedBox(
                                                          height: 150,
                                                          child: Column(
                                                            children: [
                                                              // food name
                                                              TextField(
                                                                controller:
                                                                    editTitleController,
                                                                decoration:
                                                                    InputDecoration(
                                                                        label: const Text(
                                                                            'Food name'),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .orange.shade100)),
                                                                        enabled:
                                                                            true,
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .orange.shade100)),
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .title,
                                                                          color: Colors
                                                                              .orange
                                                                              .shade100,
                                                                        )),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              // food price
                                                              TextField(
                                                                controller:
                                                                    editPriceController,
                                                                decoration:
                                                                    InputDecoration(
                                                                        label: const Text(
                                                                            'Price'),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .orange.shade100)),
                                                                        enabled:
                                                                            true,
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                12),
                                                                            borderSide: BorderSide(
                                                                                color: Colors
                                                                                    .orange.shade100)),
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .attach_money_outlined,
                                                                          color: Colors
                                                                              .orange
                                                                              .shade100,
                                                                        )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'OK')),
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                myFun(
                                                                    index,
                                                                    editTitleController
                                                                        .text
                                                                        .toString(),
                                                                    editPriceController
                                                                        .text
                                                                        .toString());
                                                              },
                                                              child: const Text(
                                                                  'UPDATE'))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  size: 17,
                                                ),
                                              )
                                            ],
                                          ),

                                          // food category
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text('PRICE: '),
                                                      const SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '\$ ${productList[index]['price']}',
                                                        style: GoogleFonts
                                                            .varelaRound(
                                                                fontSize: 19,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .orange
                                                                    .shade100),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                      'SEC: ${productList[index]['section']}')
                                                ],
                                              ),

                                              // delete button

                                            ],
                                          ),

                                          ElevatedButton(
                                              onPressed: () {
                                                BlocProvider.of<
                                                    ProductListingCubit>(
                                                    context)
                                                    .deleteProduct(index);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  Colors.redAccent),
                                              child: const Text('Delete'))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // add product & section
              Container(
                padding: const EdgeInsets.all(13),
                width: 400,
                height: double.infinity,
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(
                  color: Colors.grey.shade600,
                ))),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // add product text
                      Text(
                        'Add product',
                        style: GoogleFonts.varelaRound(
                            fontSize: 22, color: Colors.orange.shade100),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // add product text field & product image
                      Column(
                        children: [
                          // add product title
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                label: const Text('Product Title'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.orange.shade100)),
                                enabled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.orange.shade100)),
                                prefixIcon: Icon(
                                  Icons.title,
                                  color: Colors.orange.shade100,
                                )),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // add product price
                          TextField(
                            controller: priceController,
                            decoration: InputDecoration(
                                label: const Text('Product Price'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.orange.shade100)),
                                enabled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.orange.shade100)),
                                prefixIcon: Icon(
                                  Icons.attach_money,
                                  color: Colors.orange.shade100,
                                )),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // add product image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Pick a food image :',
                                  style: GoogleFonts.varelaRound(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<ImageCubit>(context)
                                      .pickImage();
                                },
                                child: BlocBuilder<ImageCubit, String>(
                                  builder: (context, state) {
                                    if (state == '') {
                                      return Container(
                                          height: 200,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.orange.shade100),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              child: Image.asset(
                                                'assets/icons/fast-food.png',
                                                fit: BoxFit.cover,
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ));
                                    }

                                    productImgUrl = state.toString();
                                    return Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.orange.shade100),
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              child: Image.file(
                                                File(state.toString()),
                                                fit: BoxFit.cover,
                                              )),
                                        ));
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),

                      // add product section
                      Text(
                        'Add food section :',
                        style: GoogleFonts.varelaRound(
                            fontSize: 17, color: Colors.orange.shade100),
                      ),
                      SizedBox(
                        height: 200,
                        child: BlocBuilder<ProductSectionCubit,
                            ProductSectionState>(
                          builder: (context, state) {
                            if (state is SectionDisplaySuccessState) {
                              List sectionList = state.sectionList;
                              return ListView.builder(
                                itemCount: sectionList.length,
                                itemBuilder: (context, index) {
                                  return BlocBuilder<SelectProductSection,
                                      String>(
                                    builder: (context, selectedItem) {
                                      selectedSection = selectedItem;
                                      return ListTile(
                                        title: Text(sectionList[index]),
                                        leading: Radio(
                                          activeColor: Colors.deepOrange,
                                          value: sectionList[index],
                                          groupValue: selectedItem,
                                          onChanged: (value) {
                                            BlocProvider.of<
                                                        SelectProductSection>(
                                                    context)
                                                .selectSection(
                                                    value.toString());
                                            selectedSection = value.toString();
                                          },
                                        ),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            BlocProvider.of<
                                                        ProductSectionCubit>(
                                                    context)
                                                .deleteSection(index: index);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // add product button button
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: BlocConsumer<ProductListingCubit,
                              ProductListingState>(
                            listener: (context, state) {
                              if (state is ProductListingErrorState) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Center(
                                      child: Text(
                                    'Something missing?',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ));
                              }
                            },
                            builder: (context, state) {
                              return ElevatedButton(
                                  onPressed: () {
                                    BlocProvider.of<ProductListingCubit>(
                                            context)
                                        .addProduct(
                                            title: titleController.text,
                                            price: priceController.text,
                                            imgUrl: productImgUrl,
                                            section: selectedSection);
                                  },
                                  child: Text(
                                    'Add Product',
                                    style:
                                        GoogleFonts.varelaRound(fontSize: 17),
                                  ));
                            },
                          )),

                      const SizedBox(
                        height: 50,
                      ),

                      // add food section
                      Text(
                        'Create new section',
                        style: GoogleFonts.varelaRound(
                            fontSize: 22, color: Colors.orange.shade100),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // section name
                      TextField(
                        controller: sectionController,
                        decoration: InputDecoration(
                            label: const Text('Section name'),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade100)),
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.orange.shade100)),
                            prefixIcon: Icon(
                              Icons.food_bank_outlined,
                              color: Colors.orange.shade100,
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      // create section button
                      SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ProductSectionCubit>(context)
                                    .addSection(
                                        sectionName: sectionController.text);
                              },
                              child: Text(
                                'Create one',
                                style: GoogleFonts.varelaRound(fontSize: 17),
                              ))),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
