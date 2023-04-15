import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/presentation/product/product.cubit.dart';
import 'package:hiring_test/presentation/product/product.view.dart';

import '../presentation/home/home.view.dart';

GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return const HomeView();
      },
      routes: [
        GoRoute(
          name: 'product',
          path: 'product/:id',
          builder: (context, state) {
            return BlocProvider<ProductCubit>(
              create: (context) => ProductCubit(context, int.parse(state.params['id'].toString())),
              child: ProductView(
                id: int.parse(state.params['id'].toString()),
              ),
            );
          },
        )
      ],
    ),
  ],
);
