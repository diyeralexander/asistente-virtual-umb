import 'package:asistente_virtual/models/note.dart';
import 'package:asistente_virtual/pages/command_page.dart';
import 'package:asistente_virtual/pages/home_page.dart';
import 'package:asistente_virtual/pages/manipulate_note.dart';
import 'package:asistente_virtual/pages/notes_page.dart';
import 'package:asistente_virtual/pages/todos_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, children: [
      AutoRoute(page: CommandPage),
      AutoRoute(page: NotesPage),
      AutoRoute(page: TodosPage),
    ]),
    AutoRoute(page: ManipulateNotePage),
  ],
)
// extend the generated private router
class AppAutoRouter extends _$AppAutoRouter {}
