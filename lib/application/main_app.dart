import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hiring_test/application/product/product.cubit.dart';
import 'package:hiring_test/application/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(),
        ),
      ],
      child: OrientationBuilder(
        builder: (context, orientation) {
          return MaterialApp.router(
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Quicksand'
            ),
            debugShowCheckedModeBanner: false,
            title: 'Product',
            routerConfig: router,
          );
        },
      ),
    );
  }
}
