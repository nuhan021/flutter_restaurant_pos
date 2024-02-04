import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_pos/cubits/employee_cubit/employee_cubit.dart';
import 'package:restaurant_pos/cubits/more_function_cubits/product_listing_cubit/product_listing_cubit.dart';
import 'package:restaurant_pos/cubits/sales_register_cubit/sales_register_cubit.dart';
import 'package:restaurant_pos/cubits/sheet_cubit/sheet_cubit.dart';
import 'package:restaurant_pos/cubits/sheet_home_cubit/sheet_home_cubit.dart';
import 'package:restaurant_pos/desktop/screens/app_lock_screen/app_lock_screen.dart';
import 'package:restaurant_pos/desktop/screens/employee_screen/employee_screen.dart';
import 'package:restaurant_pos/desktop/screens/lock_screen/lock_screen.dart';
import 'package:restaurant_pos/desktop/screens/product_listing_screen/product_listing.dart';
import 'package:restaurant_pos/desktop/screens/sales_register_screen/sales_register_screen.dart';
import 'package:restaurant_pos/desktop/screens/settings_screen/settings_screen.dart';
import 'package:restaurant_pos/desktop/screens/sheet_home/sheet_home.dart';
import 'package:restaurant_pos/desktop/screens/sheet_screen/pos_sheet.dart';
import 'package:restaurant_pos/responsie_screens/home_screen.dart';

class Routes {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
    // home route
      case '/home':
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case '/p-listing':
        return MaterialPageRoute(
          builder: (context) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider<ImageCubit>(create: (context) => ImageCubit()),
                  BlocProvider<SelectProductSection>(
                      create: (context) => SelectProductSection()),
                  BlocProvider<ProductListingCubit>(
                      create: (context) => ProductListingCubit()),
                  BlocProvider<ProductSectionCubit>(
                      create: (context) => ProductSectionCubit()),
                ],
                child: ProductListing(),
              ),
        );

    //sales register route
      case '/s-register':
        return MaterialPageRoute(
          builder: (context) =>
              BlocProvider(
                create: (context) => SalesRegisterCubit(),
                child: SalesRegisterScreen(),
              ),
        );

    // employee route
      case '/employee':
        return MaterialPageRoute(
          builder: (context) =>
              MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SelectEmployeePositionCubit(),
                  ),
                  BlocProvider(
                    create: (context) => PickNidImage(),
                  ),
                  BlocProvider(
                    create: (context) => PickEmployeeImage(),
                  ),
                  BlocProvider(
                    create: (context) => PickEmployeeCvImage(),
                  ),
                  BlocProvider(
                    create: (context) => EmployeeCubit(),
                  ),
                  BlocProvider(create: (context) => EmployeePositionCubit())
                ],
                child: EmployeeScreen(),
              ),
        );

      case '/pos-sheet-home':
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => SheetHomeCubit(),
              child: SheetHome(),
            ),);

      case '/pos-sheet':
        return MaterialPageRoute(builder: (context) =>
            BlocProvider(
              create: (context) => SheetCubit(sheetIndex: int.parse(settings.arguments.toString())),
              child: PosSheet(),
            ),
        );


        case '/settings':
        return MaterialPageRoute(builder: (context) => SettingsScreen(),);

        case '/app-lock':
        return MaterialPageRoute(builder: (context) => AppLockScreen(),);

      case '/lock-screen':
        return MaterialPageRoute(builder: (context) => LockScreen(),);
    }
    return null;
  }
}
