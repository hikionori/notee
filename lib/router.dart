import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notee/pages/add_note_page.dart';
import 'package:notee/pages/home_page.dart';
import 'package:notee/pages/view_edit_note_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(
        child: HomePage(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          pageBuilder: (context, state) =>
              const MaterialPage(child: AddNotePage()),
        ),
        GoRoute(
          path: 'view_edit/:id',
          pageBuilder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return MaterialPage(
              child: ViewEditNotePage(id: id),
            );
          },
        ),
      ],
    ),
  ],
);
