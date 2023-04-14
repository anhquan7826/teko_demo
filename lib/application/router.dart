import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/presentation/edit/edit.view.dart';
import 'package:hiring_test/presentation/product/product.view.dart';

import '../presentation/home/home.cubit.dart';
import '../presentation/home/home.view.dart';

GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return BlocProvider<HomeCubit>(
          create: (context) {
            return HomeCubit(context);
          },
          child: const HomeView(),
        );
      },
      routes: [
        GoRoute(
          name: 'product',
          path: 'product/:id',
          builder: (context, state) {
            return ProductView(
              id: int.parse(state.params['id'].toString()),
            );
          },
          routes: [
            GoRoute(
              name: 'edit',
              path: 'edit',
              builder: (context, state) {
                return EditView(
                  id: int.parse(state.params['id'].toString()),
                );
              },
            )
          ],
        ),
      ],
    ),
  ],
);
