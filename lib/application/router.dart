import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/presentation/product/product.view.dart';

GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      name: 'product',
      path: '/',
      builder: (context, state) {
        return const ProductView();
      }
    )
  ],
);
