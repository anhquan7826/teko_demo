import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hiring_test/presentation/edit/edit.cubit.dart';
import 'package:hiring_test/presentation/edit/edit.view.dart';

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
          name: 'edit',
          path: 'edit/:id',
          builder: (context, state) {
            return BlocProvider<EditCubit>(
              create: (context) => EditCubit(context, int.parse(state.params['id'].toString())),
              child: EditView(
                id: int.parse(state.params['id'].toString()),
              ),
            );
          },
        ),
      ],
    ),
  ],
);
